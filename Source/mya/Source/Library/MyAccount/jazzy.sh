#!/bin/sh

jazzy \
--clean true \
--skip-undocumented true \
--author Philips N.V. \
--author_url https://www.philips.com \
--module MyAccount \
--module-version 1.0.0 \
--readme ../../../README.md \
--output ../../../Documents/External/AppleDocs \

