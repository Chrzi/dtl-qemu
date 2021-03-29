#!/usr/bin/env bash
CPU="arm7tdmi-s"
QEMU_CPU="arm926"
ENTRY="_startup"
NAME="$(basename $1 .S)"
OUTPUT="build"

# Assemble
./assemble.sh $1

# Run in qemu
qemu-arm-static -g 1234 -singlestep -cpu $QEMU_CPU "$OUTPUT/$NAME"  &

QEMU_PID=$!
echo "QEMU runs with PID $QEMU_PID"
read -n 1 -s -r -p "Press any key to continue"

# Start gdb (debugger) and attach to qemu and set breakpoint on stop label
arm-none-eabi-gdb -tui --symbols="$OUTPUT/$NAME" -iex "target remote :1234" -iex "layout regs" -ex "b stop"

kill -9 $QEMU_PID

