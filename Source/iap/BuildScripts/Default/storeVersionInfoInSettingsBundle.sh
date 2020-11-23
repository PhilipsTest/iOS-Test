#!/bin/bash

### this script can be run as build phase after compiling, like this:
###    sh $PROJECT_DIR/../../BuildScripts/iOS-BuildScripts/storeVersionInfoInSettingsBundle.sh

#set -e -x

EXPECTED_SETTINGS_TITLE_FOR_VERSION=Version

### prepare variables
if (test -z "$scriptDir"); then

    export scriptDir="`dirname \"$0\"`"
    export absScriptDir="`cd \"$scriptDir\"; pwd`"
    source "$absScriptDir/utils.sh"
fi

if (test -z "$VERSION_NUMBER"); then

    export VERSION_NUMBER=`agvtool mvers -terse1`
    echo "VERSION_NUMBER=$VERSION_NUMBER"

    export CONFIG=Debug
    export WORKSPACE=`pwd`
    export APP_NAME=$TARGETNAME
    export PROJECT_PATH=$PROJECT_DIR;
fi

if (test -z "$TARGET_INFO_PLIST"); then
	export TARGET_INFO_PLIST="$APP_NAME/$TARGETNAME-Info.plist"
fi
if (test -z "$SETTINGS_BUNDLE_ROOT_PLIST"); then
	export SETTINGS_BUNDLE_ROOT_PLIST="$APP_NAME/Settings.bundle/Root.plist"
fi

### Read version info from Info.plist

BUILD_NUMBER=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$TARGET_INFO_PLIST"`
VERSION_NUMBER=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$TARGET_INFO_PLIST"`


### Note: this count might not work correctly when you use groups in your settings bundle
numSettings=`/usr/libexec/PlistBuddy -c "Print PreferenceSpecifiers" "$SETTINGS_BUNDLE_ROOT_PLIST"|grep "^[[:space:]]*Dict"|wc -l`

echo "number of items in settings: $numSettings"

versionString="$VERSION_NUMBER ($BUILD_NUMBER)"

for (( idx=1; idx<$numSettings; idx++ ))
do
    val=`/usr/libexec/PlistBuddy -c "Print PreferenceSpecifiers:$idx:Title" $SETTINGS_BUNDLE_ROOT_PLIST`

    if [ "$val" == "$EXPECTED_SETTINGS_TITLE_FOR_VERSION" ]; then
        echo "the index of the entry whose 'Title' is '$EXPECTED_SETTINGS_TITLE_FOR_VERSION' is $idx."

        /usr/libexec/PlistBuddy -c "Set PreferenceSpecifiers:${idx}:DefaultValue \"$versionString\"" $SETTINGS_BUNDLE_ROOT_PLIST

        # just to be sure that it worked
        ver=`/usr/libexec/PlistBuddy -c "Print PreferenceSpecifiers:$idx:DefaultValue" $SETTINGS_BUNDLE_ROOT_PLIST`
        echo "PreferenceSpecifiers:$idx:DefaultValue set to: " $ver
    fi
done
