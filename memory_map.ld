MEMORY {
	BIOS (rx) : ORIGIN = 0xFFFFF, LENGTH = 0xFFFF
	OS (rx) : ORIGIN = 0x7C000, LENGTH = 0x200
	stack (rwx) : ORIGIN = 0, LENGTH = 0x7C00
	user_space (rwx) : ORIGIN = 0x7E000, LENGTH = 0x81FF
}
SECTIONS {
	.text : { *(.text) }
}
