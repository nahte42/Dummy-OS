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