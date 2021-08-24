#!/bin/zsh

SIZE=$1
IMG=$2
OUT=$3 || "$IMG_out.gif"

[[ -z "$SIZE" ]] && die "usage: $0 <size> <source-img> [dest-img]"

if [ ! -f $IMG ]; then
    echo "Image $IMG does not exists"
    exit 1
fi

convert $IMG -coalesce -repage 0x0 -resize $SIZE -layers Optimize -colors 64 -loop 0 $OUT
