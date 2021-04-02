#!/usr/bin/env bash
QEMU_CPU="arm926"
QEMU_MACHINE="versatileab"

#Calling assemble.sh like this executes it in the same shell, allowing it to set OUTPUT and NAME
. assemble.sh $@

qemu-system-arm -s -S -machine "$QEMU_MACHINE" -cpu $QEMU_CPU -kernel "$OUTPUT/$NAME" -nographic &
QEMU_PID=$!

echo "QEMU runs with PID $QEMU_PID"
read -n 1 -s -r -p "Press any key to continue"

arm-none-eabi-gdb -silent -tui --symbols="$OUTPUT/$NAME" -iex "target remote :1234" -iex "layout regs" -ex "b stop"

kill -9 $QEMU_PID

