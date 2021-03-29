#!/usr/bin/env bash
NAME="$(basename $1 .S)"
CPU="arm7tdmi-s"
ENTRY="_startup"
OUTPUT="$(dirname "$0")/build"

if [ ! -f "$1" ]; then
        echo "File $1 not found"
        exit 1
fi

if [ ! -d "$OUTPUT" ]; then
	mkdir -p "$OUTPUT"
fi

arm-none-eabi-as $1 -g -mcpu="$CPU" -o "$OUTPUT/$NAME.o"
arm-none-eabi-ld "$OUTPUT/$NAME.o" -entry="$ENTRY" -o "$OUTPUT/$NAME"

