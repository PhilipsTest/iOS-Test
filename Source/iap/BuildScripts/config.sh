#!/bin/sh


# Required:
# export APP_NAME=theapp (example: Nitro)
export APP_NAME=InAppPurchase

# To be set in Jenkins:
# CONFIG   (example: Debug|Distribution)

################### Building ##########################

#optional: define the Git branch, if it is not either master (for a Release/Distribution build) or develop (for a Debug build)
# export BRANCH=gitBranch (example: develop)

# Optional: define xcode project folder, if this is different than the app_name
export PROJECT_PATH=$WORKSPACE/${APP_NAME}

# Optional: if we are building a workspace instead of a project
export XCODE_WORKSPACE=${APP_NAME}/${APP_NAME}.xcworkspace
# export XCODE_WORKSPACE=${APP_NAME}.xcworkspace

# optional: define xcode project name, if this is different than the app_name
# export PROJECT_NAME=${APP_NAME}

# Optional (when xcode target name is different than app name):
# export TARGET=${APP_NAME}

# Optional: use xcodebuild instead of xctool: set this to 1
export USE_XCODEBUILD=1

export USE_XCPRETTY=1

# Optional: define which SDK to use for testing
 export SDK=iphonesimulator9.1

# Optional: define location of Xcode
# export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

# Optional: define build architectures
# export BUILD_ARCHITECTURES="armv7 armv7s"

################## Unit tests #########################

# Optional: to skip unit tests, set this to 1
# export SKIP_UNIT_TESTS=0

# Optional: to skip unit tests for a build configuration
# export SKIP_UNIT_TESTS_FOR_CONFIG=Distribution
export SKIP_UNIT_TESTS_FOR_CONFIG=Release

# Optional: default Tests target is appname + "Tests"
# export TEST_TARGET=${APP_NAME}Tests

##################### Analysis  #######################

# Optional: disable computation of code complexity metrics; set to 1 to disable
export DISABLE_COMPLEXITY=1

# Optional: enable computation of code coverage metrics; set to 1 to enable
# export ENABLE_CODECOVERAGE=1
export ENABLE_CODECOVERAGE=1

# Optional: exclude patterns for code coverage
# (e.g. libraries that you use that do not have tests)
#export CODECOVERAGE_EXCLUDES='.*/RegistrationiOS/ .*/RegistrationIOS/ .*/Janrain/ .*/RegistartionTests/ .*/RegistrationUI/'

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
