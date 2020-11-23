#!/bin/sh

set -e
set -x

echo Running script: `basename "$0"`

if [[ "$SKIP_CREATE_GIT_TAG" = "1" ]]; then
   echo "Skipping git tag creation for $APP_NAME"
   exit
fi

if [ "$MAKE_DISTRIBUTION_BUILD" = "1" ] ; then

    echo "Tagging git branch master with version: $VERSION_NUMBER"

    GIT_ERROR=""

    # check if git is being used
    set +e
        git status || GIT_ERROR="error"
    set -e


    if [ -z "$GIT_ERROR" ] ; then

        echo "git ok"

        GIT_CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

        echo "Tagging v$VERSION_NUMBER on branch $GIT_CURRENT_BRANCH"

        # delete possible old tag on origin
        git push origin :refs/tags/v$VERSION_NUMBER

        # set new tag
        git tag -a -f v$VERSION_NUMBER -m "release v$VERSION_NUMBER"

        git push origin v$VERSION_NUMBER
    else
        echo "can't use git:"

        # show problem
        git status
    fi
else
    echo "Skipped distribution."
fi

