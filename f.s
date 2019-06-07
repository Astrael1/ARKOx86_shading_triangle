section .text
;define function for c program
global f
f:
push rbp	; push "calling procedure" frame pointer
mov rbp, rsp	; set new frame pointer 
			;	- "this procedure" frame pointer

mov rax, rsi
mov dword rcx, [rax + 4]

;mov rcx, 0x0000000000ffffff
push rcx
;call change_pixel
call test_second_param

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

	mov rax, [rbp + 16]	; get color from stack
	mov rbx, 0x0
	mov ebx, [rdi+10]	; load pixel offset
	add rbx, rdi	; now rax points at first pixel
		
	; 0x XXrrggbb
	mov word ecx, 0x0100
	mul ecx
	mov dword [rbx], 0x0000ff00	; change first pixel

	;mov dword [rax + 16], ecx	;change fifth pixel

	;epilogue
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret

test_second_param:
	;prologue
	push rbp	; push "calling procedure" frame pointer
	mov rbp, rsp	; set new frame pointer

	mov rbx, 0
	mov ebx, [rdi + 10] ; load pixell offset into ebx
	add rbx, rdi ; add image pointer, rbx points at first pixel of image

	mov rax ,0
	mov dword eax, [rdi + 18]	; load image width
	mov dword edx, [rsi + 4]; load Y coordinate
	
	mul rdx ; multiply width by Y
	mov rdx, 0x4
	mul rdx	; multiply by 4

	add rbx, rax

	mov rax, 0
	mov dword eax, [rsi] ; load X coordinate
	mov rdx, 0x4
	mul rdx ; multiply by 4
	
	add rbx, rax
	mov dword edx, [rsi + 8]

	mov dword [rbx], edx ; change pixel
	;mov qword [rbx+8], rbx ; change pixel



	;mov rcx, 0x0000000000ffffff

	;epilogue
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret
