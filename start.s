BITS 16
_start:
	JMP 0:(.FlushCS + 0x7C00)
.FlushCS:
	XOR ax, ax
	MOV ss, ax
	MOV sp, 0x7C00
	MOV ds, ax
	MOV es, ax
	CLD
	MOV edi, 0x9000
	PUSH di
	MOV ecx, 0x1000
	XOR eax, eax
	CLD
	REP STOSD
	POP di
	LEA eax, [es:di + 0x1000]
	OR eax, (1 << 0) | (1 << 1)
	MOV [es:di], eax
	LEA eax, [es:di + 0x2000]
	OR eax, (1 << 0) | (1 << 1)
	MOV [es:di + 0x1000], eax
	LEA eax, [es:di + 0x3000]
	OR eax, (1 << 0) | (1 << 1)
	MOV [es:di + 0x2000], eax
	PUSH di
	LEA di, [di + 0x3000]
	MOV eax, (1 << 0) | (1 << 1)
.LoopPageTable:
	MOV [es:di], eax
	ADD eax, 0x1000
	ADD di, 8
	CMP eax, 0x200000
	JB .LoopPageTable
	POP di
	MOV al, 0xFF
	OUT 0xA1, al
	OUT 0x21, al
	NOP
	NOP
	LIDT [IDT + 0x7C00]
	MOV eax, 10100000b
	MOV cr4, eax
	MOV edx, edi
	MOV cr3, edx
	MOV ecx, 0xC0000080
	RDMSR
	OR eax, 0x00000100
	WRMSR
	MOV ebx, cr0
	OR ebx,0x80000001
	MOV cr0, ebx
	LGDT [GDT.Pointer + 0x7C00]
	JMP 8:(LongMode + 0x7C00)
bits 64
LongMode:
	MOV ax, 0x10
	MOV ds, ax
	MOV es, ax
	MOV ss, ax
	MOV BYTE [0xB8400], 'A'
	MOV BYTE [0xB8401], 7
	JMP $
IDT:
.Length:
	dw 0
.Base:
	dd 0
GDT:
.Null:
	dq 0x0000000000000000
.Code:
	dq 0x00209A0000000000
	dq 0x0000920000000000
ALIGN 4
	dw 0
.Pointer:
	dw $ - GDT - 1 + 0x7C00
	dd GDT + 0x7C00
; Input: bx = cell
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
; Input: ah = color, esi = source address, edi = destination address */
store_words:
        PUSH rsi
        PUSH ax
        PUSH rdi
.print_char:
        LODSB
        STOSW
        CMP BYTE [esi], 0
        JNE .print_char
        POP rdi
        POP ax
        POP rsi
        RET
	TIMES 510 - ($-$$) DB 0
	DW 0xAA55
