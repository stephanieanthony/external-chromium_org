// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "chrome/browser/ui/views/frame/browser_non_client_frame_view_ash.h"

#include "ash/ash_switches.h"
#include "ash/wm/caption_buttons/frame_caption_button_container_view.h"
#include "ash/wm/frame_border_hit_test_controller.h"
#include "ash/wm/header_painter.h"
#include "base/command_line.h"
#include "chrome/browser/themes/theme_properties.h"
#include "chrome/browser/ui/browser.h"
#include "chrome/browser/ui/views/avatar_label.h"
#include "chrome/browser/ui/views/avatar_menu_button.h"
#include "chrome/browser/ui/views/frame/browser_frame.h"
#include "chrome/browser/ui/views/frame/browser_view.h"
#include "chrome/browser/ui/views/frame/immersive_mode_controller.h"
#include "chrome/browser/ui/views/tab_icon_view.h"
#include "chrome/browser/ui/views/tabs/tab_strip.h"
#include "chrome/common/chrome_switches.h"
#include "content/public/browser/web_contents.h"
#include "grit/ash_resources.h"
#include "grit/theme_resources.h"
#include "ui/aura/client/aura_constants.h"
#include "ui/aura/window.h"
#include "ui/base/accessibility/accessible_view_state.h"
#include "ui/base/hit_test.h"
#include "ui/base/l10n/l10n_util.h"
#include "ui/base/layout.h"
#include "ui/base/resource/resource_bundle.h"
#include "ui/base/theme_provider.h"
#include "ui/compositor/layer_animator.h"
#include "ui/gfx/canvas.h"
#include "ui/gfx/image/image_skia.h"
#include "ui/gfx/rect_conversions.h"
#include "ui/views/controls/label.h"
#include "ui/views/layout/layout_constants.h"
#include "ui/views/widget/widget.h"
#include "ui/views/widget/widget_delegate.h"

namespace {

// The avatar ends 2 px above the bottom of the tabstrip (which, given the
// way the tabstrip draws its bottom edge, will appear like a 1 px gap to the
// user).
const int kAvatarBottomSpacing = 2;
// There are 2 px on each side of the avatar (between the frame border and
// it on the left, and between it and the tabstrip on the right).
const int kAvatarSideSpacing = 2;
// Space between left edge of window and tabstrip.
const int kTabstripLeftSpacing = 0;
// Space between right edge of tabstrip and maximize button.
const int kTabstripRightSpacing = 10;
// Height of the shadow of the content area, at the top of the toolbar.
const int kContentShadowHeight = 1;
// Space between top of window and top of tabstrip for tall headers, such as
// for restored windows, apps, etc.
const int kTabstripTopSpacingTall = 7;
// Space between top of window and top of tabstrip for short headers, such as
// for maximized windows, pop-ups, etc.
const int kTabstripTopSpacingShort = 0;
// Height of the shadow in the tab image, used to ensure clicks in the shadow
// area still drag restored windows.  This keeps the clickable area large enough
// to hit easily.
const int kTabShadowHeight = 4;

}  // namespace

///////////////////////////////////////////////////////////////////////////////
// BrowserNonClientFrameViewAsh, public:

// static
const char BrowserNonClientFrameViewAsh::kViewClassName[] =
    "BrowserNonClientFrameViewAsh";

BrowserNonClientFrameViewAsh::BrowserNonClientFrameViewAsh(
    BrowserFrame* frame, BrowserView* browser_view)
    : BrowserNonClientFrameView(frame, browser_view),
      caption_button_container_(NULL),
      window_icon_(NULL),
      header_painter_(new ash::HeaderPainter),
      frame_border_hit_test_controller_(
          new ash::FrameBorderHitTestController(frame)) {
}

BrowserNonClientFrameViewAsh::~BrowserNonClientFrameViewAsh() {
}

void BrowserNonClientFrameViewAsh::Init() {
  caption_button_container_ = new ash::FrameCaptionButtonContainerView(frame(),
      ash::FrameCaptionButtonContainerView::MINIMIZE_ALLOWED);
  AddChildView(caption_button_container_);

  // Initializing the TabIconView is expensive, so only do it if we need to.
  if (browser_view()->ShouldShowWindowIcon()) {
    window_icon_ = new TabIconView(this, NULL);
    window_icon_->set_is_light(true);
    AddChildView(window_icon_);
    window_icon_->Update();
  }

  // Create incognito icon if necessary.
  UpdateAvatarInfo();

  // HeaderPainter handles layout.
  header_painter_->Init(frame(), this, window_icon_, caption_button_container_);
}

///////////////////////////////////////////////////////////////////////////////
// BrowserNonClientFrameView overrides:

gfx::Rect BrowserNonClientFrameViewAsh::GetBoundsForTabStrip(
    views::View* tabstrip) const {
  if (!tabstrip)
    return gfx::Rect();

  // When the tab strip is painted in the immersive fullscreen light bar style,
  // the caption buttons and the avatar button are not visible. However, their
  // bounds are still used to compute the tab strip bounds so that the tabs have
  // the same horizontal position when the tab strip is painted in the immersive
  // light bar style as when the top-of-window views are revealed.
  int left_inset = GetTabStripLeftInset();
  int right_inset = GetTabStripRightInset();
  return gfx::Rect(left_inset,
                   GetTopInset(),
                   std::max(0, width() - left_inset - right_inset),
                   tabstrip->GetPreferredSize().height());
}

int BrowserNonClientFrameViewAsh::GetTopInset() const {
  if (!ShouldPaint() || UseImmersiveLightbarHeaderStyle())
    return 0;

  if (browser_view()->IsTabStripVisible()) {
    if (frame()->IsMaximized() || frame()->IsFullscreen())
      return kTabstripTopSpacingShort;
    else
      return kTabstripTopSpacingTall;
  }

  int caption_buttons_bottom = caption_button_container_->bounds().bottom();

  // The toolbar partially overlaps the caption buttons.
  if (browser_view()->IsToolbarVisible())
    return caption_buttons_bottom - kContentShadowHeight;

  int separator_thickness = UsePackagedAppHeaderStyle() ?
      header_painter_->HeaderContentSeparatorSize() : kClientEdgeThickness;
  return caption_buttons_bottom + separator_thickness;
}

int BrowserNonClientFrameViewAsh::GetThemeBackgroundXInset() const {
  return header_painter_->GetThemeBackgroundXInset();
}

void BrowserNonClientFrameViewAsh::UpdateThrobber(bool running) {
  if (window_icon_)
    window_icon_->Update();
}

///////////////////////////////////////////////////////////////////////////////
// views::NonClientFrameView overrides:

gfx::Rect BrowserNonClientFrameViewAsh::GetBoundsForClientView() const {
  // The ClientView must be flush with the top edge of the widget so that the
  // web contents can take up the entire screen in immersive fullscreen (with
  // or without the top-of-window views revealed). When in immersive fullscreen
  // and the top-of-window views are revealed, the TopContainerView paints the
  // window header by redirecting paints from its background to
  // BrowserNonClientFrameViewAsh.
  return ash::HeaderPainter::GetBoundsForClientView(0, bounds());
}

gfx::Rect BrowserNonClientFrameViewAsh::GetWindowBoundsForClientBounds(
    const gfx::Rect& client_bounds) const {
  return ash::HeaderPainter::GetWindowBoundsForClientBounds(0, client_bounds);
}

int BrowserNonClientFrameViewAsh::NonClientHitTest(const gfx::Point& point) {
  int hit_test = ash::FrameBorderHitTestController::NonClientHitTest(this,
      header_painter_.get(), point);

  // See if the point is actually within the avatar menu button or within
  // the avatar label.
  if (hit_test == HTCAPTION && ((avatar_button() &&
       avatar_button()->GetMirroredBounds().Contains(point)) ||
      (avatar_label() && avatar_label()->GetMirroredBounds().Contains(point))))
      return HTCLIENT;

  // When the window is restored we want a large click target above the tabs
  // to drag the window, so redirect clicks in the tab's shadow to caption.
  if (hit_test == HTCLIENT &&
      !(frame()->IsMaximized() || frame()->IsFullscreen())) {
    // Convert point to client coordinates.
    gfx::Point client_point(point);
    View::ConvertPointToTarget(this, frame()->client_view(), &client_point);
    // Report hits in shadow at top of tabstrip as caption.
    gfx::Rect tabstrip_bounds(browser_view()->tabstrip()->bounds());
    if (client_point.y() < tabstrip_bounds.y() + kTabShadowHeight)
      hit_test = HTCAPTION;
  }
  return hit_test;
}

void BrowserNonClientFrameViewAsh::GetWindowMask(const gfx::Size& size,
                                                 gfx::Path* window_mask) {
  // Aura does not use window masks.
}

void BrowserNonClientFrameViewAsh::ResetWindowControls() {
  // Hide the caption buttons in immersive fullscreen when the tab light bar
  // is visible because it's confusing when the user hovers or clicks in the
  // top-right of the screen and hits one.
  bool button_visibility = !UseImmersiveLightbarHeaderStyle();
  caption_button_container_->SetVisible(button_visibility);

  caption_button_container_->ResetWindowControls();
}

void BrowserNonClientFrameViewAsh::UpdateWindowIcon() {
  if (window_icon_)
    window_icon_->SchedulePaint();
}

void BrowserNonClientFrameViewAsh::UpdateWindowTitle() {
  if (!frame()->IsFullscreen())
    header_painter_->SchedulePaintForTitle(BrowserFrame::GetTitleFontList());
}

///////////////////////////////////////////////////////////////////////////////
// views::View overrides:

void BrowserNonClientFrameViewAsh::OnPaint(gfx::Canvas* canvas) {
  if (!ShouldPaint())
    return;

  if (UseImmersiveLightbarHeaderStyle()) {
    PaintImmersiveLightbarStyleHeader(canvas);
    return;
  }

  // The primary header image changes based on window activation state and
  // theme, so we look it up for each paint.
  int theme_frame_image_id = GetThemeFrameImageId();
  int theme_frame_overlay_image_id = GetThemeFrameOverlayImageId();

  ui::ThemeProvider* theme_provider = GetThemeProvider();
  if (!theme_provider->HasCustomImage(theme_frame_image_id) &&
      (theme_frame_overlay_image_id == 0 ||
       !theme_provider->HasCustomImage(theme_frame_overlay_image_id))) {
    if (frame()->IsMaximized() || frame()->IsFullscreen())
      theme_frame_image_id = IDR_AURA_WINDOW_HEADER_BASE_MINIMAL;
  }
  header_painter_->PaintHeader(
      canvas,
      theme_frame_image_id,
      theme_frame_overlay_image_id);
  if (browser_view()->ShouldShowWindowTitle())
    header_painter_->PaintTitleBar(canvas, BrowserFrame::GetTitleFontList());
  if (browser_view()->IsToolbarVisible())
    PaintToolbarBackground(canvas);
  else
    PaintContentEdge(canvas);
}

void BrowserNonClientFrameViewAsh::Layout() {
  // The header must be laid out before computing |header_height| because the
  // computation of |header_height| for app and popup windows depends on the
  // position of the window controls.
  header_painter_->LayoutHeader(UsePackagedAppHeaderStyle() ||
                                frame()->IsMaximized() ||
                                frame()->IsFullscreen());

  int header_height = 0;
  if (browser_view()->IsTabStripVisible()) {
    header_height = GetTopInset() +
        browser_view()->tabstrip()->GetPreferredSize().height();
  } else if (browser_view()->IsToolbarVisible()) {
    // Set the header's height so that it overlaps with the toolbar because the
    // top few pixels of the toolbar are not opaque.
    header_height = GetTopInset() + kFrameShadowThickness * 2;
  } else {
    header_height = GetTopInset();
  }
  header_painter_->set_header_height(header_height);
  if (avatar_button())
    LayoutAvatar();
  BrowserNonClientFrameView::Layout();
}

const char* BrowserNonClientFrameViewAsh::GetClassName() const {
  return kViewClassName;
}

bool BrowserNonClientFrameViewAsh::HitTestRect(const gfx::Rect& rect) const {
  if (!views::View::HitTestRect(rect)) {
    // |rect| is outside BrowserNonClientFrameViewAsh's bounds.
    return false;
  }

  TabStrip* tabstrip = browser_view()->tabstrip();
  if (tabstrip && browser_view()->IsTabStripVisible()) {
    // Claim |rect| only if it is above the bottom of the tabstrip in a non-tab
    // portion.
    gfx::RectF rect_in_tabstrip_coords_f(rect);
    View::ConvertRectToTarget(this, tabstrip, &rect_in_tabstrip_coords_f);
    gfx::Rect rect_in_tabstrip_coords = gfx::ToEnclosingRect(
        rect_in_tabstrip_coords_f);

     if (rect_in_tabstrip_coords.y() > tabstrip->height())
       return false;

    return !tabstrip->HitTestRect(rect_in_tabstrip_coords) ||
        tabstrip->IsRectInWindowCaption(rect_in_tabstrip_coords);
  }

  // Claim |rect| if it is above the top of the topmost view in the client area.
  return rect.y() < GetTopInset();
}

void BrowserNonClientFrameViewAsh::GetAccessibleState(
    ui::AccessibleViewState* state) {
  state->role = ui::AccessibilityTypes::ROLE_TITLEBAR;
}

gfx::Size BrowserNonClientFrameViewAsh::GetMinimumSize() {
  gfx::Size min_client_view_size(frame()->client_view()->GetMinimumSize());
  int min_width = std::max(header_painter_->GetMinimumHeaderWidth(),
                           min_client_view_size.width());
  if (browser_view()->IsTabStripVisible()) {
    // Ensure that the minimum width is enough to hold a minimum width tab strip
    // at its usual insets.
    int min_tabstrip_width =
        browser_view()->tabstrip()->GetMinimumSize().width();
    min_width = std::max(min_width,
        min_tabstrip_width + GetTabStripLeftInset() + GetTabStripRightInset());
  }
  return gfx::Size(min_width, min_client_view_size.height());
}

void BrowserNonClientFrameViewAsh::OnThemeChanged() {
  BrowserNonClientFrameView::OnThemeChanged();
  header_painter_->OnThemeChanged();
}

///////////////////////////////////////////////////////////////////////////////
// chrome::TabIconViewModel overrides:

bool BrowserNonClientFrameViewAsh::ShouldTabIconViewAnimate() const {
  // This function is queried during the creation of the window as the
  // TabIconView we host is initialized, so we need to NULL check the selected
  // WebContents because in this condition there is not yet a selected tab.
  content::WebContents* current_tab = browser_view()->GetActiveWebContents();
  return current_tab ? current_tab->IsLoading() : false;
}

gfx::ImageSkia BrowserNonClientFrameViewAsh::GetFaviconForTabIconView() {
  views::WidgetDelegate* delegate = frame()->widget_delegate();
  if (!delegate)
    return gfx::ImageSkia();
  return delegate->GetWindowIcon();
}

///////////////////////////////////////////////////////////////////////////////
// BrowserNonClientFrameViewAsh, private:

int BrowserNonClientFrameViewAsh::GetTabStripLeftInset() const {
  return avatar_button() ? kAvatarSideSpacing +
      browser_view()->GetOTRAvatarIcon().width() + kAvatarSideSpacing :
      kTabstripLeftSpacing;
}

int BrowserNonClientFrameViewAsh::GetTabStripRightInset() const {
  return header_painter_->GetRightInset() + kTabstripRightSpacing;
}

bool BrowserNonClientFrameViewAsh::UseImmersiveLightbarHeaderStyle() const {
  ImmersiveModeController* immersive_controller =
      browser_view()->immersive_mode_controller();
  return immersive_controller->IsEnabled() &&
      !immersive_controller->IsRevealed() &&
      browser_view()->IsTabStripVisible();
}

bool BrowserNonClientFrameViewAsh::UsePackagedAppHeaderStyle() const {
  // Non streamlined hosted apps do not have a toolbar or tabstrip. Their header
  // should look the same as the header for packaged apps. Streamlined hosted
  // apps have a toolbar so should use the browser header style.
  return browser_view()->browser()->is_app() &&
      !CommandLine::ForCurrentProcess()->HasSwitch(
          switches::kEnableStreamlinedHostedApps);
}

void BrowserNonClientFrameViewAsh::LayoutAvatar() {
  DCHECK(avatar_button());
  DCHECK(browser_view()->IsTabStripVisible());
  gfx::ImageSkia incognito_icon = browser_view()->GetOTRAvatarIcon();

  int avatar_bottom = GetTopInset() +
      browser_view()->GetTabStripHeight() - kAvatarBottomSpacing;
  int avatar_restored_y = avatar_bottom - incognito_icon.height();
  int avatar_y = (frame()->IsMaximized() || frame()->IsFullscreen()) ?
      GetTopInset() + kContentShadowHeight : avatar_restored_y;

  // Hide the incognito icon in immersive fullscreen when the tab light bar is
  // visible because the header is too short for the icognito icon to be
  // recognizable.
  bool avatar_visible = !UseImmersiveLightbarHeaderStyle();
  int avatar_height = avatar_visible ? avatar_bottom - avatar_y : 0;

  gfx::Rect avatar_bounds(kAvatarSideSpacing,
                          avatar_y,
                          incognito_icon.width(),
                          avatar_height);
  avatar_button()->SetBoundsRect(avatar_bounds);
  avatar_button()->SetVisible(avatar_visible);
}

bool BrowserNonClientFrameViewAsh::ShouldPaint() const {
  if (!frame()->IsFullscreen())
    return true;

  // We need to paint when in immersive fullscreen and either:
  // - The top-of-window views are revealed.
  // - The lightbar style tabstrip is visible.
  ImmersiveModeController* immersive_mode_controller =
      browser_view()->immersive_mode_controller();
  return immersive_mode_controller->IsEnabled() &&
      (immersive_mode_controller->IsRevealed() ||
       UseImmersiveLightbarHeaderStyle());
}

void BrowserNonClientFrameViewAsh::PaintImmersiveLightbarStyleHeader(
    gfx::Canvas* canvas) {
  // The light bar header is not themed because theming it does not look good.
  gfx::ImageSkia* frame_image = GetThemeProvider()->GetImageSkiaNamed(
      IDR_AURA_WINDOW_HEADER_BASE_MINIMAL);
  canvas->TileImageInt(*frame_image, 0, 0, width(), frame_image->height());
}

void BrowserNonClientFrameViewAsh::PaintToolbarBackground(gfx::Canvas* canvas) {
  gfx::Rect toolbar_bounds(browser_view()->GetToolbarBounds());
  if (toolbar_bounds.IsEmpty())
    return;
  gfx::Point toolbar_origin(toolbar_bounds.origin());
  View::ConvertPointToTarget(browser_view(), this, &toolbar_origin);
  toolbar_bounds.set_origin(toolbar_origin);

  int x = toolbar_bounds.x();
  int w = toolbar_bounds.width();
  int y = toolbar_bounds.y();
  int h = toolbar_bounds.height();

  // Gross hack: We split the toolbar images into two pieces, since sometimes
  // (popup mode) the toolbar isn't tall enough to show the whole image.  The
  // split happens between the top shadow section and the bottom gradient
  // section so that we never break the gradient.
  // NOTE(pkotwicz): If the computation for |bottom_y| is changed, Layout() must
  // be changed as well.
  int split_point = kFrameShadowThickness * 2;
  int bottom_y = y + split_point;
  ui::ThemeProvider* tp = GetThemeProvider();
  int bottom_edge_height = h - split_point;

  canvas->FillRect(gfx::Rect(x, bottom_y, w, bottom_edge_height),
                   tp->GetColor(ThemeProperties::COLOR_TOOLBAR));

  // Paint the main toolbar image.  Since this image is also used to draw the
  // tab background, we must use the tab strip offset to compute the image
  // source y position.  If you have to debug this code use an image editor
  // to paint a diagonal line through the toolbar image and ensure it lines up
  // across the tab and toolbar.
  gfx::ImageSkia* theme_toolbar = tp->GetImageSkiaNamed(IDR_THEME_TOOLBAR);
  canvas->TileImageInt(
      *theme_toolbar,
      x + GetThemeBackgroundXInset(),
      bottom_y - GetTopInset(),
      x, bottom_y,
      w, theme_toolbar->height());

  // The content area line has a shadow that extends a couple of pixels above
  // the toolbar bounds.
  const int kContentShadowHeight = 2;
  gfx::ImageSkia* toolbar_top = tp->GetImageSkiaNamed(IDR_TOOLBAR_SHADE_TOP);
  canvas->TileImageInt(*toolbar_top,
                       0, 0,
                       x, y - kContentShadowHeight,
                       w, split_point + kContentShadowHeight + 1);

  // Draw the "lightening" shade line around the edges of the toolbar.
  gfx::ImageSkia* toolbar_left = tp->GetImageSkiaNamed(IDR_TOOLBAR_SHADE_LEFT);
  canvas->TileImageInt(*toolbar_left,
                       0, 0,
                       x + kClientEdgeThickness,
                       y + kClientEdgeThickness + kContentShadowHeight,
                       toolbar_left->width(), theme_toolbar->height());
  gfx::ImageSkia* toolbar_right =
      tp->GetImageSkiaNamed(IDR_TOOLBAR_SHADE_RIGHT);
  canvas->TileImageInt(*toolbar_right,
                       0, 0,
                       w - toolbar_right->width() - 2 * kClientEdgeThickness,
                       y + kClientEdgeThickness + kContentShadowHeight,
                       toolbar_right->width(), theme_toolbar->height());

  // Draw the content/toolbar separator.
  canvas->FillRect(
      gfx::Rect(x + kClientEdgeThickness,
                toolbar_bounds.bottom() - kClientEdgeThickness,
                w - (2 * kClientEdgeThickness),
                kClientEdgeThickness),
      ThemeProperties::GetDefaultColor(
          ThemeProperties::COLOR_TOOLBAR_SEPARATOR));
}

void BrowserNonClientFrameViewAsh::PaintContentEdge(gfx::Canvas* canvas) {
  if (UsePackagedAppHeaderStyle()) {
    header_painter_->PaintHeaderContentSeparator(canvas);
  } else {
    canvas->FillRect(gfx::Rect(0, caption_button_container_->bounds().bottom(),
                               width(), kClientEdgeThickness),
        ThemeProperties::GetDefaultColor(
            ThemeProperties::COLOR_TOOLBAR_SEPARATOR));
  }
}

int BrowserNonClientFrameViewAsh::GetThemeFrameImageId() const {
  bool is_incognito = !browser_view()->IsRegularOrGuestSession();
  if (browser_view()->IsBrowserTypeNormal()) {
    // Use the standard resource ids to allow users to theme the frames.
    if (ShouldPaintAsActive()) {
      return is_incognito ?
          IDR_THEME_FRAME_INCOGNITO : IDR_THEME_FRAME;
    }
    return is_incognito ?
        IDR_THEME_FRAME_INCOGNITO_INACTIVE : IDR_THEME_FRAME_INACTIVE;
  }
  // Never theme app and popup windows.
  if (ShouldPaintAsActive()) {
    return is_incognito ?
        IDR_AURA_WINDOW_HEADER_BASE_INCOGNITO_ACTIVE :
        IDR_AURA_WINDOW_HEADER_BASE_ACTIVE;
  }
  return is_incognito ?
      IDR_AURA_WINDOW_HEADER_BASE_INCOGNITO_INACTIVE :
      IDR_AURA_WINDOW_HEADER_BASE_INACTIVE;
}

int BrowserNonClientFrameViewAsh::GetThemeFrameOverlayImageId() const {
  ui::ThemeProvider* tp = GetThemeProvider();
  if (tp->HasCustomImage(IDR_THEME_FRAME_OVERLAY) &&
      browser_view()->IsBrowserTypeNormal() &&
      !browser_view()->IsOffTheRecord()) {
    return ShouldPaintAsActive() ?
        IDR_THEME_FRAME_OVERLAY : IDR_THEME_FRAME_OVERLAY_INACTIVE;
  }
  return 0;
}
