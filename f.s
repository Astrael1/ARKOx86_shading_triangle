section .text
;define function for c program
global f
f:
push rbp	; push "calling procedure" frame pointer
mov rbp, rsp	; set new frame pointer 
			;	- "this procedure" frame pointer

mov rax, rsi
mov dword rcx, [rax+4]

;mov rcx, 0x0000000000ffffff
push rcx
call change_pixel

end:
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret

draw_line:
	;

change_pixel:
	; prologue
	push rbp	; push "calling procedure" frame pointer
	mov rbp, rsp	; set new frame pointer

	mov rcx, [rbp + 16]
	mov rax, 0x0
	mov eax, [rdi+10]	; load pixel offset
	mov rbx, rdi
	add rax, rbx	; now rax points at first pixel
		
	; 0x XXrrggbb
	mov dword [rax], ecx
	mov dword [rax + 16], ecx

	;epilogue
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret
