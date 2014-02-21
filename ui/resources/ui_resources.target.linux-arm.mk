# This file is generated by gyp; do not edit.

include $(CLEAR_VARS)

LOCAL_MODULE_CLASS := GYP
LOCAL_MODULE := ui_resources_ui_resources_gyp
LOCAL_MODULE_STEM := ui_resources
LOCAL_MODULE_SUFFIX := .stamp
LOCAL_MODULE_TAGS := optional
gyp_intermediate_dir := $(call local-intermediates-dir)
gyp_shared_intermediate_dir := $(call intermediates-dir-for,GYP,shared)

# Make sure our deps are built first.
GYP_TARGET_DEPENDENCIES :=

### Rules for action "ui_resources":
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h: gyp_local_path := $(LOCAL_PATH)
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h: gyp_intermediate_dir := $(abspath $(gyp_intermediate_dir))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h: gyp_shared_intermediate_dir := $(abspath $(gyp_shared_intermediate_dir))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h: export PATH := $(subst $(ANDROID_BUILD_PATHS),,$(PATH))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h: $(LOCAL_PATH)/tools/gritsettings/resource_ids $(LOCAL_PATH)/ui/resources/ui_resources.grd $(LOCAL_PATH)/ui/resources/default_100_percent/close_2.png $(LOCAL_PATH)/ui/resources/default_100_percent/close_2_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/close_2_mask.png $(LOCAL_PATH)/ui/resources/default_100_percent/close_2_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/close_dialog.png $(LOCAL_PATH)/ui/resources/default_100_percent/close_dialog_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/close_dialog_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/browser_action_badge_center.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/browser_action_badge_left.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/browser_action_badge_right.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkmark.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/default_favicon.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/default_favicon_32.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/default_favicon_64.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/folder_closed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/folder_closed_rtl.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/message_close.png $(LOCAL_PATH)/ui/resources/default_100_percent/cros/menu_droparrow.png $(LOCAL_PATH)/ui/resources/default_100_percent/linux/linux-progress-bar.png $(LOCAL_PATH)/ui/resources/default_100_percent/linux/linux-progress-border-left.png $(LOCAL_PATH)/ui/resources/default_100_percent/linux/linux-progress-border-right.png $(LOCAL_PATH)/ui/resources/default_100_percent/linux/linux-progress-value.png $(LOCAL_PATH)/ui/resources/default_100_percent/throbber.png $(LOCAL_PATH)/ui/resources/default_200_percent/close_2.png $(LOCAL_PATH)/ui/resources/default_200_percent/close_2_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/close_2_mask.png $(LOCAL_PATH)/ui/resources/default_200_percent/close_2_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/close_dialog.png $(LOCAL_PATH)/ui/resources/default_200_percent/close_dialog_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/close_dialog_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/browser_action_badge_center.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/browser_action_badge_left.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/browser_action_badge_right.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkmark.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/default_favicon.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/folder_closed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/folder_closed_rtl.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/message_close.png $(LOCAL_PATH)/ui/resources/default_200_percent/cros/menu_droparrow.png $(LOCAL_PATH)/ui/resources/default_200_percent/throbber.png $(LOCAL_PATH)/tools/grit/PRESUBMIT.py $(LOCAL_PATH)/tools/grit/grit.py $(LOCAL_PATH)/tools/grit/grit/__init__.py $(LOCAL_PATH)/tools/grit/grit/clique.py $(LOCAL_PATH)/tools/grit/grit/constants.py $(LOCAL_PATH)/tools/grit/grit/exception.py $(LOCAL_PATH)/tools/grit/grit/extern/BogoFP.py $(LOCAL_PATH)/tools/grit/grit/extern/FP.py $(LOCAL_PATH)/tools/grit/grit/extern/__init__.py $(LOCAL_PATH)/tools/grit/grit/extern/tclib.py $(LOCAL_PATH)/tools/grit/grit/format/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/android_xml.py $(LOCAL_PATH)/tools/grit/grit/format/c_format.py $(LOCAL_PATH)/tools/grit/grit/format/chrome_messages_json.py $(LOCAL_PATH)/tools/grit/grit/format/data_pack.py $(LOCAL_PATH)/tools/grit/grit/format/html_inline.py $(LOCAL_PATH)/tools/grit/grit/format/js_map_format.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/PRESUBMIT.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/policy_template_generator.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/template_formatter.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writer_configuration.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/adm_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/adml_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/admx_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/doc_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/json_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/mock_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_helper.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_strings_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/reg_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/template_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/writer_unittest_common.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/xml_formatted_writer.py $(LOCAL_PATH)/tools/grit/grit/format/rc.py $(LOCAL_PATH)/tools/grit/grit/format/rc_header.py $(LOCAL_PATH)/tools/grit/grit/format/repack.py $(LOCAL_PATH)/tools/grit/grit/format/resource_map.py $(LOCAL_PATH)/tools/grit/grit/gather/__init__.py $(LOCAL_PATH)/tools/grit/grit/gather/admin_template.py $(LOCAL_PATH)/tools/grit/grit/gather/chrome_html.py $(LOCAL_PATH)/tools/grit/grit/gather/chrome_scaled_image.py $(LOCAL_PATH)/tools/grit/grit/gather/igoogle_strings.py $(LOCAL_PATH)/tools/grit/grit/gather/interface.py $(LOCAL_PATH)/tools/grit/grit/gather/json_loader.py $(LOCAL_PATH)/tools/grit/grit/gather/muppet_strings.py $(LOCAL_PATH)/tools/grit/grit/gather/policy_json.py $(LOCAL_PATH)/tools/grit/grit/gather/rc.py $(LOCAL_PATH)/tools/grit/grit/gather/regexp.py $(LOCAL_PATH)/tools/grit/grit/gather/skeleton_gatherer.py $(LOCAL_PATH)/tools/grit/grit/gather/tr_html.py $(LOCAL_PATH)/tools/grit/grit/gather/txt.py $(LOCAL_PATH)/tools/grit/grit/grd_reader.py $(LOCAL_PATH)/tools/grit/grit/grit_runner.py $(LOCAL_PATH)/tools/grit/grit/lazy_re.py $(LOCAL_PATH)/tools/grit/grit/node/__init__.py $(LOCAL_PATH)/tools/grit/grit/node/base.py $(LOCAL_PATH)/tools/grit/grit/node/custom/__init__.py $(LOCAL_PATH)/tools/grit/grit/node/custom/filename.py $(LOCAL_PATH)/tools/grit/grit/node/empty.py $(LOCAL_PATH)/tools/grit/grit/node/include.py $(LOCAL_PATH)/tools/grit/grit/node/io.py $(LOCAL_PATH)/tools/grit/grit/node/mapping.py $(LOCAL_PATH)/tools/grit/grit/node/message.py $(LOCAL_PATH)/tools/grit/grit/node/misc.py $(LOCAL_PATH)/tools/grit/grit/node/structure.py $(LOCAL_PATH)/tools/grit/grit/node/variant.py $(LOCAL_PATH)/tools/grit/grit/pseudo.py $(LOCAL_PATH)/tools/grit/grit/pseudo_rtl.py $(LOCAL_PATH)/tools/grit/grit/scons.py $(LOCAL_PATH)/tools/grit/grit/shortcuts.py $(LOCAL_PATH)/tools/grit/grit/shortcuts_unittests.py $(LOCAL_PATH)/tools/grit/grit/tclib.py $(LOCAL_PATH)/tools/grit/grit/test_suite_all.py $(LOCAL_PATH)/tools/grit/grit/tool/__init__.py $(LOCAL_PATH)/tools/grit/grit/tool/android2grd.py $(LOCAL_PATH)/tools/grit/grit/tool/build.py $(LOCAL_PATH)/tools/grit/grit/tool/buildinfo.py $(LOCAL_PATH)/tools/grit/grit/tool/count.py $(LOCAL_PATH)/tools/grit/grit/tool/diff_structures.py $(LOCAL_PATH)/tools/grit/grit/tool/interface.py $(LOCAL_PATH)/tools/grit/grit/tool/menu_from_parts.py $(LOCAL_PATH)/tools/grit/grit/tool/newgrd.py $(LOCAL_PATH)/tools/grit/grit/tool/postprocess_interface.py $(LOCAL_PATH)/tools/grit/grit/tool/preprocess_interface.py $(LOCAL_PATH)/tools/grit/grit/tool/rc2grd.py $(LOCAL_PATH)/tools/grit/grit/tool/resize.py $(LOCAL_PATH)/tools/grit/grit/tool/test.py $(LOCAL_PATH)/tools/grit/grit/tool/toolbar_postprocess.py $(LOCAL_PATH)/tools/grit/grit/tool/toolbar_preprocess.py $(LOCAL_PATH)/tools/grit/grit/tool/transl2tc.py $(LOCAL_PATH)/tools/grit/grit/tool/unit.py $(LOCAL_PATH)/tools/grit/grit/tool/xmb.py $(LOCAL_PATH)/tools/grit/grit/util.py $(LOCAL_PATH)/tools/grit/grit/xtb_reader.py $(LOCAL_PATH)/tools/grit/grit_info.py $(GYP_TARGET_DEPENDENCIES)
	@echo "Gyp action: Generating resources from ui_resources.grd ($@)"
	$(hide)cd $(gyp_local_path)/ui/resources; mkdir -p $(gyp_shared_intermediate_dir)/ui/ui_resources/grit $(gyp_shared_intermediate_dir)/ui/ui_resources; python ../../tools/grit/grit.py -i ui_resources.grd build -f ../../tools/gritsettings/resource_ids -o "$(gyp_shared_intermediate_dir)/ui/ui_resources" -D _chromium -E "CHROMIUM_BUILD=chromium" -t android -E "ANDROID_JAVA_TAGGED_ONLY=true" -D enable_printing -D use_concatenated_impulse_responses

$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources_map.cc: $(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h ;
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources_map.h: $(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h ;
$(gyp_shared_intermediate_dir)/ui/ui_resources/ui_resources_100_percent.pak: $(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h ;
$(gyp_shared_intermediate_dir)/ui/ui_resources/ui_resources_200_percent.pak: $(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h ;

### Rules for action "webui_resources":
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h: gyp_local_path := $(LOCAL_PATH)
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h: gyp_intermediate_dir := $(abspath $(gyp_intermediate_dir))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h: gyp_shared_intermediate_dir := $(abspath $(gyp_shared_intermediate_dir))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h: export PATH := $(subst $(ANDROID_BUILD_PATHS),,$(PATH))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h: $(LOCAL_PATH)/third_party/jstemplate/jstemplate_compiled.js $(LOCAL_PATH)/ui/webui/resources/webui_resources.grd $(LOCAL_PATH)/tools/gritsettings/resource_ids $(LOCAL_PATH)/ui/resources/default_100_percent/common/blue_button.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/blue_button_focused.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/blue_button_focused_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/blue_button_focused_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/blue_button_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/blue_button_inactive.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/blue_button_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/button.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/button_focused.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/button_focused_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/button_focused_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/button_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/button_inactive.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/button_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_checked.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_checked_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_checked_inactive.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_checked_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_focused.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_focused_checked.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_focused_checked_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_focused_checked_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_focused_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_focused_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_hover.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_inactive.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/checkbox_pressed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/folder_closed.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/folder_closed_rtl.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/folder_open.png $(LOCAL_PATH)/ui/resources/default_100_percent/common/folder_open_rtl.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/blue_button.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/blue_button_focused.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/blue_button_focused_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/blue_button_focused_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/blue_button_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/blue_button_inactive.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/blue_button_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/button.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/button_focused.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/button_focused_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/button_focused_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/button_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/button_inactive.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/button_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_checked.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_checked_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_checked_inactive.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_checked_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_focused.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_focused_checked.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_focused_checked_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_focused_checked_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_focused_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_focused_pressed.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_hover.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_inactive.png $(LOCAL_PATH)/ui/resources/default_200_percent/common/checkbox_pressed.png $(LOCAL_PATH)/ui/webui/resources/css/alert_overlay.css $(LOCAL_PATH)/ui/webui/resources/css/apps/common.css $(LOCAL_PATH)/ui/webui/resources/css/apps/topbutton_bar.css $(LOCAL_PATH)/ui/webui/resources/css/bubble.css $(LOCAL_PATH)/ui/webui/resources/css/bubble_button.css $(LOCAL_PATH)/ui/webui/resources/css/butter_bar.css $(LOCAL_PATH)/ui/webui/resources/css/chrome_shared.css $(LOCAL_PATH)/ui/webui/resources/css/dialogs.css $(LOCAL_PATH)/ui/webui/resources/css/list.css $(LOCAL_PATH)/ui/webui/resources/css/menu.css $(LOCAL_PATH)/ui/webui/resources/css/menu_button.css $(LOCAL_PATH)/ui/webui/resources/css/overlay.css $(LOCAL_PATH)/ui/webui/resources/css/spinner.css $(LOCAL_PATH)/ui/webui/resources/css/table.css $(LOCAL_PATH)/ui/webui/resources/css/tabs.css $(LOCAL_PATH)/ui/webui/resources/css/throbber.css $(LOCAL_PATH)/ui/webui/resources/css/trash.css $(LOCAL_PATH)/ui/webui/resources/css/tree.css $(LOCAL_PATH)/ui/webui/resources/css/tree.css.js $(LOCAL_PATH)/ui/webui/resources/css/widgets.css $(LOCAL_PATH)/ui/webui/resources/images/2x/apps/button_butter_bar_close.png $(LOCAL_PATH)/ui/webui/resources/images/2x/apps/button_butter_bar_close_hover.png $(LOCAL_PATH)/ui/webui/resources/images/2x/apps/button_butter_bar_close_pressed.png $(LOCAL_PATH)/ui/webui/resources/images/2x/apps/topbar_button_close.png $(LOCAL_PATH)/ui/webui/resources/images/2x/apps/topbar_button_maximize.png $(LOCAL_PATH)/ui/webui/resources/images/2x/apps/topbar_button_minimize.png $(LOCAL_PATH)/ui/webui/resources/images/2x/apps/topbar_button_settings.png $(LOCAL_PATH)/ui/webui/resources/images/apps/button_butter_bar_close.png $(LOCAL_PATH)/ui/webui/resources/images/apps/button_butter_bar_close_hover.png $(LOCAL_PATH)/ui/webui/resources/images/apps/button_butter_bar_close_pressed.png $(LOCAL_PATH)/ui/webui/resources/images/apps/topbar_button_close.png $(LOCAL_PATH)/ui/webui/resources/images/apps/topbar_button_maximize.png $(LOCAL_PATH)/ui/webui/resources/images/apps/topbar_button_minimize.png $(LOCAL_PATH)/ui/webui/resources/images/apps/topbar_button_settings.png $(LOCAL_PATH)/ui/webui/resources/images/check.png $(LOCAL_PATH)/ui/webui/resources/images/checkbox_black.png $(LOCAL_PATH)/ui/webui/resources/images/checkbox_white.png $(LOCAL_PATH)/ui/webui/resources/images/clouds.png $(LOCAL_PATH)/ui/webui/resources/images/disabled_select.png $(LOCAL_PATH)/ui/webui/resources/images/gear.png $(LOCAL_PATH)/ui/webui/resources/images/google-transparent.png $(LOCAL_PATH)/ui/webui/resources/images/help.png $(LOCAL_PATH)/ui/webui/resources/images/question_mark.png $(LOCAL_PATH)/ui/webui/resources/images/select.png $(LOCAL_PATH)/ui/webui/resources/images/spinner.svg $(LOCAL_PATH)/ui/webui/resources/images/throbber.svg $(LOCAL_PATH)/ui/webui/resources/images/trash.png $(LOCAL_PATH)/ui/webui/resources/js/assert.js $(LOCAL_PATH)/ui/webui/resources/js/cr.js $(LOCAL_PATH)/ui/webui/resources/js/cr/event_target.js $(LOCAL_PATH)/ui/webui/resources/js/cr/link_controller.js $(LOCAL_PATH)/ui/webui/resources/js/cr/promise.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/alert_overlay.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/array_data_model.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/autocomplete_list.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/bubble.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/bubble_button.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/card_slider.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/command.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/context_menu_button.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/context_menu_handler.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/dialogs.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/drag_wrapper.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/focus_manager.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/focus_outline_manager.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/grid.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/list.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/list_item.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/list_selection_controller.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/list_selection_model.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/list_single_selection_model.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/menu.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/menu_button.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/menu_item.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/overlay.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/position_util.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/repeating_button.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/splitter.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/table.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/table/table_column.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/table/table_column_model.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/table/table_header.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/table/table_list.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/table/table_splitter.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/tabs.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/touch_handler.js $(LOCAL_PATH)/ui/webui/resources/js/cr/ui/tree.js $(LOCAL_PATH)/ui/webui/resources/js/event_tracker.js $(LOCAL_PATH)/ui/webui/resources/js/i18n_process.js $(LOCAL_PATH)/ui/webui/resources/js/i18n_template.js $(LOCAL_PATH)/ui/webui/resources/js/i18n_template2.js $(LOCAL_PATH)/ui/webui/resources/js/i18n_template_no_process.js $(LOCAL_PATH)/ui/webui/resources/js/jstemplate_compiled.js $(LOCAL_PATH)/ui/webui/resources/js/load_time_data.js $(LOCAL_PATH)/ui/webui/resources/js/local_strings.js $(LOCAL_PATH)/ui/webui/resources/js/media_common.js $(LOCAL_PATH)/ui/webui/resources/js/parse_html_subset.js $(LOCAL_PATH)/ui/webui/resources/js/util.js $(LOCAL_PATH)/ui/webui/resources/js/webui_resource_test.js $(LOCAL_PATH)/tools/grit/PRESUBMIT.py $(LOCAL_PATH)/tools/grit/grit.py $(LOCAL_PATH)/tools/grit/grit/__init__.py $(LOCAL_PATH)/tools/grit/grit/clique.py $(LOCAL_PATH)/tools/grit/grit/constants.py $(LOCAL_PATH)/tools/grit/grit/exception.py $(LOCAL_PATH)/tools/grit/grit/extern/BogoFP.py $(LOCAL_PATH)/tools/grit/grit/extern/FP.py $(LOCAL_PATH)/tools/grit/grit/extern/__init__.py $(LOCAL_PATH)/tools/grit/grit/extern/tclib.py $(LOCAL_PATH)/tools/grit/grit/format/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/android_xml.py $(LOCAL_PATH)/tools/grit/grit/format/c_format.py $(LOCAL_PATH)/tools/grit/grit/format/chrome_messages_json.py $(LOCAL_PATH)/tools/grit/grit/format/data_pack.py $(LOCAL_PATH)/tools/grit/grit/format/html_inline.py $(LOCAL_PATH)/tools/grit/grit/format/js_map_format.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/PRESUBMIT.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/policy_template_generator.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/template_formatter.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writer_configuration.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/adm_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/adml_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/admx_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/doc_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/json_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/mock_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_helper.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_strings_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/reg_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/template_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/writer_unittest_common.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/xml_formatted_writer.py $(LOCAL_PATH)/tools/grit/grit/format/rc.py $(LOCAL_PATH)/tools/grit/grit/format/rc_header.py $(LOCAL_PATH)/tools/grit/grit/format/repack.py $(LOCAL_PATH)/tools/grit/grit/format/resource_map.py $(LOCAL_PATH)/tools/grit/grit/gather/__init__.py $(LOCAL_PATH)/tools/grit/grit/gather/admin_template.py $(LOCAL_PATH)/tools/grit/grit/gather/chrome_html.py $(LOCAL_PATH)/tools/grit/grit/gather/chrome_scaled_image.py $(LOCAL_PATH)/tools/grit/grit/gather/igoogle_strings.py $(LOCAL_PATH)/tools/grit/grit/gather/interface.py $(LOCAL_PATH)/tools/grit/grit/gather/json_loader.py $(LOCAL_PATH)/tools/grit/grit/gather/muppet_strings.py $(LOCAL_PATH)/tools/grit/grit/gather/policy_json.py $(LOCAL_PATH)/tools/grit/grit/gather/rc.py $(LOCAL_PATH)/tools/grit/grit/gather/regexp.py $(LOCAL_PATH)/tools/grit/grit/gather/skeleton_gatherer.py $(LOCAL_PATH)/tools/grit/grit/gather/tr_html.py $(LOCAL_PATH)/tools/grit/grit/gather/txt.py $(LOCAL_PATH)/tools/grit/grit/grd_reader.py $(LOCAL_PATH)/tools/grit/grit/grit_runner.py $(LOCAL_PATH)/tools/grit/grit/lazy_re.py $(LOCAL_PATH)/tools/grit/grit/node/__init__.py $(LOCAL_PATH)/tools/grit/grit/node/base.py $(LOCAL_PATH)/tools/grit/grit/node/custom/__init__.py $(LOCAL_PATH)/tools/grit/grit/node/custom/filename.py $(LOCAL_PATH)/tools/grit/grit/node/empty.py $(LOCAL_PATH)/tools/grit/grit/node/include.py $(LOCAL_PATH)/tools/grit/grit/node/io.py $(LOCAL_PATH)/tools/grit/grit/node/mapping.py $(LOCAL_PATH)/tools/grit/grit/node/message.py $(LOCAL_PATH)/tools/grit/grit/node/misc.py $(LOCAL_PATH)/tools/grit/grit/node/structure.py $(LOCAL_PATH)/tools/grit/grit/node/variant.py $(LOCAL_PATH)/tools/grit/grit/pseudo.py $(LOCAL_PATH)/tools/grit/grit/pseudo_rtl.py $(LOCAL_PATH)/tools/grit/grit/scons.py $(LOCAL_PATH)/tools/grit/grit/shortcuts.py $(LOCAL_PATH)/tools/grit/grit/shortcuts_unittests.py $(LOCAL_PATH)/tools/grit/grit/tclib.py $(LOCAL_PATH)/tools/grit/grit/test_suite_all.py $(LOCAL_PATH)/tools/grit/grit/tool/__init__.py $(LOCAL_PATH)/tools/grit/grit/tool/android2grd.py $(LOCAL_PATH)/tools/grit/grit/tool/build.py $(LOCAL_PATH)/tools/grit/grit/tool/buildinfo.py $(LOCAL_PATH)/tools/grit/grit/tool/count.py $(LOCAL_PATH)/tools/grit/grit/tool/diff_structures.py $(LOCAL_PATH)/tools/grit/grit/tool/interface.py $(LOCAL_PATH)/tools/grit/grit/tool/menu_from_parts.py $(LOCAL_PATH)/tools/grit/grit/tool/newgrd.py $(LOCAL_PATH)/tools/grit/grit/tool/postprocess_interface.py $(LOCAL_PATH)/tools/grit/grit/tool/preprocess_interface.py $(LOCAL_PATH)/tools/grit/grit/tool/rc2grd.py $(LOCAL_PATH)/tools/grit/grit/tool/resize.py $(LOCAL_PATH)/tools/grit/grit/tool/test.py $(LOCAL_PATH)/tools/grit/grit/tool/toolbar_postprocess.py $(LOCAL_PATH)/tools/grit/grit/tool/toolbar_preprocess.py $(LOCAL_PATH)/tools/grit/grit/tool/transl2tc.py $(LOCAL_PATH)/tools/grit/grit/tool/unit.py $(LOCAL_PATH)/tools/grit/grit/tool/xmb.py $(LOCAL_PATH)/tools/grit/grit/util.py $(LOCAL_PATH)/tools/grit/grit/xtb_reader.py $(LOCAL_PATH)/tools/grit/grit_info.py $(GYP_TARGET_DEPENDENCIES)
	@echo "Gyp action: Generating resources from ../webui/resources/webui_resources.grd ($@)"
	$(hide)cd $(gyp_local_path)/ui/resources; mkdir -p $(gyp_shared_intermediate_dir)/ui/ui_resources/grit $(gyp_shared_intermediate_dir)/ui/ui_resources; python ../../tools/grit/grit.py -i ../webui/resources/webui_resources.grd build -f ../../tools/gritsettings/resource_ids -o "$(gyp_shared_intermediate_dir)/ui/ui_resources" -D _chromium -E "CHROMIUM_BUILD=chromium" -t android -E "ANDROID_JAVA_TAGGED_ONLY=true" -D enable_printing -D use_concatenated_impulse_responses

$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources_map.cc: $(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h ;
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources_map.h: $(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h ;
$(gyp_shared_intermediate_dir)/ui/ui_resources/webui_resources.pak: $(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h ;

### Rules for action "ui_unscaled_resources":
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_unscaled_resources.h: gyp_local_path := $(LOCAL_PATH)
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_unscaled_resources.h: gyp_intermediate_dir := $(abspath $(gyp_intermediate_dir))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_unscaled_resources.h: gyp_shared_intermediate_dir := $(abspath $(gyp_shared_intermediate_dir))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_unscaled_resources.h: export PATH := $(subst $(ANDROID_BUILD_PATHS),,$(PATH))
$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_unscaled_resources.h: $(LOCAL_PATH)/tools/gritsettings/resource_ids $(LOCAL_PATH)/ui/resources/ui_unscaled_resources.grd $(LOCAL_PATH)/tools/grit/PRESUBMIT.py $(LOCAL_PATH)/tools/grit/grit.py $(LOCAL_PATH)/tools/grit/grit/__init__.py $(LOCAL_PATH)/tools/grit/grit/clique.py $(LOCAL_PATH)/tools/grit/grit/constants.py $(LOCAL_PATH)/tools/grit/grit/exception.py $(LOCAL_PATH)/tools/grit/grit/extern/BogoFP.py $(LOCAL_PATH)/tools/grit/grit/extern/FP.py $(LOCAL_PATH)/tools/grit/grit/extern/__init__.py $(LOCAL_PATH)/tools/grit/grit/extern/tclib.py $(LOCAL_PATH)/tools/grit/grit/format/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/android_xml.py $(LOCAL_PATH)/tools/grit/grit/format/c_format.py $(LOCAL_PATH)/tools/grit/grit/format/chrome_messages_json.py $(LOCAL_PATH)/tools/grit/grit/format/data_pack.py $(LOCAL_PATH)/tools/grit/grit/format/html_inline.py $(LOCAL_PATH)/tools/grit/grit/format/js_map_format.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/PRESUBMIT.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/policy_template_generator.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/template_formatter.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writer_configuration.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/__init__.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/adm_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/adml_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/admx_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/doc_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/json_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/mock_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_helper.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_strings_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/plist_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/reg_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/template_writer.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/writer_unittest_common.py $(LOCAL_PATH)/tools/grit/grit/format/policy_templates/writers/xml_formatted_writer.py $(LOCAL_PATH)/tools/grit/grit/format/rc.py $(LOCAL_PATH)/tools/grit/grit/format/rc_header.py $(LOCAL_PATH)/tools/grit/grit/format/repack.py $(LOCAL_PATH)/tools/grit/grit/format/resource_map.py $(LOCAL_PATH)/tools/grit/grit/gather/__init__.py $(LOCAL_PATH)/tools/grit/grit/gather/admin_template.py $(LOCAL_PATH)/tools/grit/grit/gather/chrome_html.py $(LOCAL_PATH)/tools/grit/grit/gather/chrome_scaled_image.py $(LOCAL_PATH)/tools/grit/grit/gather/igoogle_strings.py $(LOCAL_PATH)/tools/grit/grit/gather/interface.py $(LOCAL_PATH)/tools/grit/grit/gather/json_loader.py $(LOCAL_PATH)/tools/grit/grit/gather/muppet_strings.py $(LOCAL_PATH)/tools/grit/grit/gather/policy_json.py $(LOCAL_PATH)/tools/grit/grit/gather/rc.py $(LOCAL_PATH)/tools/grit/grit/gather/regexp.py $(LOCAL_PATH)/tools/grit/grit/gather/skeleton_gatherer.py $(LOCAL_PATH)/tools/grit/grit/gather/tr_html.py $(LOCAL_PATH)/tools/grit/grit/gather/txt.py $(LOCAL_PATH)/tools/grit/grit/grd_reader.py $(LOCAL_PATH)/tools/grit/grit/grit_runner.py $(LOCAL_PATH)/tools/grit/grit/lazy_re.py $(LOCAL_PATH)/tools/grit/grit/node/__init__.py $(LOCAL_PATH)/tools/grit/grit/node/base.py $(LOCAL_PATH)/tools/grit/grit/node/custom/__init__.py $(LOCAL_PATH)/tools/grit/grit/node/custom/filename.py $(LOCAL_PATH)/tools/grit/grit/node/empty.py $(LOCAL_PATH)/tools/grit/grit/node/include.py $(LOCAL_PATH)/tools/grit/grit/node/io.py $(LOCAL_PATH)/tools/grit/grit/node/mapping.py $(LOCAL_PATH)/tools/grit/grit/node/message.py $(LOCAL_PATH)/tools/grit/grit/node/misc.py $(LOCAL_PATH)/tools/grit/grit/node/structure.py $(LOCAL_PATH)/tools/grit/grit/node/variant.py $(LOCAL_PATH)/tools/grit/grit/pseudo.py $(LOCAL_PATH)/tools/grit/grit/pseudo_rtl.py $(LOCAL_PATH)/tools/grit/grit/scons.py $(LOCAL_PATH)/tools/grit/grit/shortcuts.py $(LOCAL_PATH)/tools/grit/grit/shortcuts_unittests.py $(LOCAL_PATH)/tools/grit/grit/tclib.py $(LOCAL_PATH)/tools/grit/grit/test_suite_all.py $(LOCAL_PATH)/tools/grit/grit/tool/__init__.py $(LOCAL_PATH)/tools/grit/grit/tool/android2grd.py $(LOCAL_PATH)/tools/grit/grit/tool/build.py $(LOCAL_PATH)/tools/grit/grit/tool/buildinfo.py $(LOCAL_PATH)/tools/grit/grit/tool/count.py $(LOCAL_PATH)/tools/grit/grit/tool/diff_structures.py $(LOCAL_PATH)/tools/grit/grit/tool/interface.py $(LOCAL_PATH)/tools/grit/grit/tool/menu_from_parts.py $(LOCAL_PATH)/tools/grit/grit/tool/newgrd.py $(LOCAL_PATH)/tools/grit/grit/tool/postprocess_interface.py $(LOCAL_PATH)/tools/grit/grit/tool/preprocess_interface.py $(LOCAL_PATH)/tools/grit/grit/tool/rc2grd.py $(LOCAL_PATH)/tools/grit/grit/tool/resize.py $(LOCAL_PATH)/tools/grit/grit/tool/test.py $(LOCAL_PATH)/tools/grit/grit/tool/toolbar_postprocess.py $(LOCAL_PATH)/tools/grit/grit/tool/toolbar_preprocess.py $(LOCAL_PATH)/tools/grit/grit/tool/transl2tc.py $(LOCAL_PATH)/tools/grit/grit/tool/unit.py $(LOCAL_PATH)/tools/grit/grit/tool/xmb.py $(LOCAL_PATH)/tools/grit/grit/util.py $(LOCAL_PATH)/tools/grit/grit/xtb_reader.py $(LOCAL_PATH)/tools/grit/grit_info.py $(GYP_TARGET_DEPENDENCIES)
	@echo "Gyp action: Generating resources from ui_unscaled_resources.grd ($@)"
	$(hide)cd $(gyp_local_path)/ui/resources; mkdir -p $(gyp_shared_intermediate_dir)/ui/ui_resources/grit $(gyp_shared_intermediate_dir)/ui/ui_resources; python ../../tools/grit/grit.py -i ui_unscaled_resources.grd build -f ../../tools/gritsettings/resource_ids -o "$(gyp_shared_intermediate_dir)/ui/ui_resources" -D _chromium -E "CHROMIUM_BUILD=chromium" -t android -E "ANDROID_JAVA_TAGGED_ONLY=true" -D enable_printing -D use_concatenated_impulse_responses

$(gyp_shared_intermediate_dir)/ui/ui_resources/ui_unscaled_resources.rc: $(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_unscaled_resources.h ;


GYP_GENERATED_OUTPUTS := \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources.h \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources_map.cc \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_resources_map.h \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/ui_resources_100_percent.pak \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/ui_resources_200_percent.pak \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources.h \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources_map.cc \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/webui_resources_map.h \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/webui_resources.pak \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/grit/ui_unscaled_resources.h \
	$(gyp_shared_intermediate_dir)/ui/ui_resources/ui_unscaled_resources.rc

# Make sure our deps and generated files are built first.
LOCAL_ADDITIONAL_DEPENDENCIES := $(GYP_TARGET_DEPENDENCIES) $(GYP_GENERATED_OUTPUTS)

### Rules for final target.
# Add target alias to "gyp_all_modules" target.
.PHONY: gyp_all_modules
gyp_all_modules: ui_resources_ui_resources_gyp

# Alias gyp target name.
.PHONY: ui_resources
ui_resources: ui_resources_ui_resources_gyp

LOCAL_MODULE_PATH := $(PRODUCT_OUT)/gyp_stamp
LOCAL_UNINSTALLABLE_MODULE := true

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): $(LOCAL_ADDITIONAL_DEPENDENCIES)
	$(hide) echo "Gyp timestamp: $@"
	$(hide) mkdir -p $(dir $@)
	$(hide) touch $@
