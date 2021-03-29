#!/usr/bin/env bash
NAME="$(basename $1 .S)"
CPU="arm7tdmi-s"
ENTRY="_startup"

if [ ! -f "$NAME.S" ]; then
        echo "File $NAME.S not found"
        exit 1
fi

arm-none-eabi-as $NAME.S -g -mcpu="$CPU" -o $NAME.o
arm-none-eabi-ld $NAME.o -entry="$ENTRY" -o $NAME

