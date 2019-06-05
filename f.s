section .text
;define function for c program
global f
f:
push rbp	; push "calling procedure" frame pointer
mov rbp, rsp	; set new frame pointer 
			;	- "this procedure" frame pointer


mov rcx, 0x0000000000ffffff
call change_pixel

end:
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret

draw_line:
	;

change_pixel:
	;
	mov rax, 0x0
	mov eax, [rdi+10]	; load pixel offset
	mov rbx, rdi
	add rax, rbx
		
	; 0x XXrrggbb
	mov dword [rax], ecx
	ret
