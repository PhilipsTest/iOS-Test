fatal() {
	echo "[fatal] $1"
	exit 1
}

absPath() {
	echo `cd \"$1\"; pwd`
}



require_variable() {
    REQ_VAR_NAME=$1
    if [ ! -n "${!REQ_VAR_NAME}" ]; then
        usage
        echo ""
        fatal "Error: variable named '$REQ_VAR_NAME' not defined"
    fi
}

test_preconditions() {
	read_config_script

	require_variable APP_NAME
	require_variable CONFIG
}

read_config_script() {

    if [ -z "$CONFIG_FILE" ]; then
        CONFIG_FILE="config.sh"
    fi

	scriptDir="`dirname \"$0\"`"
	if [ -f "$scriptDir/../$CONFIG_FILE" ]; then
		source "$scriptDir/../$CONFIG_FILE"
	else
		fatal "missing $CONFIG_FILE in parent folder: $scriptDir/../"
	fi
}

usage() {

    # show current variables
    set
    echo "APP_NAME = $APP_NAME"
    echo "CONFIG   = $CONFIG"
    echo "TARGET   = $TARGET"
    echo "VERSION_NUMBER = $VERSION_NUMBER"
    echo "FTP_USER = $FTP_USER"
    echo "FTP_PASS = $FTP_PASS"
    echo ""

    # show required variables
	echo "required variables:"
	echo "	APP_NAME (example: SmartApp)"
	echo "	CONFIG   (example: Debug|Distribution)"
	echo ""
	
	echo "optional variables:"
	echo "	TARGET   (example: SmartApp-lite)"
	echo "	SKIP_UNIT_TESTS"
	echo ""
	
	echo "required for distribution:"
	echo "  VERSION_NUMBER (if not set in project)"
	echo "  FTP_USER"
	echo "  FTP_PASS"

}

export -f fatal
export -f usage
export -f absPath
export -f require_variable
export -f test_preconditions
