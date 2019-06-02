section .text
;define function for c program
global f
f:
	push rbp
	mov rbp, rsp
	mov rax, [rbp+8]
begin:
	mov word [rax], 0x1
end:	
	mov rsp, rbp
	pop rbp
	ret
