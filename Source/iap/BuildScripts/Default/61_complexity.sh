#!/bin/sh

set -x 

if ( test "$DISABLE_COMPLEXITY" = "1" ); then
	echo "Skipping complexity metrics calculation."
	exit
fi

echo Running script: `basename "$0"`

complexity=/opt/lizard/lizard
complexityOutput="$BUILD_DIR/complexity.xml"

$complexity -i 100 "$PROJECT_PATH" || fatal "Complexity calculations failed."
( $complexity -i 100 -X "$PROJECT_PATH" > $complexityOutput ) || fatal "Complexity calculations failed."