#!/bin/sh

if (test "$SKIP_XCODE_BUILD" = "1"); then
	echo "Skipping build for $APP_NAME"
	exit
fi

echo Running script : `basename "$0"`
echo call xcodebuild to build $APP_NAME

set -x

if (test -n "$XCODE_WORKSPACE"); then
	${buildCmd} -workspace "$XCODE_WORKSPACE" -scheme "$XCODE_SCHEME" -configuration "$CONFIG" ${BUILD_ACTION} | ${xcprettyCmd} && exit ${PIPESTATUS[0]}
elif (test -n "$XCODE_SCHEME"); then
    ${buildCmd} -project "${PROJECT_NAME}".xcodeproj -scheme "$XCODE_SCHEME" -configuration "$CONFIG" ${BUILD_ACTION} | ${xcprettyCmd} && exit ${PIPESTATUS[0]}
else
    ${buildCmd} -configuration "$CONFIG" ${BUILD_ACTION} | ${xcprettyCmd} && exit ${PIPESTATUS[0]}
fi
