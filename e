#! /usr/bin/env mksh

set -A files -- "$@"

while [ $# -gt 0 ] ; do
	fdb -i "$XDG_DATA_HOME"/edit.z -a "$(realpath "$1" 2> /dev/null)"
	shift
done

exec $EDITOR "${files[@]}"
