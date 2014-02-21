// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/**
 * @fileoverview Code injected into Gaia sign in page for inline sign in flow.
 * On load stop, it receives a message from the embedder extension with a
 * JavaScript reference to the embedder window. Then upon submit of the sign
 * in form, it posts the username and password to the embedder window.
 * Prototype Only.
 */

(function() {
  var $ = function(id) { return document.getElementById(id); };

  var gaiaLoginForm = $('gaia_loginform');
  if (!gaiaLoginForm) {
    return;
  }

  var onLoginSubmit = function(e) {
    var checkboxElement = $('advanced-box');
    var chooseWhatToSync = checkboxElement && checkboxElement.checked;
    var msg = {method: 'attemptLogin',
               email: gaiaLoginForm['Email'].value,
               password: gaiaLoginForm['Passwd'].value,
               attemptToken: new Date().getTime(),
               chooseWhatToSync: chooseWhatToSync};

    window.parent.postMessage(
        msg, 'chrome-extension://mfffpogegjflfpflabcdkioaeobkgjik');
    console.log('Credentials sent');

    return;
  };
  // Overrides the submit handler for the gaia login form.
  gaiaLoginForm.onsubmit = onLoginSubmit;
})();
