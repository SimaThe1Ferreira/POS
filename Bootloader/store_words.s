.intel_syntax noprefix
.code32
.global store_words
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
