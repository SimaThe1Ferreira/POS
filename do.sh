#!/bin/bash

msg_error() {
	echo "Invalid command!"
}
run() {
	echo "Running..."
	qemu-system-i386 -m 1024 \
	-cpu qemu32 \
	-drive if=none,id=usbstick,format=raw,file=bootable_drive.bin \
	-usb \
	-device nec-usb-xhci,id=xhci \
	-device usb-storage,bus=xhci.0,drive=usbstick
}
build() {
	echo "Assembling..."
	as -o boot_chunk.o boot_chunk.s
	echo "Linking..."
	ld -T memory_map.ld --oformat "binary" -o OS.bin boot_chunk.o
	echo "Creating drive image..."
	dd if=/dev/zero of=bootable_drive.bin bs=512 count=2880
	echo "Inserting bootloader..."
	dd if=OS.bin of=bootable_drive.bin seek=0 conv=notrunc
	echo "Clearing cache..."
	rm boot_chunk.o OS.bin
}
if [ "$#" -gt 1 ]
then
	msg_error
	exit 1
fi
if [ "$#" -eq 0 ]
then
	build
	run
	exit 1
fi
case "$1" in
	"build")
		build
	;;
	"run")
		run
	;;
	"install")
		sudo apt update
		sudo apt install qemu-system-x86 hexedit binutils gcc bochs bochsbios vgabios bochs-x
	;;
	*)
		msg_error
	;;
esac

