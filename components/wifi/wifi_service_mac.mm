// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "components/wifi/wifi_service.h"

#import <netinet/in.h>
#import <CoreWLAN/CoreWLAN.h>
#import <SystemConfiguration/SystemConfiguration.h>

#include "base/bind.h"
#include "base/mac/foundation_util.h"
#include "base/mac/scoped_cftyperef.h"
#include "base/mac/scoped_nsobject.h"
#include "base/message_loop/message_loop.h"
#include "base/strings/sys_string_conversions.h"
#include "components/onc/onc_constants.h"

#if !defined(MAC_OS_X_VERSION_10_7) || \
    MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_7

// Local definitions of API added in Mac OS X 10.7

@interface CWInterface (LionAPI)
- (BOOL)associateToNetwork:(CWNetwork*)network
                  password:(NSString*)password
                     error:(NSError**)error;
- (NSSet*)scanForNetworksWithName:(NSString*)networkName
                            error:(NSError**)error;
@end

enum CWChannelBand {
  kCWChannelBandUnknown = 0,
  kCWChannelBand2GHz = 1,
  kCWChannelBand5GHz = 2,
};

@interface CWChannel : NSObject
@property(readonly) CWChannelBand channelBand;
@end

@interface CWNetwork (LionAPI)
@property(readonly) CWChannel* wlanChannel;
@end

#endif  // 10.7

namespace wifi {

const char kErrorAssociateToNetwork[] = "Error.AssociateToNetwork";
const char kErrorInvalidData[] = "Error.InvalidData";
const char kErrorNotConnected[] = "Error.NotConnected";
const char kErrorNotFound[] = "Error.NotFound";
const char kErrorNotImplemented[] = "Error.NotImplemented";
const char kErrorScanForNetworksWithName[] = "Error.ScanForNetworksWithName";

// Implementation of WiFiService for Mac OS X.
class WiFiServiceMac : public WiFiService {
 public:
  WiFiServiceMac();
  virtual ~WiFiServiceMac();

  // WiFiService interface implementation.
  virtual void Initialize(
      scoped_refptr<base::SequencedTaskRunner> task_runner) OVERRIDE;

  virtual void UnInitialize() OVERRIDE;

  virtual void GetProperties(const std::string& network_guid,
                             base::DictionaryValue* properties,
                             std::string* error) OVERRIDE;

  virtual void GetManagedProperties(const std::string& network_guid,
                                    base::DictionaryValue* managed_properties,
                                    std::string* error) OVERRIDE;

  virtual void GetState(const std::string& network_guid,
                        base::DictionaryValue* properties,
                        std::string* error) OVERRIDE;

  virtual void SetProperties(const std::string& network_guid,
                             scoped_ptr<base::DictionaryValue> properties,
                             std::string* error) OVERRIDE;

  virtual void CreateNetwork(bool shared,
                             scoped_ptr<base::DictionaryValue> properties,
                             std::string* network_guid,
                             std::string* error) OVERRIDE;

  virtual void GetVisibleNetworks(const std::string& network_type,
                                  base::ListValue* network_list) OVERRIDE;

  virtual void RequestNetworkScan() OVERRIDE;

  virtual void StartConnect(const std::string& network_guid,
                            std::string* error) OVERRIDE;

  virtual void StartDisconnect(const std::string& network_guid,
                               std::string* error) OVERRIDE;

  virtual void GetKeyFromSystem(const std::string& network_guid,
                                std::string* key_data,
                                std::string* error) OVERRIDE;

  virtual void SetEventObservers(
      scoped_refptr<base::MessageLoopProxy> message_loop_proxy,
      const NetworkGuidListCallback& networks_changed_observer,
      const NetworkGuidListCallback& network_list_changed_observer) OVERRIDE;

  virtual void RequestConnectedNetworkUpdate() OVERRIDE;

 private:
  // Checks |ns_error| and if is not |nil|, then stores |error_name|
  // into |error|.
  bool CheckError(NSError* ns_error,
                  const char* error_name,
                  std::string* error) const;

  // Gets |ssid| from unique |network_guid|.
  NSString* SSIDFromGUID(const std::string& network_guid) const {
    return base::SysUTF8ToNSString(network_guid);
  }

  // Gets unique |network_guid| string based on |ssid|.
  std::string GUIDFromSSID(NSString* ssid) const {
    return base::SysNSStringToUTF8(ssid);
  }

  // Populates |properties| from |network|.
  void NetworkPropertiesFromCWNetwork(const CWNetwork* network,
                                      NetworkProperties* properties) const;

  // Converts |CWSecurityMode| into onc::wifi::k{WPA|WEP}* security constant.
  std::string SecurityFromCWSecurityMode(CWSecurityMode security) const;

  // Converts |CWChannelBand| into WiFiService::Frequency constant.
  Frequency FrequencyFromCWChannelBand(CWChannelBand band) const;

  // Gets current |onc::connection_state| for given |network_guid|.
  std::string GetNetworkConnectionState(const std::string& network_guid) const;

  // Updates |networks_| with the list of visible wireless networks.
  void UpdateNetworks();

  // Find network by |network_guid| and return iterator to its entry in
  // |networks_|.
  NetworkList::iterator FindNetwork(const std::string& network_guid);

  // Handles notification from |wlan_observer_|.
  void OnWlanObserverNotification();

  // Notifies |network_list_changed_observer_| that list of visible networks has
  // changed to |networks|.
  void NotifyNetworkListChanged(const NetworkList& networks);

  // Notifies |networks_changed_observer_| that network |network_guid|
  // connection state has changed.
  void NotifyNetworkChanged(const std::string& network_guid);

  // Default interface.
  base::scoped_nsobject<CWInterface> interface_;
  // WLAN Notifications observer. |this| doesn't own this reference.
  id wlan_observer_;

  // Observer to get notified when network(s) have changed (e.g. connect).
  NetworkGuidListCallback networks_changed_observer_;
  // Observer to get notified when network list has changed.
  NetworkGuidListCallback network_list_changed_observer_;
  // MessageLoopProxy to which events should be posted.
  scoped_refptr<base::MessageLoopProxy> message_loop_proxy_;
  // Task runner for worker tasks.
  scoped_refptr<base::SequencedTaskRunner> task_runner_;
  // Cached list of visible networks. Updated by |UpdateNetworks|.
  NetworkList networks_;
  // Guid of last known connected network.
  std::string connected_network_guid_;
  // Temporary storage of network properties indexed by |network_guid|.
  base::DictionaryValue network_properties_;

  DISALLOW_COPY_AND_ASSIGN(WiFiServiceMac);
};

WiFiServiceMac::WiFiServiceMac() : wlan_observer_(nil) {
}

WiFiServiceMac::~WiFiServiceMac() {
}

void WiFiServiceMac::Initialize(
  scoped_refptr<base::SequencedTaskRunner> task_runner) {
  task_runner_.swap(task_runner);
  interface_.reset([[CWInterface interface] retain]);
  if (!interface_) {
    DVLOG(1) << "Failed to initialize default interface.";
    return;
  }

  if (![interface_
          respondsToSelector:@selector(associateToNetwork:password:error:)]) {
    DVLOG(1) << "CWInterface does not support associateToNetwork.";
    interface_.reset();
    return;
  }
}

void WiFiServiceMac::UnInitialize() {
  if (wlan_observer_)
    [[NSNotificationCenter defaultCenter] removeObserver:wlan_observer_];
  interface_.reset();
}

void WiFiServiceMac::GetProperties(const std::string& network_guid,
                                   base::DictionaryValue* properties,
                                   std::string* error) {
  NetworkList::iterator it = FindNetwork(network_guid);
  if (it == networks_.end()) {
    DVLOG(1) << "Network not found:" << network_guid;
    *error = kErrorNotFound;
    return;
  }

  it->connection_state = GetNetworkConnectionState(network_guid);
  scoped_ptr<base::DictionaryValue> network(it->ToValue(false));
  properties->Swap(network.get());
  DVLOG(1) << *properties;
}

void WiFiServiceMac::GetManagedProperties(
    const std::string& network_guid,
    base::DictionaryValue* managed_properties,
    std::string* error) {
  *error = kErrorNotImplemented;
}

void WiFiServiceMac::GetState(const std::string& network_guid,
                              base::DictionaryValue* properties,
                              std::string* error) {
  *error = kErrorNotImplemented;
}

void WiFiServiceMac::SetProperties(
    const std::string& network_guid,
    scoped_ptr<base::DictionaryValue> properties,
    std::string* error) {
  network_properties_.SetWithoutPathExpansion(network_guid,
                                              properties.release());
}

void WiFiServiceMac::CreateNetwork(
    bool shared,
    scoped_ptr<base::DictionaryValue> properties,
    std::string* network_guid,
    std::string* error) {
  WiFiService::NetworkProperties network_properties;
  if (!network_properties.UpdateFromValue(*properties)) {
    *error = kErrorInvalidData;
    return;
  }

  std::string guid = network_properties.ssid;
  if (FindNetwork(guid) != networks_.end()) {
    *error = kErrorInvalidData;
    return;
  }
  network_properties_.SetWithoutPathExpansion(guid,
                                              properties.release());
  *network_guid = guid;
}

void WiFiServiceMac::GetVisibleNetworks(const std::string& network_type,
                                        base::ListValue* network_list) {
  if (!network_type.empty() &&
      network_type != onc::network_type::kAllTypes &&
      network_type != onc::network_type::kWiFi) {
    return;
  }

  if (networks_.empty())
    UpdateNetworks();

  for (WiFiService::NetworkList::const_iterator it = networks_.begin();
       it != networks_.end();
       ++it) {
    scoped_ptr<base::DictionaryValue> network(it->ToValue(true));
    network_list->Append(network.release());
  }
}

void WiFiServiceMac::RequestNetworkScan() {
  DVLOG(1) << "*** RequestNetworkScan";
  UpdateNetworks();
}

void WiFiServiceMac::StartConnect(const std::string& network_guid,
                                  std::string* error) {
  NSError* ns_error = nil;

  DVLOG(1) << "*** StartConnect: " << network_guid;
  // Remember previously connected network.
  std::string connected_network_guid = GUIDFromSSID([interface_ ssid]);
  // Check whether desired network is already connected.
  if (network_guid == connected_network_guid)
    return;

  NSSet* networks = [interface_
      scanForNetworksWithName:SSIDFromGUID(network_guid)
                        error:&ns_error];

  if (CheckError(ns_error, kErrorScanForNetworksWithName, error))
    return;

  CWNetwork* network = [networks anyObject];
  if (network == nil) {
    // System can't find the network, remove it from the |networks_| and notify
    // observers.
    NetworkList::iterator it = FindNetwork(connected_network_guid);
    if (it != networks_.end()) {
      networks_.erase(it);
      // Notify observers that list has changed.
      NotifyNetworkListChanged(networks_);
    }

    *error = kErrorNotFound;
    return;
  }

  // Check whether WiFi Password is set in |network_properties_|.
  base::DictionaryValue* properties;
  base::DictionaryValue* wifi;
  std::string passphrase;
  NSString* ns_password = nil;
  if (network_properties_.GetDictionaryWithoutPathExpansion(network_guid,
                                                            &properties) &&
      properties->GetDictionary(onc::network_type::kWiFi, &wifi) &&
      wifi->GetString(onc::wifi::kPassphrase, &passphrase)) {
    ns_password = base::SysUTF8ToNSString(passphrase);
  }

  // Number of attempts to associate to network.
  static const int kMaxAssociationAttempts = 3;
  // Try to associate to network several times if timeout or PMK error occurs.
  for (int i = 0; i < kMaxAssociationAttempts; ++i) {
    // Nil out the PMK to prevent stale data from causing invalid PMK error
    // (CoreWLANTypes -3924).
    [interface_ setPairwiseMasterKey:nil error:&ns_error];
    if (![interface_ associateToNetwork:network
                              password:ns_password
                                 error:&ns_error]) {
      NSInteger error_code = [ns_error code];
      if (error_code != kCWTimeoutErr && error_code != kCWInvalidPMKErr) {
        break;
      }
    }
  }
  CheckError(ns_error, kErrorAssociateToNetwork, error);
}

void WiFiServiceMac::StartDisconnect(const std::string& network_guid,
                                     std::string* error) {
  DVLOG(1) << "*** StartDisconnect: " << network_guid;

  if (network_guid == GUIDFromSSID([interface_ ssid])) {
    // Power-cycle the interface to disconnect from current network and connect
    // to default network.
    NSError* ns_error = nil;
    [interface_ setPower:NO error:&ns_error];
    CheckError(ns_error, kErrorAssociateToNetwork, error);
    [interface_ setPower:YES error:&ns_error];
    CheckError(ns_error, kErrorAssociateToNetwork, error);
  } else {
    *error = kErrorNotConnected;
  }
}

void WiFiServiceMac::GetKeyFromSystem(const std::string& network_guid,
                                      std::string* key_data,
                                      std::string* error) {
  static const char kAirPortServiceName[] = "AirPort";

  UInt32 password_length = 0;
  void *password_data = NULL;
  OSStatus status = SecKeychainFindGenericPassword(NULL,
                                                   strlen(kAirPortServiceName),
                                                   kAirPortServiceName,
                                                   network_guid.length(),
                                                   network_guid.c_str(),
                                                   &password_length,
                                                   &password_data,
                                                   NULL);
  if (status != errSecSuccess) {
    *error = kErrorNotFound;
    return;
  }

  if (password_data) {
    *key_data = std::string(reinterpret_cast<char*>(password_data),
                            password_length);
    SecKeychainItemFreeContent(NULL, password_data);
  }
}

void WiFiServiceMac::SetEventObservers(
    scoped_refptr<base::MessageLoopProxy> message_loop_proxy,
    const NetworkGuidListCallback& networks_changed_observer,
    const NetworkGuidListCallback& network_list_changed_observer) {
  message_loop_proxy_.swap(message_loop_proxy);
  networks_changed_observer_ = networks_changed_observer;
  network_list_changed_observer_ = network_list_changed_observer;

  // Remove previous OS notifications observer.
  if (wlan_observer_) {
    [[NSNotificationCenter defaultCenter] removeObserver:wlan_observer_];
    wlan_observer_ = nil;
  }

  // Subscribe to OS notifications.
  if (!networks_changed_observer_.is_null()) {
    void (^ns_observer) (NSNotification* notification) =
        ^(NSNotification* notification) {
            DVLOG(1) << "Received CWSSIDDidChangeNotification";
            task_runner_->PostTask(
                FROM_HERE,
                base::Bind(&WiFiServiceMac::OnWlanObserverNotification,
                           base::Unretained(this)));
    };

    wlan_observer_ = [[NSNotificationCenter defaultCenter]
        addObserverForName:kCWSSIDDidChangeNotification
                    object:nil
                     queue:nil
                usingBlock:ns_observer];
  }
}

void WiFiServiceMac::RequestConnectedNetworkUpdate() {
  OnWlanObserverNotification();
}

std::string WiFiServiceMac::GetNetworkConnectionState(
    const std::string& network_guid) const {
  if (network_guid != GUIDFromSSID([interface_ ssid]))
    return onc::connection_state::kNotConnected;

  // Check whether WiFi network is reachable.
  struct sockaddr_in local_wifi_address;
  bzero(&local_wifi_address, sizeof(local_wifi_address));
  local_wifi_address.sin_len = sizeof(local_wifi_address);
  local_wifi_address.sin_family = AF_INET;
  local_wifi_address.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
  base::ScopedCFTypeRef<SCNetworkReachabilityRef> reachability(
      SCNetworkReachabilityCreateWithAddress(
          kCFAllocatorDefault,
          reinterpret_cast<const struct sockaddr*>(&local_wifi_address)));
  SCNetworkReachabilityFlags flags = 0u;
  if (SCNetworkReachabilityGetFlags(reachability, &flags) &&
      (flags & kSCNetworkReachabilityFlagsReachable) &&
      (flags & kSCNetworkReachabilityFlagsIsDirect)) {
    // Network is reachable, report is as |kConnected|.
    return onc::connection_state::kConnected;
  }
  // Network is not reachable yet, so it must be |kConnecting|.
  return onc::connection_state::kConnecting;
}

void WiFiServiceMac::UpdateNetworks() {
  NSError* ns_error = nil;
  NSSet* cw_networks = [interface_ scanForNetworksWithName:nil
                                                     error:&ns_error];
  if (ns_error != nil)
    return;

  std::string connected_bssid = base::SysNSStringToUTF8([interface_ bssid]);
  std::map<std::string, NetworkProperties*> network_properties_map;
  networks_.clear();

  // There is one |cw_network| per BSS in |cw_networks|, so go through the set
  // and combine them, paying attention to supported frequencies.
  for (CWNetwork* cw_network in cw_networks) {
    std::string network_guid = GUIDFromSSID([cw_network ssid]);
    bool update_all_properties = false;

    if (network_properties_map.find(network_guid) ==
            network_properties_map.end()) {
      networks_.push_back(NetworkProperties());
      network_properties_map[network_guid] = &networks_.back();
      update_all_properties = true;
    }
    // If current network is connected, use its properties for this network.
    if (base::SysNSStringToUTF8([cw_network bssid]) == connected_bssid)
      update_all_properties = true;

    NetworkProperties* properties = network_properties_map.at(network_guid);
    if (update_all_properties) {
      NetworkPropertiesFromCWNetwork(cw_network, properties);
    } else {
      properties->frequency_set.insert(FrequencyFromCWChannelBand(
          [[cw_network wlanChannel] channelBand]));
    }
  }
  // Sort networks, so connected/connecting is up front.
  networks_.sort(NetworkProperties::OrderByType);
  // Notify observers that list has changed.
  NotifyNetworkListChanged(networks_);
}

bool WiFiServiceMac::CheckError(NSError* ns_error,
                                const char* error_name,
                                std::string* error) const {
  if (ns_error != nil) {
    DLOG(ERROR) << "*** Error:" << error_name << ":" << [ns_error code];
    *error = error_name;
    return true;
  }
  return false;
}

void WiFiServiceMac::NetworkPropertiesFromCWNetwork(
    const CWNetwork* network,
    NetworkProperties* properties) const {
  std::string network_guid = GUIDFromSSID([network ssid]);

  properties->connection_state = GetNetworkConnectionState(network_guid);
  properties->ssid = base::SysNSStringToUTF8([network ssid]);
  properties->name = properties->ssid;
  properties->guid = network_guid;
  properties->type = onc::network_type::kWiFi;

  properties->bssid = base::SysNSStringToUTF8([network bssid]);
  properties->frequency = FrequencyFromCWChannelBand(
      static_cast<CWChannelBand>([[network wlanChannel] channelBand]));
  properties->frequency_set.insert(properties->frequency);
  properties->security = SecurityFromCWSecurityMode(
      static_cast<CWSecurityMode>([[network securityMode] intValue]));

  properties->signal_strength = [[network rssi] intValue];
}

std::string WiFiServiceMac::SecurityFromCWSecurityMode(
    CWSecurityMode security) const {
  switch (security) {
    case kCWSecurityModeWPA_Enterprise:
    case kCWSecurityModeWPA2_Enterprise:
      return onc::wifi::kWPA_EAP;
    case kCWSecurityModeWPA_PSK:
    case kCWSecurityModeWPA2_PSK:
      return onc::wifi::kWPA_PSK;
    case kCWSecurityModeWEP:
      return onc::wifi::kWEP_PSK;
    case kCWSecurityModeOpen:
      return onc::wifi::kNone;
    // TODO(mef): Figure out correct mapping.
    case kCWSecurityModeWPS:
    case kCWSecurityModeDynamicWEP:
      return onc::wifi::kWPA_EAP;
  }
  return onc::wifi::kWPA_EAP;
}


WiFiService::Frequency WiFiServiceMac::FrequencyFromCWChannelBand(
    CWChannelBand band) const {
  return band == kCWChannelBand2GHz ? kFrequency2400 : kFrequency5000;
}

WiFiService::NetworkList::iterator WiFiServiceMac::FindNetwork(
    const std::string& network_guid) {
  for (NetworkList::iterator it = networks_.begin();
       it != networks_.end();
       ++it) {
    if (it->guid == network_guid)
      return it;
  }
  return networks_.end();
}

void WiFiServiceMac::OnWlanObserverNotification() {
  std::string connected_network_guid = GUIDFromSSID([interface_ ssid]);
  DVLOG(1) << " *** Got Notification: " << connected_network_guid;
  // Connected network has changed, mark previous one disconnected.
  if (connected_network_guid != connected_network_guid_) {
    // Update connection_state of newly connected network.
    NetworkList::iterator it = FindNetwork(connected_network_guid_);
    if (it != networks_.end()) {
      it->connection_state = onc::connection_state::kNotConnected;
      NotifyNetworkChanged(connected_network_guid_);
    }
    connected_network_guid_ = connected_network_guid;
  }

  if (!connected_network_guid.empty()) {
    // Update connection_state of newly connected network.
    NetworkList::iterator it = FindNetwork(connected_network_guid);
    if (it != networks_.end()) {
      it->connection_state = GetNetworkConnectionState(connected_network_guid);
    } else {
      // Can't find |connected_network_guid| in |networks_|, try to update it.
      UpdateNetworks();
    }
    // Notify that network is connecting.
    NotifyNetworkChanged(connected_network_guid);
    // Further network change notification will be sent by detector.
  }
}

void WiFiServiceMac::NotifyNetworkListChanged(const NetworkList& networks) {
  if (network_list_changed_observer_.is_null())
    return;

  NetworkGuidList current_networks;
  for (NetworkList::const_iterator it = networks.begin();
       it != networks.end();
       ++it) {
    current_networks.push_back(it->guid);
  }

  message_loop_proxy_->PostTask(
      FROM_HERE,
      base::Bind(network_list_changed_observer_, current_networks));
}

void WiFiServiceMac::NotifyNetworkChanged(const std::string& network_guid) {
  if (networks_changed_observer_.is_null())
    return;

  DVLOG(1) << "NotifyNetworkChanged: " << network_guid;
  NetworkGuidList changed_networks(1, network_guid);
  message_loop_proxy_->PostTask(
      FROM_HERE,
      base::Bind(networks_changed_observer_, changed_networks));
}

// static
WiFiService* WiFiService::Create() { return new WiFiServiceMac(); }

}  // namespace wifi
