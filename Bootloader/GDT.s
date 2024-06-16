g_GDT:
/* null descriptor */
        .quad 0x0000000000000000
/* 32 bits code segment

limit (bits 0-15) = 0xFFFFF for full 32-bit range,*/
        .word 0xFFFF
/*base (bits 0-15) = 0x0 */
        .word 0x0000
/*base (bits 16-23)*/
        .byte 0x00
/*access (present, ring 0, code segment, executable, direction 0, readable)*/
        .byte 0b10011010
/*granularity (4k pages, 32-bit pmode) + limit (bits 16-19)*/
        .byte 0b11001111
/*base high*/
        .byte 0x00
/* 32 bits data segment

limit (bits 0-15) = 0xFFFFF for full 32-bit range*/
        .word 0xFFFF
/*base (bits 0-15) = 0x0 */
        .word 0x0000
/*base (bits 16-23)*/
        .byte 0x00
/*access (present, ring 0, data segment, executable, direction 0, writable)*/
        .byte 0b10010010
/*granularity (4k pages, 32-bit pmode) + limit (bits 16-19)*/
        .byte 0b11001111
/*base high */
        .byte 0x00
g_GDTDesc:
/* GDT length minus 1 */
        .word g_GDTDesc - g_GDT - 1
/* GDT address */
        .long g_GDT + 0x7C00
