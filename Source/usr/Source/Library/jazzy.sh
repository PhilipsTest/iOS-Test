#!/bin/sh

jazzy \
--objc \
--clean true \
--author Philips N.V. \
--author_url https://www.philips.com \
--module PhilipsRegistration \
--module-version 11.0.0 \
--readme ../../README.md \
--umbrella-header PhilipsRegistration/PR\ Doc.h \
--framework-root . \
--output ../../Documents/External/AppleDocs
