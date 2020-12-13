#!/bin/bash -l
PODSPEC_PATH="ci-build-support/Versions.rb"
VERSION_REGEX="VersionCDP2Platform[^\'|\"]*[\'|\"]([^\'|\"]*)[\'|\"]"
COMPONENT_VERSION=`cat $PODSPEC_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"`
if [ '''+ReleaseBranch+''' = true ]
then
    ARTIFACTORY_REPO="iet-mobile-ios-release-local"
else
    ARTIFACTORY_REPO="iet-mobile-ios-snapshot-local"
fi

export ZIPFOLDER="Zips"
export ARTIFACTORY_URL="https://artifactory-ehv.ta.philips.com/artifactory/${ARTIFACTORY_REPO}/com/philips/platform/Zip_Sources"
cd Source
echo "Upload started"
cd ${ZIPFOLDER}
rm -rf Source
pwd
for i in *; do
    export ARTIFACTORYUPLOADURL="${ARTIFACTORY_URL}/${COMPONENT_VERSION}/${i}"
    echo "Uploading Zip for $i at path ${ARTIFACTORYUPLOADURL}"
    curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "${ARTIFACTORYUPLOADURL}" -T $i
done
echo "Upload ended"
cd -
echo "Removing Zips Folder"
rm -rf ${ZIPFOLDER}
