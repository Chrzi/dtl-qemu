#!/usr/bin/env bash
CPU="arm7tdmi-s"
QEMU_CPU="arm926"
ENTRY="_startup"
NAME="$(basename $1 .S)"

if [ ! -f "$NAME.S" ]; then
	echo "File $NAME.S not found"
	exit 1
fi

arm-none-eabi-as $NAME.S -g -mcpu="$CPU" -o $NAME.o
arm-none-eabi-ld $NAME.o -entry="$ENTRY" -o $NAME
qemu-system-arm -s -S -machine virt -kernel $NAME -nographic &
QEMU_PID=$!

echo "QEMU runs with PID $QEMU_PID"
read -n 1 -s -r -p "Press any key to continue"

arm-none-eabi-gdb -tui --symbols=$NAME -iex "target remote :1234" -iex "layout regs" -ex "b stop"

kill -9 $QEMU_PID

