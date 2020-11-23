#!/bin/sh

echo Running script: `basename "$0"`

if ( test -z "${COPYRIGHT_REGEX}" ); then
	echo "not configured; skipping."
	exit 0
fi

violatingFiles=$(find . -name "*.[hm]" -print0 | xargs -0 egrep -L "${COPYRIGHT_REGEX}" | egrep -v "${COPYRIGHT_FILE_IGNORE_PATTERN}" ) 

declare -i count=0
for f in ${violatingFiles}; do
	count=$(($count+1))
done

echo "Found $count files that have incorrect copyright information"
for f in ${violatingFiles}; do
	echo "    "${f}
done

exit $count
