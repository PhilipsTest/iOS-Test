#!/bin/sh


export scriptDir="`dirname \"$0\"`"
export absScriptDir="`cd \"$scriptDir\"; pwd`"


if [ -n "$1" ] ; then
    export CONFIG="$1"
    echo "CONFIG=$CONFIG"
fi


source "$absScriptDir/utils.sh"

main() {
	source "$absScriptDir/environment_setup.sh"

	files=`ls $absScriptDir/[0-9]*.sh $absScriptDir/../[0-9]*.sh 2>/dev/null | xargs basename | sort -n | uniq`
	for i in $files; do
		script=""
		if (test -f $absScriptDir/../$i); then
			script=$absScriptDir/../$i
		elif (test -f $absScriptDir/$i); then
			script=$absScriptDir/$i
		fi
		
		if (test "$script" != ""); then
			echo ""
			echo "==========================================================================================="
			echo "==== $script"
			echo "==========================================================================================="
			sh "$script" || fatal "Build script $script failed"
		fi
	done
}

SAVE_IFS=$IFS
IFS=$'\n\t'

test_preconditions

main $*

IFS=$SAVE_IFS
