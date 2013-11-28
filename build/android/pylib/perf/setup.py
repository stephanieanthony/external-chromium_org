# Copyright 2013 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Generates test runner factory and tests for performance tests."""

import json
import fnmatch
import logging
import os
import psutil
import signal
import shutil
import time

from pylib import android_commands
from pylib import cmd_helper
from pylib import constants
from pylib import forwarder
from pylib import ports

import test_runner


def _KillPendingServers():
  for retry in range(5):
    for server in ['lighttpd', 'web-page-replay']:
      pids = [p.pid for p in psutil.process_iter() if server in p.name]
      for pid in pids:
        try:
          logging.warning('Killing %s %s', server, pid)
          os.kill(pid, signal.SIGQUIT)
        except Exception as e:
          logging.warning('Failed killing %s %s %s', server, pid, e)
  # Restart the adb server with taskset to set a single CPU affinity.
  cmd_helper.RunCmd([constants.ADB_PATH, 'kill-server'])
  cmd_helper.RunCmd(['taskset', '-c', '0', constants.ADB_PATH, 'start-server'])
  cmd_helper.RunCmd(['taskset', '-c', '0', constants.ADB_PATH, 'root'])
  i = 1
  while not android_commands.GetAttachedDevices():
    time.sleep(i)
    i *= 2
    if i > 10:
      break

  forwarder.Forwarder.UseMultiprocessing()


def Setup(test_options):
  """Create and return the test runner factory and tests.

  Args:
    test_options: A PerformanceOptions object.

  Returns:
    A tuple of (TestRunnerFactory, tests).
  """
  # TODO(bulach): remove this once the bot side lands. BUG=318369
  constants.SetBuildType('Release')
  if os.path.exists(constants.PERF_OUTPUT_DIR):
    shutil.rmtree(constants.PERF_OUTPUT_DIR)
  os.makedirs(constants.PERF_OUTPUT_DIR)

  # Before running the tests, kill any leftover server.
  _KillPendingServers()

  if test_options.single_step:
    # Running a single command, build the tests structure.
    tests = [['single_step', test_options.single_step]]

  if test_options.steps:
    with file(test_options.steps, 'r') as f:
      tests = json.load(f)

  # The list is necessary to keep the steps order, but internally
  # the format is squashed from a list of lists into a single dict:
  # [["A", "cmd"], ["B", "cmd"]] into {"A": "cmd", "B": "cmd"}
  sorted_test_names = [i[0] for i in tests]
  tests_dict = dict(tests)

  if test_options.test_filter:
    sorted_test_names = fnmatch.filter(sorted_test_names,
                                       test_options.test_filter)
    tests_dict = dict((k, v) for k, v in tests_dict.iteritems()
                      if k in sorted_test_names)

  flaky_steps = []
  if test_options.flaky_steps:
    with file(test_options.flaky_steps, 'r') as f:
      flaky_steps = json.load(f)

  def TestRunnerFactory(device, shard_index):
    return test_runner.TestRunner(
        test_options, device, tests_dict, flaky_steps)

  return (TestRunnerFactory, sorted_test_names)