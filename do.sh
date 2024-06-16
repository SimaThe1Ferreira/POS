#!/bin/bash

msg_error() {
	echo "Invalid command!"
}
debug_kernel() {
	echo "Debugging kernel..."
	qemu-system-i386 -kernel Build/kernel.elf32 -s -S
}
run() {
	echo "Booting..."
	qemu-system-i386 -accel kvm -m 1024 -smp 1 -M q35 -drive format=raw,file=Build/bootable_drive.bin
}
assemble_bootloader() {
	echo "Assembling bootloader..."
        as Bootloader/main.s -I/home/amnesia/Persistent/Desktop/POS/Bootloader -o Build/bootloader.o
}
assemble_kernel() {
	echo "Assembling kernel..."
	as Kernel/main.s -o Build/kernel.o -g --32
}
link_kernel() {
	echo "Linking kernel..."
        ld Build/kernel.o -melf_i386 -T memory_map.ld -e main -o Build/kernel.elf32 --oformat "elf32-i386"
}
link_bootloader() {
	echo "Linking bootloader..."
	ld Build/bootloader.o -T memory_map.ld -e main -o Build/bootloader.bin --oformat "binary"
}
convert_kernel() {
	echo "Converting kernel..."
	objcopy Build/kernel.elf32 -O binary Build/kernel.bin
}
creat_drive_image() {
	echo "Creating drive image..."
        dd if=/dev/zero of=Build/bootable_drive.bin bs=512 count=2880 status=none
}
insert_bootloader() {
	echo "Inserting bootloader..."
        dd if=Build/bootloader.bin of=Build/bootable_drive.bin seek=0 conv=notrunc status=none
}
insert_kernel() {
	echo "Inserting kernel..."
	dd if=Build/kernel.bin of=Build/bootable_drive.bin seek=1 conv=notrunc status=none
}
if [ "$#" -gt 1 ]
then
	msg_error
	exit 1
fi
if [ "$#" -eq 0 ]
then
	assemble_kernel
	link_kernel
	debug_kernel
	exit 1
fi
case "$1" in
	"build")
		assemble_bootloader
        	assemble_kernel
        	link_bootloader
        	link_kernel
        	convert_kernel
        	creat_drive_image
        	insert_bootloader
        	insert_kernel
	;;
	"run")
		run
	;;
	"debug")
		debug_kernel
	;;
	*)
		msg_error
	;;
esac
