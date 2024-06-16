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
