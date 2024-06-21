A20WaitInput:
        in al, 0x64
        test al, 2
        jnz A20WaitInput
        ret
