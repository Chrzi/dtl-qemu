#!/usr/bin/env bash
CPU="arm7tdmi-s"
ENTRY="_startup"
OUTPUT="$(dirname $0)/build"
MAP=0
#On ARMadillo RAM starts at 0x40000000, stack at this address
MAPSOURCE="0x40001000"
#On arm926ej-s (QEMU_CPU) onboard SDRAM is 64MB at 0x04000000-0x07FFFFFF
#https://developer.arm.com/documentation/dui0225/d/programmer-s-reference/memory-map?lang=en
MAPTARGET="0x04001000"

function usage {
	cat << EOF
Usage: assemble.sh [-hm] [-o OUTDIR] Aufgabe.S

-h: Shows this help
-m: Map memory from 0x40001000 to RAM address of the QEMU CPU
-o: Change the output directory

EOF
}

while getopts "hmo:" opt; do
	case "$opt" in
		h)
			usage
			exit 0
			;;
		m) 
			MAP=1
			;;
		o)
			if [ ! -d "$OPTARG" ]; then
					echo "Directory $OPTARG does not exist!" >&2
					exit 2
			fi 
			OUTPUT=${OPTARG%/}
			;;
		'?')
			usage >&2
			exit 1
			;;
	esac
done
shift "$((OPTIND-1))"

NAME="$(basename $1 .S)"
export OUTPUT
export NAME 

if [ ! -f "$1" ]; then
        echo "File $1 not found"
        exit 1
fi

if [ ! -d "$OUTPUT" ]; then
	mkdir -p "$OUTPUT"
fi

if [ $MAP -ne 0 ]; then
	sed "s/$MAPSOURCE/$MAPTARGET/" $1 > "$OUTPUT/$NAME.S"
	arm-none-eabi-as -ggdb -mcpu="$CPU" -o "$OUTPUT/$NAME.o" "$OUTPUT/$NAME.S"
else
	arm-none-eabi-as $1 -ggdb -mcpu="$CPU" -o "$OUTPUT/$NAME.o"
fi
arm-none-eabi-ld "$OUTPUT/$NAME.o" -entry="$ENTRY" -o "$OUTPUT/$NAME"

