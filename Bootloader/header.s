main:
        jmp short boot_jump
        nop
/* BIOS parameter chunk */
oem:
        .asciz "MSWIN4.1"
bytes_per_sector:
        .word 0x0200
sectors_per_cluster:
        .byte 0x01
reserved_sectors:
        .word 0x0001
fat_count:
        .byte 0x02
dir_entries_count:
        .word 0x00E0
total_sectors:
        .word 0x0B40
media_descriptor_type:
        .byte 0xF0
sectors_per_fat:
        .word 0x0009
sectors_per_track:
        .word 0x00F3
heads:
        .word 0x0002
hidden_sectors:
        .long 0x00000000
large_sector_count:
        .long 0x00000000
/* Extended boot record */
drive_number:
        .byte 0x80, 0x00
signature:
        .byte 0x29
volume_id:
        .byte 0x12, 0x34, 0x56, 0x78
volume_label:
        .asciz "NANOBYTE OS"
system_id:
        .asciz "FAT12   "
