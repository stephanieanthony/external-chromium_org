// Copyright 2013 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "chrome/browser/media/media_browsertest.h"

#include "base/path_service.h"
#include "base/strings/stringprintf.h"
#include "base/strings/utf_string_conversions.h"
#include "chrome/browser/ui/browser.h"
#include "chrome/browser/ui/tabs/tab_strip_model.h"
#include "chrome/common/chrome_paths.h"
#include "chrome/test/base/ui_test_utils.h"
#include "content/public/test/browser_test_utils.h"

// Common test results.
const char MediaBrowserTest::kEnded[] = "ENDED";
const char MediaBrowserTest::kError[] = "ERROR";
const char MediaBrowserTest::kFailed[] = "FAILED";

MediaBrowserTest::MediaBrowserTest() {
}

MediaBrowserTest::~MediaBrowserTest() {
}

void MediaBrowserTest::RunMediaTestPage(
    const std::string& html_page, std::vector<StringPair>* query_params,
    const std::string& expected_title, bool http) {
  GURL gurl;
  std::string query = "";
  if (query_params != NULL && !query_params->empty()) {
    std::vector<StringPair>::const_iterator itr = query_params->begin();
    query = itr->first + "=" + itr->second;
    ++itr;
    for (; itr != query_params->end(); ++itr) {
      query.append("&" + itr->first + "=" + itr->second);
    }
  }
  if (http) {
    ASSERT_TRUE(test_server()->Start());
    gurl = test_server()->GetURL("files/media/" + html_page + "?" + query);
  } else {
    base::FilePath test_file_path;
    PathService::Get(chrome::DIR_TEST_DATA, &test_file_path);
    test_file_path = test_file_path.AppendASCII("media")
                                   .AppendASCII(html_page);
    gurl = content::GetFileUrlWithQuery(test_file_path, query);
  }

  base::string16 final_title = RunTest(gurl, expected_title);
  EXPECT_EQ(base::ASCIIToUTF16(expected_title), final_title);
}

base::string16 MediaBrowserTest::RunTest(const GURL& gurl,
                                         const std::string& expected_title) {
  DVLOG(1) << "Running test URL: " << gurl;
  content::TitleWatcher title_watcher(
      browser()->tab_strip_model()->GetActiveWebContents(),
      base::ASCIIToUTF16(expected_title));
  AddWaitForTitles(&title_watcher);
  ui_test_utils::NavigateToURL(browser(), gurl);

  return title_watcher.WaitAndGetTitle();
}

void MediaBrowserTest::AddWaitForTitles(content::TitleWatcher* title_watcher) {
  title_watcher->AlsoWaitForTitle(base::ASCIIToUTF16(kEnded));
  title_watcher->AlsoWaitForTitle(base::ASCIIToUTF16(kError));
  title_watcher->AlsoWaitForTitle(base::ASCIIToUTF16(kFailed));
}
