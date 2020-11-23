#!/bin/sh

jazzy \
--clean true \
--author Philips N.V. \
--author_url https://www.philips.com \
--module InAppPurchase \
--module-version 7.0.0 \
--readme ../../../README.md \
--framework-root . \
--output ../../../Documents/External/AppleDoc
