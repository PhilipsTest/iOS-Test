#!/bin/sh

if [[ "$SKIP_RELEASE_TO_SVN" = "1" ]]; then
	echo "Skipping publication to svn  distribution for $APP_NAME"
	exit
fi

echo Running script: `basename "$0"`


if [ "$MAKE_DISTRIBUTION_BUILD" = "1" ]; then

	if [ -z "$SVN_RELEASE_PATH" ]; then
		SVN_RELEASE_PATH="scmobile/Releases"
	fi
	
	(
	  cd "$BUILD_DIR"
	
	  /usr/bin/svn import --trust-server-cert --non-interactive --force -m "Released $APP_NAME version $VERSION_NUMBER - ipa" "$IPA_NAME" "https://mobilebuild@redmine.natlab.research.philips.com/svnroot/$SVN_RELEASE_PATH/$APP_NAME/$VERSION_NUMBER/$APP_NAME-$VERSION_NUMBER.ipa" || fatal "SVN import of IPA failed"

	  /usr/bin/svn import --trust-server-cert --non-interactive --force -m "Released $APP_NAME version $VERSION_NUMBER - xcarchive" "$BUILD_DIR/$APP_NAME.xcarchive" "https://mobilebuild@redmine.natlab.research.philips.com/svnroot/$SVN_RELEASE_PATH/$APP_NAME/$VERSION_NUMBER/$APP_NAME-$VERSION_NUMBER.xcarchive" || fatal "SVN import of xcarchive failed"
	)
	
fi
