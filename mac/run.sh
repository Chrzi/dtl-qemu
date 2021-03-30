#!/usr/bin/env bash
CPU="arm7tdmi-s"
QEMU_CPU="arm926"
QEMU_MACHINE="realview-eb"
ENTRY="_startup"
NAME="$(basename $1 .S)"
OUTPUT="$(dirname "$0")/build"

./assemble.sh $1

qemu-system-arm -s -S -machine $QEMU_MACHINE -cpu $QEMU_CPU -kernel "$OUTPUT/$NAME" -nographic &
QEMU_PID=$!

echo "QEMU runs with PID $QEMU_PID"
read -n 1 -s -r -p "Press any key to continue"

arm-none-eabi-gdb -tui --symbols="$OUTPUT/$NAME" -iex "target remote :1234" -iex "layout regs" -ex "b stop"

kill -9 $QEMU_PID

