#!/bin/bash -l
chmod 755 ./ci-build-support/podspec_immutable_dependencies.sh
chmod 755 ./ci-build-support/substitute_version.groovy
ci-build-support/podspec_immutable_dependencies.sh $1 $2 ${GITHUB_REF#refs/heads/}
ci-build-support/podspec_push.sh $1 ${GITHUB_REF#refs/heads/}
