#!/bin/bash

echo "Booting..."
qemu-system-x86_64 -accel kvm -m 1024 -smp 1 -M q35 -drive format=raw,file=bootable_drive.bin
