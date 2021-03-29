#!/usr/bin/env bash
CPU="arm7tdmi-s"
QEMU_CPU="arm926"
ENTRY="_startup"
NAME="$(basename $1 .S)"

if [ ! -f "$NAME.S" ]; then
	echo "File $NAME.S not found"
	exit 1
fi

# Assemble
arm-none-eabi-as $NAME.S -g -mcpu="$CPU" -o $NAME.o
arm-none-eabi-ld $NAME.o -entry="$ENTRY" -o $NAME
# Run in qemu
qemu-arm-static -g 1234 -singlestep -cpu $QEMU_CPU $NAME  &

QEMU_PID=$!
echo "QEMU runs with PID $QEMU_PID"
read -n 1 -s -r -p "Press any key to continue"

# Start gdb (debugger) and attach to qemu and set breakpoint on stop label
arm-none-eabi-gdb -tui --symbols=$NAME -iex "target remote :1234" -iex "layout regs" -ex "b stop"

kill -9 $QEMU_PID

