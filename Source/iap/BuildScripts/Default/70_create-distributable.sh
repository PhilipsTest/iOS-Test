#!/bin/sh

echo Running script: `basename "$0"`

if [ "$MAKE_DISTRIBUTION_BUILD" = "1" ]
then
    echo "Building distribution:"   

    set -e
    set -x

    (
        cd "$BUILD_DIR"

		xcrun -sdk iphoneos PackageApplication -v "$BUILD_DIR/$APP_NAME.xcarchive/Products/Applications/$APP_NAME.app" -o "$IPA_NAME"
        
        if [ ! -f "$IPA_NAME" ]
        then
            fatal "distibutable not created properly: $IPA_NAME"
        fi
    )
    
    echo "------------------------------ IPA built -----------------------------------";

else
    echo "Skipped distribution."
fi

