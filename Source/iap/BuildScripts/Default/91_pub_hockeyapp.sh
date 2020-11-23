#!/bin/sh

if [[ "$USE_HOCKEYAPP_DISTRIBUTION" != "1" ]]; then
	echo "Skipping Hockeyapp distribution for $APP_NAME"
	exit
fi

echo Running script: `basename "$0"`

if [ "$MAKE_DISTRIBUTION_BUILD" = "1" ]
then

	echo "Send to Hockeyapp: $IPA_NAME"

	(
	  cd "$BUILD_DIR"
  
	  echo "IPA=$IPA_NAME"
	  echo "API TOKEN=$HOCKEYAPP_APITOKEN"

	  if [ -z "$HOCKEYAPP_STATUS" ]
	  then
	  	let HOCKEYAPP_STATUS=2
	  fi
	  echo "HOCKEYAPP_STATUS=$HOCKEYAPP_STATUS"

	  if [ -z "$HOCKEYAPP_NOTIFY" ]
	  then
	  	let HOCKEYAPP_NOTIFY=1
	  fi
	  echo "HOCKEYAPP_NOTIFY=$HOCKEYAPP_NOTIFY"

	  if [ -z "$HOCKEYAPP_TAGS" ]
	  then
	  	let HOCKEYAPP_TAGS='test'
	  fi
	  echo "HOCKEYAPP_TAGS=$HOCKEYAPP_TAGS"

	  curl \
		  -F "status=$HOCKEYAPP_STATUS" \
		  -F "notify=$HOCKEYAPP_NOTIFY" \
		  -F "ipa=@$IPA_NAME" \
		  -F "tags=$HOCKEYAPP_TAGS" \
		  -H "X-HockeyAppToken:$HOCKEYAPP_APITOKEN" \
		  https://rink.hockeyapp.net/api/2/apps/upload
	)
else
	echo "Skipped hockeyapp"
fi