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
