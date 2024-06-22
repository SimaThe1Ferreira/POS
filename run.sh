echo "Booting..."
qemu-system-i386 -accel kvm -m 1024 -smp 1 -M q35 -drive format=raw,file=Build/bootable_drive.bin
