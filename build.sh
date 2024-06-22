#!/bin/bash

echo "Assembling..."
nasm Source/start.s -f bin -o Build/start.bin
nasm Source/main.s -f bin -o Build/main.bin
echo "Creating drive image..."
dd if=/dev/zero of=Build/bootable_drive.bin bs=512 count=2880 status=none
echo "Inserting..."
dd if=Build/start.bin of=Build/bootable_drive.bin seek=0 conv=notrunc status=none
dd if=Build/main.bin of=Build/bootable_drive.bin seek=1 conv=notrunc status=none
