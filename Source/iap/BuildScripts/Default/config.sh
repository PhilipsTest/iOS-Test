#!/bin/sh


# Required:
# export APP_NAME=theapp (example: Nitro)

# To be set in Jenkins:
# CONFIG   (example: Debug|Distribution)

################### Building ##########################

#optional: define the Git branch, if it is not either master (for a Release/Distribution build) or develop (for a Debug build)
# export BRANCH=gitBranch (example: develop)

# Optional: define xcode project folder, if this is different than the app_name
# export PROJECT_PATH=$WORKSPACE/Source/${APP_NAME}

# Optional: if we are building a workspace instead of a project
# export XCODE_WORKSPACE=${APP_NAME}.xcworkspace

# Optional: define XCODE_SCHEME if scheme is different to the TARGET
# export XCODE_SCHEME="$TARGET"

# optional: define xcode project name, if this is different than the app_name
# export PROJECT_NAME=${APP_NAME}

# Optional (when xcode target name is different than app name):
# export TARGET=${APP_NAME}

# Optional: define which SDK to use for testing
# export SDK=iphonesimulator5.0

# Optional: define location of Xcode
# export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

################## Unit tests #########################

# Optional: to skip unit tests, set this to 1
# export SKIP_UNIT_TESTS=0

# Optional: to skip unit tests for a build configuration
# export SKIP_UNIT_TESTS_FOR_CONFIG=Distribution

# Optional: default Tests scheme is appname + "Tests"
# export TEST_SCHEME=${APP_NAME}Tests

# Optional: use different xcworkspace for finding the test target
# export TEST_WORKSPACE_PATH=<relative-path-to.xcworkspace>

# Optional: use different xcodeproj for finding the test target
# export TEST_PROJECT_PATH=<relative-path-to.xcodeproj>

##################### Analysis  #######################

# Optional: check that source code files contain proper copyright header.
# Note: currently only check files with .h and .m extensions.
# export COPYRIGHT_REGEX='Koninklijke Philips N.V., 201[45]. All rights reserved'

# Optional: pattern of file names that should be ignored by the copyright check; paths
# are relative to the PROJECT_PATH.
# export COPYRIGHT_FILE_IGNORE_PATTERN="\/Pods\/|Tests\/"

# Optional: disable computation of code complexity metrics; set to 1 to disable
# export DISABLE_COMPLEXITY=0

# Optional: enable computation of code coverage metrics; set to 1 to enable
# export ENABLE_CODECOVERAGE=1

# Optional: exclude patterns for code coverage
# (e.g. libraries that you use that do not have tests)
#export CODECOVERAGE_EXCLUDES='.*/SomeLibrary/ .*/SomeOtherLibrary/'

################## Version numbers  ###################

# Optional: Info.plist file used to read version information from
#export TARGET_INFO_PLIST="$PROJECT_PATH/$APP_NAME/$TARGET-Info.plist"

# Optional: Settings bundle plist where version number is written to
# PLEASE NOTE: The version number must be the LAST setting in that plist!
#export SETTINGS_BUNDLE_ROOT_PLIST="$PROJECT_PATH/$APP_NAME/Settings.bundle/Root.plist"

################## Publication  #######################

# --------------------  svn  --------------------

# Optional: to skip svn publishing, set SKIP_RELEASE_TO_SVN to 1
# export SKIP_RELEASE_TO_SVN=1

# --------------------  HockeyApp  --------------------

# Optional: to use HockeyApp distribution, set this to 1
#export USE_HOCKEYAPP_DISTRIBUTION=1
#export HOCKEYAPP_APITOKEN=b9d6e2f453894b4fbcb161b33a94f6c8

# Download state for uploaded app:
# - 1 to not allow users to download the version
# - 2 to make the version available for download
#export HOCKEYAPP_STATUS=2

# Notification flag for HockeyApp:
# - 0 to not notify testers
# - 1 to notify all testers that can install this app
# - 2 Notify all testers
#export HOCKEYAPP_NOTIFY=1

# Tags to set for the HockeyApp upload
#export HOCKEYAPP_TAGS='test'

# --------------------  TestFlight  --------------------

# Optional: to use testflight distribution, set this to 1
# export USE_TESTFLIGHT_DISTRIBUTION=1

# Optional: The distlist is the people that will be allowed to install the app.
# They will receive a notification.
# export TESTFLIGHT_DISTLIST=myapp-distlist

# Optional: The distlist is the people that will be allowed to install the app.
# They will receive a notification.
# export TESTFLIGHT_TEAMTOKEN=836fc5c3b1e6f60...NyAwMjozODowMC4yNzU3MzQ
# export TESTFLIGHT_APITOKEN=094baab3418abb...Mi0wNS0zMSAxNzozOToxMi4zNzY2MTI
