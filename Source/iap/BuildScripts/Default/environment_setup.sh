#!/bin/sh

echo Running script : `basename "$0"`

echo Setting up build folders

if [ -z "$WORKSPACE" ]; then
echo ""
fatal "Error: missing WORKSPACE variable. Should be run from Jenkins..."
fi

export BUILD_DIR="$WORKSPACE/build"
export XCODEBUILD_CMD="/usr/bin/xcrun xcodebuild"

if [ -z "$PROJECT_SUBDIR" ]; then
    export PROJECT_SUBDIR=$APP_NAME
    echo "Guessing PROJECT_SUBDIR: $PROJECT_SUBDIR"
fi


if [ -z "$PROJECT_PATH" ]; then
    export PROJECT_PATH=$WORKSPACE/${APP_NAME}
    if [ ! -d "$PROJECT_PATH" ]; then
        export PROJECT_PATH=$WORKSPACE/Source/${APP_NAME}
    fi
    echo "Guessing PROJECT_PATH: $PROJECT_PATH"
fi

if [ -z "$PROJECT_NAME" ]; then
    export PROJECT_NAME="$APP_NAME"
fi

if [ -z "$SDK" ]; then
    export SDK=iphonesimulator
fi

if [ -z "$TARGET" ]; then
    export TARGET=${APP_NAME}
fi

if [ -z "$TEST_TARGET" ]; then
    export TEST_TARGET=${TARGET}Tests
fi

if [ -z "$XCODE_SCHEME" ]; then
    export XCODE_SCHEME="$TARGET"
fi

#Set XCPretty output format
export LC_CTYPE=en_US.UTF-8
export xcprettyCmd="xcpretty --report junit --output ../unittest.xml"

export buildCmd="$XCODEBUILD_CMD ONLY_ACTIVE_ARCH=NO -derivedDataPath $BUILD_DIR"
export testCmd="$XCODEBUILD_CMD ONLY_ACTIVE_ARCH=NO TEST_AFTER_BUILD=YES -derivedDataPath $BUILD_DIR"


export BUILD_ACTION="build"
if [ -z "$MAKE_DISTRIBUTION_BUILD" ]; then
    if [ "$CONFIG" = "Distribution" -o "$CONFIG" = "Release" ]; then
        export MAKE_DISTRIBUTION_BUILD=1
        export BUILD_ACTION="archive -archivePath $BUILD_DIR/$APP_NAME.xcarchive"
    fi
fi

echo "-------------- build settings ------------------"
echo "CONFIG          =$CONFIG"
echo "TARGET          =$TARGET"
echo "PROJECT_SUBDIR  =$PROJECT_SUBDIR"
echo "TEST_TARGET     =$TEST_TARGET"
echo "SDK             =$SDK"
echo "PROJECT_PATH    =$PROJECT_PATH"
echo "XCODE_SCHEME    =$XCODE_SCHEME"
echo "BUILD_ACTION    =$BUILD_ACTION"
echo "-------------- - - - - - - - - -----------------"


cd "$PROJECT_PATH"

if [ "$MAKE_DISTRIBUTION_BUILD" = "1" ]
then

    if [ ! -n "$BRANCH" ]; then
        export BRANCH=master
    fi

    git checkout $BRANCH
    git pull

	if [ -z "${VERSION_NUMBER}" ]; then
	    export VERSION_NUMBER=`agvtool mvers -terse1`
	fi

    require_variable VERSION_NUMBER

    export APP_DIR="$BUILD_DIR/sym/$CONFIG-iphoneos"
    export IPA_NAME="$BUILD_DIR/$APP_NAME-$VERSION_NUMBER.ipa"

    if (test -z "$BUNDLE_IDENTIFIER"); then
        export BUNDLE_IDENTIFIER="com.philips.pins.$APP_NAME"
    fi


    echo "-------------- distribution settings ------------------"
    echo "BRANCH            =$BRANCH"
    echo "VERSION_NUMBER    =$VERSION_NUMBER"
    echo "BUILD_DIR         =$BUILD_DIR"
    echo "APP_DIR           =$APP_DIR"
    echo "IPA_NAME          =$IPA_NAME"
    echo "BUNDLE_IDENTIFIER =$BUNDLE_IDENTIFIER"
    echo "XCODE_WORKSPACE   =$XCODE_WORKSPACE"
    echo "-------------- - - - - - - - - -----------------"

fi

