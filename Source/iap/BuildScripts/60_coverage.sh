#!/bin/sh

if ( test "$ENABLE_CODECOVERAGE" != "1" ); then
	echo "Skipping code coverage reporting (for unit tests)."
	exit
fi

echo Running script: `basename "$0"`

if [ "$CONFIG" = "Debug" ]
then
(
    coverageFileDir="$BUILD_DIR/Build/Intermediates/$APP_NAME.build/Debug-iphonesimulator/${TEST_TARGET}.build/Objects-normal/i386"

    pushd "$WORKSPACE" >> /dev/null

    GCOVR_ARGS="-r ../.. --object-directory=$coverageFileDir -x -o $BUILD_DIR/coverage.xml"
    if [ -n "$CODECOVERAGE_EXCLUDES" ]; then
        for X in $CODECOVERAGE_EXCLUDES; do
          GCOVR_ARGS="$GCOVR_ARGS -e $X"
        done
    fi

    python $absScriptDir/gcovr $GCOVR_ARGS

    popd >> /dev/null
)

fi
