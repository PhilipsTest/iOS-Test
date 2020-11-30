#!/bin/bash -l
VERSIONS_FILE_PATH="ci-build-support/Versions.rb"

if [ ! -f "${VERSIONS_FILE_PATH}" ]
then
    echo ""
    exit 1
fi

VERSION_REGEX="VersionCDP2Platform[^'|\\"]*['|\\"]([^'|\\"]*)['|\\"]"
cat $VERSIONS_FILE_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"
