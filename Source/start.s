bits 16
start:
        jmp short boot_jump
        nop
; BIOS parameter chunk
oem:
        db "MSWIN4.1"
bytes_per_sector:
        dw 0x0200
sectors_per_cluster:
        db 0x01
reserved_sectors:
        dw 0x0001
fat_count:
        db 0x02
dir_entries_count:
        dw 0x00E0
total_sectors:
        dw 0x0B40
media_descriptor_type:
        db 0xF0
sectors_per_fat:
        dw 0x0009
sectors_per_track:
        dw 0x00F3
heads:
        dw 0x0002
hidden_sectors:
        dd 0x00000000
large_sector_count:
        dd 0x00000000
; Extended boot record
drive_number:
        db 0x80, 0x00
signature:
        db 0x29
volume_id:
        db 0x12, 0x34, 0x56, 0x78
volume_label:
        db "NANOBYTE OS"
system_id:
        db "FAT12   "
boot_jump:
        push 0
%define DATA_SEGMENT ds
        pop DATA_SEGMENT
        cli
        call A20WaitInput
%define SOURCE al
        mov SOURCE, 0xAD
        out 0x64, SOURCE
        call A20WaitInput
        mov SOURCE, 0xD0
        out 0x64, SOURCE
A20WaitOutput:
        in SOURCE, 0x64
        test SOURCE, 1
        jz A20WaitOutput
        in SOURCE, 0x60
        push ax
        call A20WaitInput
        mov SOURCE, 0xD1
        out 0x64, SOURCE
        call A20WaitInput
        pop ax
        or al, 2
        out 0x60, SOURCE
        call A20WaitInput
        mov SOURCE, 0xAE
        out 0x64, SOURCE
        call A20WaitInput
        lgdt [g_GDTDesc + 0x7C00]
        mov eax, cr0
        or al, 0x01
        mov cr0, eax
        jmp 8:(protected_mode + 0x7C00)
A20WaitInput:
        in SOURCE, 0x64
	test SOURCE, 2
        jnz A20WaitInput
        ret
bits 32
protected_mode:
        push 0x10
        push 0x10
%define STACK_TOP sp
        mov STACK_TOP, 0x7C00
        pop DATA_SEGMENT
%define STACK_SEGMENT ss
	pop STACK_SEGMENT
        jmp 0x7E00
; Input: bx = cell
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
; Input: ah = color, esi = source address, edi = destination address
store_words:
        push esi
        push ax
        push edi
.print_char:
        lodsb
        stosw
        cmp byte [esi], 0
        jne .print_char
        pop edi
        pop ax
        pop esi
        ret
g_GDT:
; null descriptor
        dq 0x0000000000000000
; 32 bits code segment

; limit (bits 0-15) = 0xFFFFF for full 32-bit range
        dw 0xFFFF
; base (bits 0-15) = 0x0
        dw 0x0000
; base (bits 16-23)
        db 0x00
;access (present, ring 0, code segment, executable, direction 0, readable)
        db 0b10011010
;granularity (4k pages, 32-bit pmode) + limit (bits 16-19)
        db 0b11001111
;base high
        db 0x00
; 32 bits data segment

; limit (bits 0-15) = 0xFFFFF for full 32-bit range
        dw 0xFFFF
; base (bits 0-15) = 0x0
        dw 0x0000
; base (bits 16-23)
        db 0x00
; access (present, ring 0, data segment, executable, direction 0, writable)
        db 0b10010010
; granularity (4k pages, 32-bit pmode) + limit (bits 16-19)
        db 0b11001111
; base high
        db 0x00
g_GDTDesc:
; GDT length minus 1
        dw g_GDTDesc - g_GDT - 1
; GDT address
        dd g_GDT + 0x7C00
	times 510-($-$$) db 0
	db 0x55, 0xAA
