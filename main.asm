org 0x7c00					;boot sector starts at this location in memory, so must start from here 0x7c00 - 0x7e00
[bits 16]
	
section .text
	global main
	
main:

cli
jmp 0x0000:ZeroSeg
ZeroSeg:
	xor ax, ax				;sets ax to 0
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, main
	cld
sti
	
push ax
xor ax, ax
int 0x13
pop ax


mov al, 1
mov cl, 2
call readDisk
mov dx, [0x7c00 + 510]
call printh

jmp $						;jump to cursor in bios, hang

%include "./printf.asm"
%include "./readDisk.asm"
%include "./printh.asm"
		

	
DISK_ERR_MSG: db 'Error Loading Disk.', 0x0a, 0x0d, 0
TEST_STR: db 'You are in the second sector.', 0x0a, 0x0d, 0

times 510-($-$$) db 0		;padding 0 for boot sector
dw 0xaa55					;magic number at end of boot sector

test:
mov si, TEST_STR
call printf

times 512 db 0
	