// Copyright 2013 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "content/browser/renderer_host/input/touch_action_filter.h"
#include "content/common/input/synthetic_web_input_event_builders.h"
#include "content/port/browser/event_with_latency_info.h"
#include "content/port/common/input_event_ack_state.h"
#include "testing/gtest/include/gtest/gtest.h"
#include "third_party/WebKit/public/web/WebInputEvent.h"

using blink::WebGestureEvent;
using blink::WebInputEvent;

namespace content {

TEST(TouchActionFilterTest, SimpleFilter) {
  TouchActionFilter filter;

  WebGestureEvent scroll_begin =
      SyntheticWebGestureEventBuilder::BuildScrollBegin(2, 3);
  const float kDeltaX = 5;
  const float kDeltaY = 10;
  WebGestureEvent scroll_update =
      SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDeltaX, kDeltaY, 0);
  WebGestureEvent scroll_end = SyntheticWebGestureEventBuilder::Build(
      WebInputEvent::GestureScrollEnd, WebGestureEvent::Touchscreen);
  WebGestureEvent tap = SyntheticWebGestureEventBuilder::Build(
      WebInputEvent::GestureTap, WebGestureEvent::Touchscreen);

  // No events filtered by default.
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_EQ(kDeltaX, scroll_update.data.scrollUpdate.deltaX);
  EXPECT_EQ(kDeltaY, scroll_update.data.scrollUpdate.deltaY);
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));
  EXPECT_FALSE(filter.FilterGestureEvent(&tap));

  // TOUCH_ACTION_AUTO doesn't cause any filtering.
  filter.OnSetTouchAction(TOUCH_ACTION_AUTO);
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_EQ(kDeltaX, scroll_update.data.scrollUpdate.deltaX);
  EXPECT_EQ(kDeltaY, scroll_update.data.scrollUpdate.deltaY);
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));

  // TOUCH_ACTION_NONE filters out all scroll events, but no other events.
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  EXPECT_FALSE(filter.FilterGestureEvent(&tap));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_EQ(kDeltaX, scroll_update.data.scrollUpdate.deltaX);
  EXPECT_EQ(kDeltaY, scroll_update.data.scrollUpdate.deltaY);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_end));

  // After the end of a gesture the state is reset.
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));

  // Setting touch action doesn't impact any in-progress gestures.
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));

  // And the state is still cleared for the next gesture.
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));

  // Changing the touch action during a gesture has no effect.
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));
  filter.OnSetTouchAction(TOUCH_ACTION_AUTO);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_EQ(kDeltaX, scroll_update.data.scrollUpdate.deltaX);
  EXPECT_EQ(kDeltaY, scroll_update.data.scrollUpdate.deltaY);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_end));
}

TEST(TouchActionFilterTest, Fling) {
  TouchActionFilter filter;

  WebGestureEvent scroll_begin =
      SyntheticWebGestureEventBuilder::BuildScrollBegin(2, 3);
  WebGestureEvent scroll_update =
      SyntheticWebGestureEventBuilder::BuildScrollUpdate(5, 10, 0);
  const float kFlingX = 7;
  const float kFlingY = -4;
  WebGestureEvent fling_start = SyntheticWebGestureEventBuilder::BuildFling(
      kFlingX, kFlingY, WebGestureEvent::Touchscreen);
  WebGestureEvent pad_fling = SyntheticWebGestureEventBuilder::BuildFling(
      kFlingX, kFlingY, WebGestureEvent::Touchpad);

  // TOUCH_ACTION_NONE filters out fling events.
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&fling_start));
  EXPECT_EQ(kFlingX, fling_start.data.flingStart.velocityX);
  EXPECT_EQ(kFlingY, fling_start.data.flingStart.velocityY);

  // After a fling the state is reset.
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_FALSE(filter.FilterGestureEvent(&fling_start));

  // touchpad flings aren't filtered and don't reset state.
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_FALSE(filter.FilterGestureEvent(&pad_fling));
  EXPECT_TRUE(filter.FilterGestureEvent(&fling_start));
}

TEST(TouchActionFilterTest, PanX) {
  TouchActionFilter filter;
  const float kDX = 5;
  const float kDY = 10;
  const float kFlingX = 7;
  const float kFlingY = -4;
  WebGestureEvent scroll_end = SyntheticWebGestureEventBuilder::Build(
      WebInputEvent::GestureScrollEnd, WebGestureEvent::Touchscreen);

  {
    // Scrolls with no direction hint are permitted in the X axis.
    filter.OnSetTouchAction(TOUCH_ACTION_PAN_X);

    WebGestureEvent scroll_begin =
        SyntheticWebGestureEventBuilder::BuildScrollBegin(0, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));

    WebGestureEvent scroll_update =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDX, kDY, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
    EXPECT_EQ(kDX, scroll_update.data.scrollUpdate.deltaX);
    EXPECT_EQ(0, scroll_update.data.scrollUpdate.deltaY);

    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));
  }

  {
    // Scrolls hinted mostly in the X axis are permitted in that axis.
    filter.OnSetTouchAction(TOUCH_ACTION_PAN_X);
    WebGestureEvent scroll_begin =
        SyntheticWebGestureEventBuilder::BuildScrollBegin(-7, 6);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));

    WebGestureEvent scroll_update =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDX, kDY, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
    EXPECT_EQ(kDX, scroll_update.data.scrollUpdate.deltaX);
    EXPECT_EQ(0, scroll_update.data.scrollUpdate.deltaY);

    WebGestureEvent scroll_update2 =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(-4, -2, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update2));
    EXPECT_EQ(-4, scroll_update2.data.scrollUpdate.deltaX);
    EXPECT_EQ(0, scroll_update2.data.scrollUpdate.deltaY);

    WebGestureEvent fling_start = SyntheticWebGestureEventBuilder::BuildFling(
        kFlingX, kFlingY, WebGestureEvent::Touchscreen);
    EXPECT_FALSE(filter.FilterGestureEvent(&fling_start));
    EXPECT_EQ(kFlingX, fling_start.data.flingStart.velocityX);
    EXPECT_EQ(0, fling_start.data.flingStart.velocityY);
  }

  {
    // Scrolls hinted mostly in the Y direction are suppressed entirely.
    filter.OnSetTouchAction(TOUCH_ACTION_PAN_X);
    WebGestureEvent scroll_begin =
        SyntheticWebGestureEventBuilder::BuildScrollBegin(-7, 8);
    EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));

    WebGestureEvent scroll_update =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDX, kDY, 0);
    EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
    EXPECT_EQ(kDX, scroll_update.data.scrollUpdate.deltaX);
    EXPECT_EQ(kDY, scroll_update.data.scrollUpdate.deltaY);

    EXPECT_TRUE(filter.FilterGestureEvent(&scroll_end));
  }
}

TEST(TouchActionFilterTest, PanY) {
  TouchActionFilter filter;
  const float kDX = 5;
  const float kDY = 10;
  const float kFlingX = 7;
  const float kFlingY = -4;
  WebGestureEvent scroll_end = SyntheticWebGestureEventBuilder::Build(
      WebInputEvent::GestureScrollEnd, WebGestureEvent::Touchscreen);

  {
    // Scrolls with no direction hint are permitted in the Y axis.
    filter.OnSetTouchAction(TOUCH_ACTION_PAN_Y);

    WebGestureEvent scroll_begin =
        SyntheticWebGestureEventBuilder::BuildScrollBegin(0, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));

    WebGestureEvent scroll_update =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDX, kDY, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
    EXPECT_EQ(0, scroll_update.data.scrollUpdate.deltaX);
    EXPECT_EQ(kDY, scroll_update.data.scrollUpdate.deltaY);

    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));
  }

  {
    // Scrolls hinted mostly in the Y axis are permitted in that axis.
    filter.OnSetTouchAction(TOUCH_ACTION_PAN_Y);
    WebGestureEvent scroll_begin =
        SyntheticWebGestureEventBuilder::BuildScrollBegin(-6, 7);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));

    WebGestureEvent scroll_update =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDX, kDY, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
    EXPECT_EQ(0, scroll_update.data.scrollUpdate.deltaX);
    EXPECT_EQ(kDY, scroll_update.data.scrollUpdate.deltaY);

    WebGestureEvent scroll_update2 =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(-4, -2, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update2));
    EXPECT_EQ(0, scroll_update2.data.scrollUpdate.deltaX);
    EXPECT_EQ(-2, scroll_update2.data.scrollUpdate.deltaY);

    WebGestureEvent fling_start = SyntheticWebGestureEventBuilder::BuildFling(
        kFlingX, kFlingY, WebGestureEvent::Touchscreen);
    EXPECT_FALSE(filter.FilterGestureEvent(&fling_start));
    EXPECT_EQ(0, fling_start.data.flingStart.velocityX);
    EXPECT_EQ(kFlingY, fling_start.data.flingStart.velocityY);
  }

  {
    // Scrolls hinted mostly in the X direction are suppressed entirely.
    filter.OnSetTouchAction(TOUCH_ACTION_PAN_Y);
    WebGestureEvent scroll_begin =
        SyntheticWebGestureEventBuilder::BuildScrollBegin(-8, 7);
    EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));

    WebGestureEvent scroll_update =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDX, kDY, 0);
    EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
    EXPECT_EQ(kDX, scroll_update.data.scrollUpdate.deltaX);
    EXPECT_EQ(kDY, scroll_update.data.scrollUpdate.deltaY);

    EXPECT_TRUE(filter.FilterGestureEvent(&scroll_end));
  }
}

TEST(TouchActionFilterTest, PanXY) {
  TouchActionFilter filter;
  const float kDX = 5;
  const float kDY = 10;
  const float kFlingX = 7;
  const float kFlingY = -4;

  {
    // Scrolls hinted in the X axis are permitted and unmodified.
    filter.OnSetTouchAction(TOUCH_ACTION_PAN_X_Y);
    WebGestureEvent scroll_begin =
        SyntheticWebGestureEventBuilder::BuildScrollBegin(-7, 6);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));

    WebGestureEvent scroll_update =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDX, kDY, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
    EXPECT_EQ(kDX, scroll_update.data.scrollUpdate.deltaX);
    EXPECT_EQ(kDY, scroll_update.data.scrollUpdate.deltaY);

    WebGestureEvent fling_start = SyntheticWebGestureEventBuilder::BuildFling(
        kFlingX, kFlingY, WebGestureEvent::Touchscreen);
    EXPECT_FALSE(filter.FilterGestureEvent(&fling_start));
    EXPECT_EQ(kFlingX, fling_start.data.flingStart.velocityX);
    EXPECT_EQ(kFlingY, fling_start.data.flingStart.velocityY);
  }

  {
    // Scrolls hinted in the Y axis are permitted and unmodified.
    filter.OnSetTouchAction(TOUCH_ACTION_PAN_X_Y);
    WebGestureEvent scroll_begin =
        SyntheticWebGestureEventBuilder::BuildScrollBegin(-6, 7);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));

    WebGestureEvent scroll_update =
        SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDX, kDY, 0);
    EXPECT_FALSE(filter.FilterGestureEvent(&scroll_update));
    EXPECT_EQ(kDX, scroll_update.data.scrollUpdate.deltaX);
    EXPECT_EQ(kDY, scroll_update.data.scrollUpdate.deltaY);

    WebGestureEvent fling_start = SyntheticWebGestureEventBuilder::BuildFling(
        kFlingX, kFlingY, WebGestureEvent::Touchscreen);
    EXPECT_FALSE(filter.FilterGestureEvent(&fling_start));
    EXPECT_EQ(kFlingX, fling_start.data.flingStart.velocityX);
    EXPECT_EQ(kFlingY, fling_start.data.flingStart.velocityY);
  }
}

TEST(TouchActionFilterTest, Intersect) {
  EXPECT_EQ(TOUCH_ACTION_NONE,
      TouchActionFilter::Intersect(TOUCH_ACTION_NONE, TOUCH_ACTION_AUTO));
  EXPECT_EQ(TOUCH_ACTION_NONE,
      TouchActionFilter::Intersect(TOUCH_ACTION_AUTO, TOUCH_ACTION_NONE));
  EXPECT_EQ(TOUCH_ACTION_PAN_X,
      TouchActionFilter::Intersect(TOUCH_ACTION_AUTO, TOUCH_ACTION_PAN_X));
  EXPECT_EQ(TOUCH_ACTION_PAN_Y,
      TouchActionFilter::Intersect(TOUCH_ACTION_PAN_Y, TOUCH_ACTION_AUTO));
  EXPECT_EQ(TOUCH_ACTION_AUTO,
      TouchActionFilter::Intersect(TOUCH_ACTION_AUTO, TOUCH_ACTION_AUTO));
  EXPECT_EQ(TOUCH_ACTION_PAN_X,
      TouchActionFilter::Intersect(TOUCH_ACTION_PAN_X_Y, TOUCH_ACTION_PAN_X));
  EXPECT_EQ(TOUCH_ACTION_PAN_Y,
      TouchActionFilter::Intersect(TOUCH_ACTION_PAN_Y, TOUCH_ACTION_PAN_X_Y));
  EXPECT_EQ(TOUCH_ACTION_PAN_X_Y,
      TouchActionFilter::Intersect(TOUCH_ACTION_PAN_X_Y, TOUCH_ACTION_AUTO));
  EXPECT_EQ(TOUCH_ACTION_NONE,
      TouchActionFilter::Intersect(TOUCH_ACTION_PAN_X, TOUCH_ACTION_PAN_Y));
}

TEST(TouchActionFilterTest, MultiTouch) {
  TouchActionFilter filter;

  WebGestureEvent scroll_begin =
      SyntheticWebGestureEventBuilder::BuildScrollBegin(2, 3);
  const float kDeltaX = 5;
  const float kDeltaY = 10;
  WebGestureEvent scroll_update =
      SyntheticWebGestureEventBuilder::BuildScrollUpdate(kDeltaX, kDeltaY, 0);
  WebGestureEvent scroll_end = SyntheticWebGestureEventBuilder::Build(
      WebInputEvent::GestureScrollEnd, WebGestureEvent::Touchscreen);

  // For multiple points, the intersection is what matters.
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  filter.OnSetTouchAction(TOUCH_ACTION_AUTO);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_EQ(kDeltaX, scroll_update.data.scrollUpdate.deltaX);
  EXPECT_EQ(kDeltaY, scroll_update.data.scrollUpdate.deltaY);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_end));

  // Intersection of PAN_X and PAN_Y is NONE.
  filter.OnSetTouchAction(TOUCH_ACTION_PAN_X);
  filter.OnSetTouchAction(TOUCH_ACTION_PAN_Y);
  filter.OnSetTouchAction(TOUCH_ACTION_PAN_X_Y);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_end));
}

TEST(TouchActionFilterTest, Pinch) {
  TouchActionFilter filter;

  WebGestureEvent scroll_begin =
      SyntheticWebGestureEventBuilder::BuildScrollBegin(2, 3);
  WebGestureEvent pinch_begin = SyntheticWebGestureEventBuilder::Build(
          WebInputEvent::GesturePinchBegin, WebGestureEvent::Touchscreen);
  WebGestureEvent pinch_update =
      SyntheticWebGestureEventBuilder::BuildPinchUpdate(1.2f, 5, 5, 0);
  WebGestureEvent pinch_end = SyntheticWebGestureEventBuilder::Build(
          WebInputEvent::GesturePinchEnd, WebGestureEvent::Touchscreen);
  WebGestureEvent scroll_end = SyntheticWebGestureEventBuilder::Build(
      WebInputEvent::GestureScrollEnd, WebGestureEvent::Touchscreen);

  // Pinch is allowed with touch-action: auto.
  filter.OnSetTouchAction(TOUCH_ACTION_AUTO);
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_end));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));

  // Pinch is not allowed with touch-action: none.
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_end));
  EXPECT_TRUE(filter.FilterGestureEvent(&scroll_end));

  // Pinch is not allowed with touch-action: pan-x pan-y.
  filter.OnSetTouchAction(TOUCH_ACTION_PAN_X_Y);
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_end));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));

  // Pinch state is automatically reset at the end of a scroll.
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_end));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));

  // Pinching can become disallowed during a single scroll gesture, but
  // can't become allowed again until the scroll terminates.
  // Note that the current TouchEventQueue design makes this scenario
  // impossible in practice (no touch events are sent to the renderer
  // while scrolling) and so no SetTouchAction can occur.  But this
  // could change in the future, so it's still worth verifying in this
  // unit test.
  filter.OnSetTouchAction(TOUCH_ACTION_AUTO);
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_end));
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_end));
  filter.OnSetTouchAction(TOUCH_ACTION_AUTO);
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_end));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));

  // Once a pinch has started, any change in state won't affect the current
  // pinch gesture, but can affect a future one within the same scroll.
  filter.OnSetTouchAction(TOUCH_ACTION_AUTO);
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_begin));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_begin));
  filter.OnSetTouchAction(TOUCH_ACTION_NONE);
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_FALSE(filter.FilterGestureEvent(&pinch_end));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_begin));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_update));
  EXPECT_TRUE(filter.FilterGestureEvent(&pinch_end));
  EXPECT_FALSE(filter.FilterGestureEvent(&scroll_end));
}

}  // namespace content
