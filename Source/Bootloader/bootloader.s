.intel_syntax noprefix
.code16
.global main
.include "header.s"
.include "start.s"
.include "16_bit_A20_gate_wait_input.s"
.include "protected_mode.s"
.include "read_from_ata.s"
.include "set_cursor_cell.s"
.include "store_words.s"
.include "GDT.s"
.include "footer.s"
