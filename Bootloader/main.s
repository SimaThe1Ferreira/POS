.intel_syntax noprefix
.code16
.global main
.include "header.s"
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
.include "A20_gate_wait_input.s"
.code32
protected_mode:
	push 0x10
	push 0x10
	pop ds
	pop ss
	jmp 0x7E00
.include "read_from_ata.s"
.include "set_cursor_cell.s"
.include "store_words.s"
.include "GDT.s"
.include "footer.s"
