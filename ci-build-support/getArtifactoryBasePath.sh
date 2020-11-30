#!/bin/bash -l
ARTIFACTORY_URL="https://artifactory-ehv.ta.philips.com/artifactory"

if [ '''+ReleaseBranch+''' = true ]
then
    ARTIFACTORY_REPO="iet-mobile-ios-release-local"
elif [ '''+DevelopBranch+''' = true ]
then
    ARTIFACTORY_REPO="iet-mobile-ios-snapshot-local"
else
    echo ""
    exit 0
fi

echo "$ARTIFACTORY_URL/$ARTIFACTORY_REPO/com/philips/platform"
