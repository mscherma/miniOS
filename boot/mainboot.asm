
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

_print_string:
	mov al, [si]
	test al, al
	jz _end_loop
	mov ah, 0xE
	mov bl, 0x7
	int 0x10
	inc si
	jmp _print_string
_end_loop:

	call _get_memory_map_E820
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

	cld
	xor esi, esi
	xor edi, edi
	xor ecx, ecx
	mov ecx, (KERNEL_SIZE / 4)
	mov edi, KERNEL_ENTRY_OFFSET
	mov esi, BOOT_2ND_STAGE_SEG
	shl esi, 4
	add esi, SIZE_2ND_STAGE
	rep movsd

	xor eax, eax
	xor ebx, ebx
	mov ebx, BOOT_2ND_STAGE_SEG
	shl ebx, 4
	mov [ebx + _k_code + 2], ax
	mov [ebx + _k_code + 4], al
	mov [ebx + _k_code + 7], al
	lgdt [ebx + gdtr_area]
	jmp KCODE_SEG:KERNEL_ENTRY_OFFSET

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

_memory_map_size:
db 0

_memory_map_entry_list:

times SIZE_MAX_MEMORY_MAP db 0

[BITS 16]
_get_memory_map_E820:
	xor ebx, ebx
	lea si, _memory_map_size
	lea di, _memory_map_entry_list
_mem_enum_loop:
	xor eax, eax
	mov eax, 0xE820
	mov edx, 0x534D4150
	mov ecx, MEMORY_MAP_ENTRY_SIZE
	int 0x15

	jc _end_mem_enum_loop
	test ebx, ebx
	jz _end_mem_enum_loop

	add di, MEMORY_MAP_ENTRY_SIZE
	inc byte [si]
	jmp _mem_enum_loop
_end_mem_enum_loop:
	ret


times SIZE_2ND_STAGE - ($ - $$) db 0

_stack_top:
_end_2nd_stage:
