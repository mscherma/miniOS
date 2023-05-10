
[BITS 16]

ORG 0x0

_mainboot:
	cli
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, _stack_top
	sti

	lea si, _str_2nd_stage
_loop:
	mov al, [si]
	test al, al
	jz _end
	mov ah, 0xE
	mov bl, 0x7
	int 0x10
	inc si
	jmp _loop
_end:
	jmp $


_str_2nd_stage:
db 'Hello, 2nd stage!', 0xD, 0xA, 0x0

times 16384 - ($ - $$) db 0
_stack_top:
