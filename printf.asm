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