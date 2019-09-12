#! /bin/sh

ext='jpg'
area=360000
quality=95
filter='Lanczos'
destdir=''

while getopts 'a:e:q:f:d:' opt ; do
    case $opt in
        a)
            area=$OPTARG
            ;;
        e)
            ext=$OPTARG
            ;;
        q)
            quality=$OPTARG
            ;;
        f)
            filter=$OPTARG
            ;;
        d)
            destdir=$OPTARG
            ;;
    esac
done

shift $(($OPTIND - 1))

if [ $# -lt 1 ] ; then
    printf "usage: %s [-a AREA|-e EXT|-q QUALITY|-f FILTER|-d DESTDIR] FILE ...\n" "${0##*/}"
    exit 1
fi

while [ $# -gt 0 ] ; do
    imagepath=$1
    imagedir=$(dirname "$imagepath")
    imagebase=$(basename "$imagepath")
    imagebase=${imagebase%.*}
    previewdir=${destdir:-"$imagedir/previews"}
    mkdir -p "$previewdir"
    previewpath="$previewdir/pv_$imagebase.$ext"
    printf "%s\n" "$previewpath"
    convert -filter "$filter" -resize ${area}@\> -quality $quality -interlace Line -auto-orient "$imagepath" "$previewpath"
    shift
done
