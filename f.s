section .text
;define function for c program
global f
f:
push rbp	; push "calling procedure" frame pointer
mov rbp, rsp	; set new frame pointer 
			;	- "this procedure" frame pointer

;mov rcx, 0
;mov dword ecx, [rsi+8]
;push rcx
;mov dword ecx, [rsi+4]
;push rcx
;mov dword ecx, [rsi]
;push rcx
;call change_pixel_XY

mov rcx, 0
mov dword ecx, [rsi+8]
push rcx
call clear_image_with_color

end:
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret

draw_line:
	;

change_pixel_XY:
	;prologue
	push rbp	; push "calling procedure" frame pointer
	mov rbp, rsp	; set new frame pointer

	mov rbx, 0
	mov ebx, [rdi + 10] ; load pixel offset into ebx
	add rbx, rdi ; add image pointer, rbx points at first pixel of image

	mov rax ,0
	mov dword eax, [rdi + 18]	; load image width
	mov dword edx, [rbp + 24]; load Y coordinate
	
	mul rdx ; multiply width by Y
	mov rdx, 0x4
	mul rdx	; multiply by 4

	add rbx, rax

	mov rax, 0
	mov dword eax, [rbp + 16] ; load X coordinate
	mov rdx, 0x4
	mul rdx ; multiply by 4
	
	add rbx, rax
	mov dword edx, [rbp + 32]

	mov dword [rbx], edx ; change pixel
	;mov qword [rbx+8], rbx ; change pixel

	;epilogue
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret

clear_image_with_color:
	;prologue
	push rbp	; push "calling procedure" frame pointer
	mov rbp, rsp	; set new frame pointer

	mov edx, [rbp + 16]
	mov rbx, 0
	mov ebx, [rdi + 10] ; load pixel offset into ebx
	mov eax, [rdi + 2]	; load image size into eax
	sub eax, ebx	; subtract offset from size to get number of pixel bytes
	add rbx, rdi ; add image pointer, rbx points at first pixel of image

	cmp eax, 0
	jz end

clear_loop:
	sub eax, 4
	mov dword [rbx], edx
	add rbx, 4
	cmp eax, 0
	jg clear_loop
	

clear_end:
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret