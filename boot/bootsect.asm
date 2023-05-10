
[BITS 16]

ORG 0x00

_bootstart:
	db 0xEA
	dw _main, 0x07C0

_main:
	cli
	xor ax, ax
	mov sp, ax
	mov ax, cs
	mov es, ax
	mov ds, ax
	mov ss, ax
	mov [boot_drive], dl
	sti

	mov al, [boot_drive]
	call _hex_to_ascii
	mov [boot_drive_string + 13], al
	mov [boot_drive_string + 14], cl
	lea si, boot_drive_string
	call _print_msg
	jmp $

_hex_to_ascii:
	mov cl, al
	shr al, 4
	and cl, 0x0F

	mov bl, al
	call _nibble_treat
	mov al, bl

	mov bl, cl
	call _nibble_treat
	mov cl, bl
	ret

_nibble_treat:
	cmp bl, 0x09
	jle _number
	add bl, 0x41
	ret
_number:
	add bl, 0x30
	ret


_print_msg:
	mov al, [si]
	or al, al
	jz _end_final_print
	mov ah, 0x0E
	mov bl, 0x07
	int 0x10
	inc si
	jmp _print_msg
_end_final_print:
	ret

boot_drive:
db 0

boot_drive_string:
db 'BootDrive: 0x', 0x0, 0x0, 0xD, 0xA, 0x0


TIMES 510 - ($ - $$) db 0
dw 0xAA55

