.code32
protected_mode:
        push 0x10
        push 0x10
        pop ds
        pop ss
        jmp 0x7E00
