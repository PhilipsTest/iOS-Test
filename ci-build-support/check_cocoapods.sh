# Use from xcode buildscript:
# Build phases / New Run Script Phase
#   shell:
#     /bin/sh Tools/check_cocoapods.sh

# This file checks for the cocoapods version with the 'EXPECTED_VERSION'
# if POD 'VERSION' is less the 'EXPECTED_VERSION' it will exit the script with error as echo
# Update the EXPECTED_VERSION when cocoapods version is upgraded
export LANG=en_US.UTF-8

EXPECTED_VERSION="1.7.5"
VERSION=`pod --version`

if which pod >/dev/null; then
  if [ "${VERSION}" != "${EXPECTED_VERSION}" ]; then
    echo "ERROR: incorrect Cocoapods version installed. Expected '${EXPECTED_VERSION}', found '${VERSION}'"
    exit 42
  else
    echo "Correct Cocoapods version installed: '${VERSION}'"
  fi
else
  echo "ERROR: cocopoads not installed"
  exit 42
fi
