
[BITS 16]

ORG 0x0

%include "../include/bootdefs.inc"

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
	jz _end_loop
	mov ah, 0xE
	mov bl, 0x7
	int 0x10
	inc si
	jmp _loop
_end_loop:

	cli
	xor ebx, ebx
	mov bx, cs
	shl ebx, 4

	add [gdtr_area + 2], ebx
	mov [_k_code + 2], bx

	shr ebx, 16
	mov [_k_code + 4], bl
	mov [_k_code + 7], bh

	lgdt [gdtr_area]

	mov eax, cr0
	or al, 1
	mov cr0, eax

	jmp KCODE_SEG:_ProtectedMode

[BITS 32]
_ProtectedMode:
	mov ax, KDATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	; call _disable_A20_gate
	jmp $

_disable_A20_gate:
	in al, 0x92
	or al, 0x2
	out 0x92, al
	ret

times GDT_OFFSET - ($ - $$) db 0

_gdt:
_null:
dd 0
dd 0

KDATA_SEG	EQU _k_data - _gdt
_k_data:
dw 0xFFFF
dw 0
db 0
db 0x92
db 0xCF
db 0

KCODE_SEG	EQU _k_code - _gdt
_k_code:
dw 0xFFFF
dw 0
db 0
db 0x9A
db 0xCF
db 0

gdtr_area:
dw $-_gdt-1
dd _gdt

_str_2nd_stage:
db 'Entering protected mode...', 0xD, 0xA, 0x0

times SIZE_2ND_STAGE - ($ - $$) db 0
_stack_top:
_end_2nd_stage:
