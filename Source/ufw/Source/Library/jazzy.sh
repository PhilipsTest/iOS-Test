#!/bin/sh

jazzy \
--clean true \
--skip-undocumented true \
--author Philips N.V. \
--author_url https://www.philips.com \
--module UAPPFramework \
--module-version 1.0.0 \
--readme ../../readme.markdown \
--output ../../Documents/External/AppleDocs/FlowManager \

