.intel_syntax noprefix
.code16
.global A20WaitInput
A20WaitInput:
        in al, 0x64
        test al, 2
        jnz A20WaitInput
        ret
