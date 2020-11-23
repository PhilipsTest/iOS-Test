#!/bin/sh

if (test "$SKIP_UNIT_TESTS" = "1"); then
	echo "Skipping unit tests for $APP_NAME"
	exit
fi

if (test "$SKIP_UNIT_TESTS_FOR_CONFIG" = "$CONFIG"); then
	echo "Skipping unit tests for configuration $CONFIG for $APP_NAME"
	exit
fi

if [ -z "${TEST_PROJECT_PATH}" ]; then
	export TEST_PROJECT_PATH="${PROJECT_NAME}".xcodeproj
fi

if [ -z "${TEST_WORKSPACE_PATH}" ]; then
	export TEST_WORKSPACE_PATH="${XCODE_WORKSPACE}"
fi

if [ -z "${TEST_SCHEME}" ]; then
	export TEST_SCHEME="${XCODE_SCHEME}Tests"
fi

echo Running script: `basename "$0"`

echo Run unit tests for $APP_NAME, target is $TEST_SCHEME

export INVOKED_BY_JENKINS=1

require_variable TEST_TARGET
require_variable SDK
require_variable CONFIG

function compileAndRunTests {
  result=-42
  if (test -n "${TEST_WORKSPACE_PATH}"); then
    ${testCmd} test -workspace "${TEST_WORKSPACE_PATH}" -scheme "${TEST_SCHEME}" -sdk $SDK -configuration $CONFIG | ${xcprettyCmd} && result=${PIPESTATUS[0]}
  else
    ${testCmd} test -project "${TEST_PROJECT_PATH}" -scheme "${TEST_SCHEME}" -sdk $SDK -configuration "$CONFIG" | ${xcprettyCmd} && result=${PIPESTATUS[0]}
  fi
  echo "Testing completed with exit code: $result"; return $result
}

# Open simulator prior to build in an attempt to work around an issue where the
# simulator times out when the build takes more than 120 seconds to complete. 
# See also http://www.openradar.me/22413115
open -a "Simulator"

# Run twice to work around a known bug in the iOS simulator that occasionally 
# fails to install the app (see also https://devforums.apple.com/thread/248879).
compileAndRunTests || compileAndRunTests
