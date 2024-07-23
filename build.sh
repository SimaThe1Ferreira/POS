#!/bin/bash

echo "Assembling bootloader..."
as start.s -o start.o
echo "Assembling kernel..."
as main.s -o main.o
echo "Linking bootloader..."
ld start.o -T memory_map.ld -o start.bin --oformat "binary"
echo "Linking kernel..."
ld main.o -T memory_map.ld -o main.bin --oformat "binary"
echo "Creating drive image..."
dd if=/dev/zero of=bootable_drive.bin bs=512 count=2880 status=none
echo "Inserting bootloader..."
dd if=start.bin of=bootable_drive.bin seek=0 conv=notrunc status=none
echo "Inserting kernel..."
dd if=main.bin of=bootable_drive.bin seek=1 conv=notrunc status=none
echo "Clearing..."
rm main.o main.bin start.o start.bin
