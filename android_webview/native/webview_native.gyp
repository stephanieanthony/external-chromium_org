# Copyright (c) 2012 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
{
  'variables': {
    'chromium_code': 1,
  },
  'targets': [
    {
      'target_name': 'webview_native',
      'type': 'static_library',
      'dependencies': [
        '../../base/base.gyp:base_static',
        '../../base/third_party/dynamic_annotations/dynamic_annotations.gyp:dynamic_annotations',
        '../../components/components.gyp:autofill_content_browser',
        '../../components/components.gyp:web_contents_delegate_android',
        '../../cc/cc.gyp:cc',
        '../../net/net.gyp:net',
        '../../skia/skia.gyp:skia',
        '../../ui/ui.gyp:ui',
        '../../webkit/common/user_agent/webkit_user_agent.gyp:user_agent',
        '../../webkit/common/webkit_common.gyp:webkit_common',
        '../../webkit/storage_browser.gyp:webkit_storage_browser',
        '../../webkit/storage_common.gyp:webkit_storage_common',
        'android_webview_native_jni',
      ],
      'include_dirs': [
        '../..',
        '../../skia/config',
        '<(SHARED_INTERMEDIATE_DIR)/android_webview',
      ],
      'sources': [
        'android_protocol_handler.cc',
        'android_protocol_handler.h',
        'android_webview_jni_registrar.cc',
        'android_webview_jni_registrar.h',
        'aw_autofill_manager_delegate.cc',
        'aw_autofill_manager_delegate.h',
        'aw_browser_dependency_factory.cc',
        'aw_browser_dependency_factory.h',
        'aw_contents.cc',
        'aw_contents.h',
        'aw_contents_client_bridge.cc',
        'aw_contents_client_bridge.h',
        'aw_contents_io_thread_client_impl.cc',
        'aw_contents_io_thread_client_impl.h',
        'aw_form_database.cc',
        'aw_form_database.h',
        'aw_geolocation_permission_context.cc',
        'aw_geolocation_permission_context.h',
        'aw_http_auth_handler.cc',
        'aw_http_auth_handler.h',
        'aw_picture.cc',
        'aw_picture.h',
        'aw_quota_manager_bridge_impl.cc',
        'aw_quota_manager_bridge_impl.h',
        'aw_resource.cc',
        'aw_resource.h',
        'aw_settings.cc',
        'aw_settings.h',
        'aw_web_contents_delegate.cc',
        'aw_web_contents_delegate.h',
        'aw_web_contents_view_delegate.cc',
        'aw_web_contents_view_delegate.h',
        'cookie_manager.cc',
        'cookie_manager.h',
        'input_stream_impl.cc',
        'input_stream_impl.h',
        'intercepted_request_data_impl.cc',
        'intercepted_request_data_impl.h',
        'java_browser_view_renderer_helper.cc',
        'java_browser_view_renderer_helper.h',
        'net_init_native_callback.cc',
# START: Printing fork b/10190508
        'aw_pdf_exporter.cc',
        'aw_pdf_exporter.h',
        'skia_java_output_stream.cc',
        'skia_java_output_stream.h',
# END: Printing fork b/10190508
        'state_serializer.cc',
        'state_serializer.h',
      ],
    },
    {
      'target_name': 'android_jar_jni_headers',
      'type': 'none',
      'variables': {
        'jni_gen_package': 'android_webview',
        'input_java_class': 'java/io/InputStream.class',
      },
      'includes': [ '../../build/jar_file_jni_generator.gypi' ],
    },
# START: Printing fork b/10190508
    {
      'target_name': 'output_stream_android_jar_jni_headers',
      'type': 'none',
      'variables': {
        'jni_gen_package': 'android_webview',
        'input_java_class': 'java/io/OutputStream.class',
      },
      'includes': [ '../../build/jar_file_jni_generator.gypi' ],
    },
    {
      'target_name': 'cancellation_signal_android_jar_jni_headers',
      'type': 'none',
      'variables': {
        'jni_gen_package': 'android_webview',
        'input_java_class': 'android/os/CancellationSignal.class',
      },
      'includes': [ '../../build/jar_file_jni_generator.gypi' ],
    },
# END: Printing fork b/10190508
    {
      'target_name': 'android_webview_native_jni',
      'type': 'none',
      'sources': [
          '../java/src/org/chromium/android_webview/AndroidProtocolHandler.java',
          '../java/src/org/chromium/android_webview/AwAutofillManagerDelegate.java',
          '../java/src/org/chromium/android_webview/AwContents.java',
          '../java/src/org/chromium/android_webview/AwContentsClientBridge.java',
          '../java/src/org/chromium/android_webview/AwContentsIoThreadClient.java',
          '../java/src/org/chromium/android_webview/AwCookieManager.java',
          '../java/src/org/chromium/android_webview/AwFormDatabase.java',
          '../java/src/org/chromium/android_webview/AwHttpAuthHandler.java',
          '../java/src/org/chromium/android_webview/AwPicture.java',
          '../java/src/org/chromium/android_webview/AwQuotaManagerBridge.java',
          '../java/src/org/chromium/android_webview/AwResource.java',
          '../java/src/org/chromium/android_webview/AwSettings.java',
          '../java/src/org/chromium/android_webview/AwWebContentsDelegate.java',
          '../java/src/org/chromium/android_webview/InterceptedRequestData.java',
          '../java/src/org/chromium/android_webview/JavaBrowserViewRendererHelper.java',
# START: Printing fork b/10190508
          '../java/src/org/chromium/android_webview/AwPdfExporter.java',
# END: Printing fork b/10190508
      ],
      'variables': {
        'jni_gen_package': 'android_webview',
      },
      'includes': [ '../../build/jni_generator.gypi' ],
      'dependencies': [
        'android_jar_jni_headers',
# START: Printing fork b/10190508
# TODO(sgurun) rename the android_jar_jni_headers (above) to input_stream_android_jar_jni_headers
        'output_stream_android_jar_jni_headers',
        'cancellation_signal_android_jar_jni_headers',
# END: Printing fork b/10190508
      ],
    },
  ],
}
