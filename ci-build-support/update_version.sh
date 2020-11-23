#!/bin/bash

# Using epoch time to updates the version (/ci-build-support/Versions.rb)

EPOCH_TIME=`/bin/date +%s`
echo "Epoch time is ${EPOCH_TIME}"

sed -i "" "s/1111111111/$EPOCH_TIME/g" ./ci-build-support/Versions.rb
