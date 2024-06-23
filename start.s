.intel_syntax noprefix
.code16
.global _start
_start:
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

boot_jump:
        push 0
        pop ds
        mov sp, 0x7C00
        cli
        call A20WaitInput
        mov al, 0xAD
        out 0x64, al
        call A20WaitInput
        mov al, 0xD0
        out 0x64, al
A20WaitOutput:
        in al, 0x64
        test al, 1
        jz A20WaitOutput
        in al, 0x60
        push ax
        call A20WaitInput
        mov al, 0xD1
        out 0x64, al
        call A20WaitInput
        pop ax
        or al, 2
        out 0x60, al
        call A20WaitInput
        mov al, 0xAE
        out 0x64, al
        call A20WaitInput
        lgdt [g_GDTDesc + 0x7C00]
        mov eax, cr0
        or al, 0x01
        mov cr0, eax
        jmpd 8:(protected_mode + 0x7C00)
A20WaitInput:
        in al, 0x64
        test al, 2
        jnz A20WaitInput
        ret
.code32
protected_mode:
        push 0x10
        push 0x10
        pop ds
        pop ss
        jmp 0x7E00
/* Input: bx = cell */
set_cursor_cell:
        push ax
        push bx
        push dx
        mov dx, 0x03D4
        mov al, 0x0F
        out dx, al
        inc dl
        mov al, bl
        out dx, al
        dec dl
        mov al, 0x0E
        out dx, al
        inc dl
        mov al, bh
        out dx, al
        pop dx
        pop bx
        pop ax
        ret
/* Input: ah = color, esi = source address, edi = destination address */
store_words:
        push esi
        push ax
        push edi
.print_char:
        lodsb
        stosw
        cmpb [esi], 0
        jne .print_char
        pop edi
        pop ax
        pop esi
        ret
g_GDT:
/* null descriptor */
        .quad 0x0000000000000000
/* 32 bits code segment

limit (bits 0-15) = 0xFFFFF for full 32-bit range,*/
        .word 0xFFFF
/*base (bits 0-15) = 0x0 */
        .word 0x0000
/*base (bits 16-23)*/
        .byte 0x00
/*access (present, ring 0, code segment, executable, direction 0, readable)*/
        .byte 0b10011010
/*granularity (4k pages, 32-bit pmode) + limit (bits 16-19)*/
        .byte 0b11001111
/*base high*/
        .byte 0x00
/* 32 bits data segment

limit (bits 0-15) = 0xFFFFF for full 32-bit range*/
        .word 0xFFFF
/*base (bits 0-15) = 0x0 */
        .word 0x0000
/*base (bits 16-23)*/
        .byte 0x00
/*access (present, ring 0, data segment, executable, direction 0, writable)*/
        .byte 0b10010010
/*granularity (4k pages, 32-bit pmode) + limit (bits 16-19)*/
        .byte 0b11001111
/*base high */
        .byte 0x00
g_GDTDesc:
/* GDT length minus 1 */
        .word g_GDTDesc - g_GDT - 1
/* GDT address */
        .long g_GDT + 0x7C00
.skip (510-(.-_start)), 0
.byte 0x55, 0xAA

