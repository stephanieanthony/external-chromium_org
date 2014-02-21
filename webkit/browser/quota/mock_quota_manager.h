// Copyright 2013 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef WEBKIT_BROWSER_QUOTA_MOCK_QUOTA_MANAGER_H_
#define WEBKIT_BROWSER_QUOTA_MOCK_QUOTA_MANAGER_H_

#include <map>
#include <set>
#include <utility>
#include <vector>

#include "base/memory/scoped_ptr.h"
#include "url/gurl.h"
#include "webkit/browser/quota/quota_client.h"
#include "webkit/browser/quota/quota_manager.h"
#include "webkit/browser/quota/quota_task.h"
#include "webkit/common/quota/quota_types.h"

namespace quota {

// Mocks the pieces of QuotaManager's interface.
//
// For usage/quota tracking test:
// Usage and quota information can be updated by following private helper
// methods: SetQuota() and UpdateUsage().
//
// For time-based deletion test:
// Origins can be added to the mock by calling AddOrigin, and that list of
// origins is then searched through in GetOriginsModifiedSince.
// Neither GetOriginsModifiedSince nor DeleteOriginData touches the actual
// origin data stored in the profile.
class MockQuotaManager : public QuotaManager {
 public:
  MockQuotaManager(bool is_incognito,
                   const base::FilePath& profile_path,
                   base::SingleThreadTaskRunner* io_thread,
                   base::SequencedTaskRunner* db_thread,
                   SpecialStoragePolicy* special_storage_policy);

  // Overrides QuotaManager's implementation. The internal usage data is
  // updated when MockQuotaManagerProxy::NotifyStorageModified() is
  // called.  The internal quota value can be updated by calling
  // a helper method MockQuotaManagerProxy::SetQuota().
  virtual void GetUsageAndQuota(
      const GURL& origin,
      quota::StorageType type,
      const GetUsageAndQuotaCallback& callback) OVERRIDE;

  // Overrides QuotaManager's implementation with a canned implementation that
  // allows clients to set up the origin database that should be queried. This
  // method will only search through the origins added explicitly via AddOrigin.
  virtual void GetOriginsModifiedSince(
      StorageType type,
      base::Time modified_since,
      const GetOriginsCallback& callback) OVERRIDE;

  // Removes an origin from the canned list of origins, but doesn't touch
  // anything on disk. The caller must provide |quota_client_mask| which
  // specifies the types of QuotaClients which should be removed from this
  // origin as a bitmask built from QuotaClient::IDs. Setting the mask to
  // QuotaClient::kAllClientsMask will remove all clients from the origin,
  // regardless of type.
  virtual void DeleteOriginData(const GURL& origin,
                                StorageType type,
                                int quota_client_mask,
                                const StatusCallback& callback) OVERRIDE;

  // Helper method for updating internal quota info.
  void SetQuota(const GURL& origin, StorageType type, int64 quota);

  // Helper methods for timed-deletion testing:
  // Adds an origin to the canned list that will be searched through via
  // GetOriginsModifiedSince. The caller must provide |quota_client_mask|
  // which specifies the types of QuotaClients this canned origin contains
  // as a bitmask built from QuotaClient::IDs.
  bool AddOrigin(const GURL& origin,
                 StorageType type,
                 int quota_client_mask,
                 base::Time modified);

  // Helper methods for timed-deletion testing:
  // Checks an origin and type against the origins that have been added via
  // AddOrigin and removed via DeleteOriginData. If the origin exists in the
  // canned list with the proper StorageType and client, returns true.
  bool OriginHasData(const GURL& origin,
                     StorageType type,
                     QuotaClient::ID quota_client) const;

 protected:
  virtual ~MockQuotaManager();

 private:
  friend class MockQuotaManagerProxy;

  // Contains the essential bits of information about an origin that the
  // MockQuotaManager needs to understand for time-based deletion:
  // the origin itself, the StorageType and its modification time.
  struct OriginInfo {
    OriginInfo(const GURL& origin,
               StorageType type,
               int quota_client_mask,
               base::Time modified);
    ~OriginInfo();

    GURL origin;
    StorageType type;
    int quota_client_mask;
    base::Time modified;
  };

  // Contains the essential information for each origin for usage/quota testing.
  // (Ideally this should probably merged into the above struct, but for
  // regular usage/quota testing we hardly need modified time but only
  // want to keep usage and quota information, so this struct exists.
  struct StorageInfo {
    StorageInfo();
    ~StorageInfo();
    int64 usage;
    int64 quota;
  };

  typedef std::pair<GURL, StorageType> OriginAndType;
  typedef std::map<OriginAndType, StorageInfo> UsageAndQuotaMap;

  // This must be called via MockQuotaManagerProxy.
  void UpdateUsage(const GURL& origin, StorageType type, int64 delta);
  void DidGetModifiedSince(const GetOriginsCallback& callback,
                           std::set<GURL>* origins,
                           StorageType storage_type);
  void DidDeleteOriginData(const StatusCallback& callback,
                           QuotaStatusCode status);

  // The list of stored origins that have been added via AddOrigin.
  std::vector<OriginInfo> origins_;
  UsageAndQuotaMap usage_and_quota_map_;
  base::WeakPtrFactory<MockQuotaManager> weak_factory_;

  DISALLOW_COPY_AND_ASSIGN(MockQuotaManager);
};

}  // namespace quota

#endif  // WEBKIT_BROWSER_QUOTA_MOCK_QUOTA_MANAGER_H_
