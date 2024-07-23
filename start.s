.intel_syntax noprefix
.code16
.global _start
_start:
        JMP .
.code64
LongMode:
	
	JMP .
/* Input: bx = cell */
set_cursor_cell:
        PUSH ax
        PUSH bx
	PUSH dx
        MOV dx, 0x03D4
        MOV al, 0x0F
        OUT dx, al
        INC dl
        MOV al, bl
        OUT dx, al
        DEC dl
        MOV al, 0x0E
        OUT dx, al
        INC dl
        MOV al, bh
        OUT dx, al
        POP dx
        POP bx
        POP ax
        RET
/* Input: ah = color, esi = source address, edi = destination address */
store_words:
        PUSH rsi
        PUSH ax
        PUSH rdi
.print_char:
        LODSB
        STOSW
        CMPB [esi], 0
        JNE .print_char
        POP rdi
        POP ax
        POP rsi
	RET

	.skip (510-(.-_start)), 0
	.byte 0x55, 0xAA
