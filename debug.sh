#!/bin/bash

echo "Assembling bootloader..."
nasm start.s -f bin -o start.bin
echo "Assembling kernel..."
nasm main.s -f bin -o main.bin
echo "Creating drive image..."
dd if=/dev/zero of=bootable_drive.bin bs=512 count=2880 status=none
echo "Inserting bootloader..."
dd if=start.bin of=bootable_drive.bin seek=0 conv=notrunc status=none
echo "Inserting kernel..."
dd if=main.bin of=bootable_drive.bin seek=1 conv=notrunc status=none
echo "Clearing..."
rm main.bin start.bin
echo "Booting..."
bochs -f bochs_config
