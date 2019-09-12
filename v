#! /bin/sh

V_VIM=${V_VIM:-${EDITOR:-nvim}}
DB_PATH="$XDG_DATA_HOME"/edit.z

pick_latest=1
choose_index=0
list_files=0
index=1
sort_by=frecency

while getopts 'hlacpi:s:' opt ; do
	case $opt in
		h)
			printf "%s [-hlacp] [-i INDEX] [-s SORT_BY] [REGEX]\n" "${0##*/}"
			exit
			;;
		p)
			zp -i "$DB_PATH"
			exit
			;;
		l)
			list_files=1
			;;
		a)
			pick_latest=0
			;;
		c)
			choose_index=1
			;;
		i)
			index=$OPTARG
			;;
		s)
			sort_by=$OPTARG
			;;
	esac
done

shift $((OPTIND - 1))
tmpout=$(mktemp /tmp/v.XXXX)

num=$(fdb -i "$DB_PATH" -s "$sort_by" -q "(?i)$@" | tee "$tmpout" | wc -l)

if [ $list_files -eq 1 ] ; then
	sed "s!^~!$HOME!" "$tmpout" | tail -r
elif [ $num -eq 0 ] ; then
	if [ $# -gt 0 ] ; then
		printf "%s\n" "No matches." >&2
	fi
elif [ $pick_latest -eq 0 -o $num -eq 1 ] ; then
	sed "s!^~!$HOME!" "$tmpout" | tr '\n' '\0' | xargs -0 dash -c $V_VIM' "$@" < /dev/tty' $V_VIM
else
	if [ $choose_index -eq 1 ] ; then
		nl -s ': ' -w 3 "$tmpout" | tail -r
		printf "%s" "? "
		read index
	fi
	[ -n "$index" ] && head -n $index "$tmpout" | tail -n 1 | sed "s!^~!$HOME!" | tr '\n' '\0' | xargs -0 dash -c $V_VIM' "$@" < /dev/tty' $V_VIM
fi

rm "$tmpout"
