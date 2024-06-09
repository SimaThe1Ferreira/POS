#!/bin/bash

msg_error() {
	echo "Invalid command!"
}
run() {
	qemu-system-i386 -m 1024 -cpu qemu32 -bios BIOS -drive if=none,id=usbstick,format=raw,file=bootable_drive.bin -usb -device usb-ehci,id=ehci -device usb-storage,bus=ehci.0,drive=usbstick -device usb-kbd
}
build() {
	as -o boot_chunk.o boot_chunk.s
	ld -T memory_map.ld --oformat "binary" -o OS.bin boot_chunk.o
	dd if=/dev/zero of=bootable_drive.bin bs=512 count=2880
	dd if=OS.bin of=bootable_drive.bin seek=0 conv=notrunc
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
    "debug")
        bochs -f options.bochs
        ;;
    "install")
        apt update && apt install qemu-system-x86 hexedit binutils gcc bochs bochsbios vgabios bochs-x
        ;;
    *)
        msg_error
        ;;
esac

