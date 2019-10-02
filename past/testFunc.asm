org 0x7c00					;boot sector starts at this location in memory, so must start from here 0x7c00 - 0x7e00

mov si, STR_0					;move variable STR into register si
call printf					;call function printf

mov si, STR_T
call printf

mov si, STR_TH
call printf

mov al, 1
mov cl, 2
call readDisk
jmp test

jmp $						;jump to cursor in bios, hang

printf:
	pusha					;push everything to the stack
	str_loop:				;start looop function
		mov al, [si]		;move whatever is at the current memory location of si to register al
		cmp al, 0			;compare contents of register al to number 0
		jne print_char		;if the value was not 0 we call print char
		popa				;pop everything from stack
		ret					;return from function
	print_char:
		mov ah, 0x0e		;bios cursor moves over one
		int 0x10			;prints to screen
		add si, 1			;add 1 to si to go to next memory location
		jmp str_loop		;jump back to str_loop
		
		
readDisk:
	pusha
	mov ah, 0x02					;set ah to 02 hex, to indicate we are reading from disk
	mov dl, 0x80 ;0x0				;if booting from hard disk make it 0x80, must be 0x80 for qemu: 0x0 is for ISO on USB, CD, etc
	mov ch, 0						;we want firs cylinder
	mov dh, 0						;want first head
	;mov al, 1						;read one sector
	;mov cl, 2						;start reading from second sector
	
	push bx							;push bx to stack
	mov bx, 0						;move segment register to 0
	mov es, bx						
	pop bx							
	mov bx, 0x7c00 + 512			;mov bx to original starting location + 512
	
	int 0x13
	
	jc disk_err
	popa
	ret
	
	disk_err:
		mov si, DISK_ERR_MSG
		call printf
		jmp $
	
STR_0: db 'Loaded in 16-bit Real Mode to memory location 0x7c00.', 0x0e, 0x0d, 0
STR_T: db 'These messages use the BIOS interupt 0x10 with the ah register set to 0x0e.',0x0a,0x0d, 0
STR_TH: db 'Heraclitus test boot complete. Power off this machine and load real OS dummy.', 0
DISK_ERR_MSG: db 'Error Loading Disk.', 0x0a, 0x0d, 0
TEST_STR: db 'You are in the second sector.', 0x0a, 0x0d, 0

times 510-($-$$) db 0		;padding 0 for boot sector
dw 0xaa55					;magic number at end of boot sector

test:
mov si, TEST_STR
call printf

times 512 db 0
	