#!/bin/sh

if [[ "$USE_TESTFLIGHT_DISTRIBUTION" != "1" ]]; then
	echo "Skipping testflight distribution for $APP_NAME"
	exit
fi

echo Running script: `basename "$0"`

if [ "$MAKE_DISTRIBUTION_BUILD" = "1" ]
then

	echo "Send to testflight: $IPA_NAME"
	REL_NOTES="$PROJECT_PATH/ReleaseNotes.txt"

#	APP_DIR="$BUILD_DIR/sym/${CONFIG}-iphoneos"

	(
	  cd "$BUILD_DIR"
  
	  echo "IPA=$IPA_NAME"
	  curl http://testflightapp.com/api/builds.json -F file=@$IPA_NAME -F api_token=$TESTFLIGHT_APITOKEN -F team_token=$TESTFLIGHT_TEAMTOKEN -F notes=@"$REL_NOTES" -F notify=True -F distribution_lists=$TESTFLIGHT_DISTLIST

	)
else
	echo "Skipped testflight"
fi