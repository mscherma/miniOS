[BITS 32]

%include "../include/bootdefs.inc"

ORG KERNEL_ENTRY_OFFSET

_entry:
	mov edx, 0xCAFEDEAD
	jmp $

times KERNEL_SIZE - ($ - $$) db 0
