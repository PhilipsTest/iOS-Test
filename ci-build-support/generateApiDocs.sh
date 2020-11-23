#!/bin/bash

# This file is used to generate Apple Docs for swift and objective-c files using jazzy.

set -e

AUTHOR="Philips N.V."
AUTHOR_URL="http://devportal.spssvr1.htce.nl.philips.com"
FLAVOR="Debug"
SDK="iphonesimulator"
THEME='apple'
DOCS_OUTPUT_ROOT='API_DOCS'
OBJECTIVEC_DOC_DIR="Obj-C"
SWIFT_DOC_DIR="Swift"
PODS_PROJECT="Pods/Pods.xcodeproj"

# Check for xcode setting with the 'MODULE_NAME' and 'PODS_PROJECT'
getXCodeSetting() {
	MODULE_NAME=$1
	SETTING_NAME=$2
	SETTING_REGEX="$SETTING_NAME = (.*)"

	xcodebuild -showBuildSettings -project "${PODS_PROJECT}" -scheme ${MODULE_NAME} -configuration ${FLAVOR} -sdk ${SDK} | \
		egrep -o "$SETTING_REGEX" | \
		sed -En "s/$SETTING_REGEX/\1/p" | \
		while read -r line ; do
			if [ ! -z "$line" ] 
			then
				echo $line
			fi
		done
}

# Generationg Swift doc with jazzy while checking flag 'OTHER_SWIFT_FLAGS' from the Xcode Settings to check for the Swift project
generateSwiftDocs() {
	MODULE_NAME=$1
	DOC_FOLDER=$2
	path="$3/README.md"

	echo "-----------------------------------------------------------"
	echo "Generating Swift API docs for [${MODULE_NAME}]..."
	echo "-----------------------------------------------------------"

	export PATH=$PATH:/usr/local/bin

	# Need to check whether it's a swift library one way or another...
	OTHER_SWIFT_FLAGS=`getXCodeSetting $MODULE_NAME OTHER_SWIFT_FLAGS`

	if [ -z "$OTHER_SWIFT_FLAGS" ]
	then
		echo "Does not seem to be a Swift project, skipping Swift API doc generation..."
	else
		jazzy \
			--author "$AUTHOR" \
			--author_url "$AUTHOR_URL" \
			--theme "$THEME" \
			--module $MODULE_NAME \
			--readme "$path" \
			--xcodebuild-arguments -project,"${PODS_PROJECT}",-scheme,${MODULE_NAME},-sdk,${SDK} \
			--output "${DOC_FOLDER}/${SWIFT_DOC_DIR}"
	fi
}

# Used for generating Header
extractFirstImportedHeader() {
	UMBRELLA_HEADER_PATH=$1

	FIRST_IMPORT_REGEX="#import \"([^\"]*)\""
	egrep -o "$FIRST_IMPORT_REGEX" "$UMBRELLA_HEADER_PATH" | \
		sed -En "s/$FIRST_IMPORT_REGEX/\1/p" | head -1
}

# Used for generating Header
getRootFolderForUmbrellaHeader() {
	UMBRELLA_HEADER_PATH=$1
	FIRST_IMPORTED_HEADER=`extractFirstImportedHeader "$UMBRELLA_HEADER_PATH"`
	HEADER_PATH=`find . \( -path "./DerivedData" -o -path "**/Pods/**" -o -path "./build" -o -path "**Binary/**" \) -prune -o -name "$FIRST_IMPORTED_HEADER" -print | head -1`
	ROOT_FOLDER=`echo $HEADER_PATH| cut -d "/" -f2`

	if [ ! -d "$ROOT_FOLDER" ]
	then
		echo ""
		return 0
	fi
	
	#Unfortunately this root folder is not enough for the jazzy version that's installed on the build slave, so trying to go deeper...
	SOURCE_FOLDER="${ROOT_FOLDER}/Source"
	if [ -d "$SOURCE_FOLDER" ]
	then
		echo "$SOURCE_FOLDER"
		return 0
	fi

	FIRST_SUBFOLDER=`echo $HEADER_PATH| cut -d "/" -f3`
	echo "${ROOT_FOLDER}/${FIRST_SUBFOLDER}"
}

# Generating ObjC doc with jazzy while checking flag 'FRAMEWORK_ROOT' from the root folder of Umbrella header
generateObjCDocs() {
	MODULE_NAME=$1
	DOC_FOLDER=$2
	path="$3/README.md"

	echo "-----------------------------------------------------------"
	echo "Generating Objective-C API docs for [${MODULE_NAME}]..."
	echo "-----------------------------------------------------------"

	UMBRELLA_HEADER_PATH="Pods/Target Support Files/${MODULE_NAME}/${MODULE_NAME}-umbrella.h"
	FRAMEWORK_ROOT=`getRootFolderForUmbrellaHeader "$UMBRELLA_HEADER_PATH"`

	if [[ -d "$FRAMEWORK_ROOT" ]]
	then
		echo "using framework-root [$FRAMEWORK_ROOT]"
		jazzy \
			--objc \
			--sdk "$SDK" \
			--author "$AUTHOR" \
			--author_url "$AUTHOR_URL" \
			--theme "$THEME" \
			--framework-root "$FRAMEWORK_ROOT" \
			--module $MODULE_NAME \
			--umbrella-header "$UMBRELLA_HEADER_PATH" \
			--readme  "$path" \
			--output "${DOC_FOLDER}/${OBJECTIVEC_DOC_DIR}"
	else
		echo "Could not find an objective-c header skipping Objective-C API doc generation..."
	fi
}

# Defining output path and generating Swift and ObjC Doc with the functions 'generateSwiftDocs' and 'generateObjCDocs'
generateDocs() {
	MODULE_NAME=$1
	DOC_FOLDER="../${DOCS_OUTPUT_ROOT}/${MODULE_NAME}"
	TLA=$2

	echo "###########################################################"
	generateSwiftDocs $MODULE_NAME $DOC_FOLDER $TLA
	generateObjCDocs $MODULE_NAME $DOC_FOLDER $TLA
}

# Using custom made html content for the front look of the API Documentation
createIndexHtml() {
	cd $DOCS_OUTPUT_ROOT
	HTML_CONTENT="<html><body><h1>API Documentation</h1><table>"

	for moduleFolder in `ls -d */`
	do
		HTML_CONTENT="${HTML_CONTENT}<tr><td>${moduleFolder}</td>"
		
		if [ -d "${moduleFolder}/${OBJECTIVEC_DOC_DIR}" ]
		then
			HTML_CONTENT="${HTML_CONTENT}<td><a href=\"${moduleFolder}/${OBJECTIVEC_DOC_DIR}/index.html\">Objective-C</a></td>"
		fi

		if [ -d "${moduleFolder}/${SWIFT_DOC_DIR}" ]
		then
			HTML_CONTENT="${HTML_CONTENT}<td><a href=\"${moduleFolder}/${SWIFT_DOC_DIR}/index.html\">Swift</a></td>"
		fi

		HTML_CONTENT="${HTML_CONTENT}</tr>"
	done

	HTML_CONTENT="${HTML_CONTENT}</table></body></html>"
	echo $HTML_CONTENT > index.html
}

# Components defination for which the documents to be generated
main() {
	rm -rf "${DOCS_OUTPUT_ROOT}"

	cd Source
	generateDocs AppInfra ail
	generateDocs InAppPurchase iap
	generateDocs PhilipsConsumerCare
	generateDocs PhilipsPRXClient prx
	generateDocs PhilipsProductRegistration prg
	generateDocs PhilipsProductSelection
	generateDocs PhilipsRegistration usr
	generateDocs PlatformInterfaces	pif
	generateDocs UAPPFramework ufw
	generateDocs PhilipsEcommerceSDK ecs
	generateDocs MobileEcommerce mec
	cd -

	createIndexHtml
}

main $*
