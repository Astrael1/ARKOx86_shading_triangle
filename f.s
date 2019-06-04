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
	mov rax, 0x0
	mov eax, [rdi+10]	; load pixel offset
	mov rbx, rdi
	add rax, rbx
	
	;mov [rdi], al

	mov dword [rax], 0x12345678 ; load 0x00ffffff byte and watch it crash
	;mov [rdi], eax

end:

;------------------------------------------------------------------------------

	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret