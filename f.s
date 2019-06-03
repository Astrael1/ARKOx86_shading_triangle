section .text
;define function for c program
global f
f:
push rbp	; push "calling procedure" frame pointer
mov rbp, rsp	; set new frame pointer 
			;	- "this procedure" frame pointer

;------------------------------------------------------------------------------

mov rsi, rdi	; save copy of string begin pointer

;------------------------------------------------------------------------------
			; look for the string end (null character == '\0' == 0)
			;	 (NOT zero character == '0')
	
	mov dl, [rdi]	; load byte
	cmp dl, 0	; cmp will set ZERO flag if dl is zero
	jz end		; jump to end because the string is 
			;	empty (first byte is zero!)
	mov byte dl, 0x41
	mov [rdi], dl

end:

;------------------------------------------------------------------------------

	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret