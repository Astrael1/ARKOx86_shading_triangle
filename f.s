section .text
;define function for c program
global f
f:
push rbp	; push "calling procedure" frame pointer
mov rbp, rsp	; set new frame pointer 
			;	- "this procedure" frame pointer

;change pixel of given coordinates to given color
;mov rcx, 0
;mov dword ecx, [rsi+8]
;push rcx
;mov dword ecx, [rsi+4]
;push rcx
;mov dword ecx, [rsi]
;push rcx
;call change_pixel_XY

mov rcx, 0
mov dword ecx, 0x00000000
push rcx
call clear_image_with_color

mov rax, [rsi + 20]
push rax
mov rax, [rsi + 16]
push rax
mov rax, [rsi + 12]
push rax

mov rax, [rsi + 8]
push rax
mov rax, [rsi + 4]
push rax
mov rax, [rsi]
push rax

call draw_line

end:
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret

draw_line:
	;prologue
	push rbp	; push "calling procedure" frame pointer
	mov rbp, rsp	; set new frame pointer
	
	mov rax, 0x00000000
	push rax	; first local - X
	push rax	; second local - Y
	push rax	; dX
	push rax	; dY
	push rax	; kX
	push rax	; kY
	push rax	; e

	mov rax, [rbp + 16]
	mov [rbp - 8], rax	; save X
	mov rax, [rbp + 24]
	mov [rbp - 16], rax	; save Y

	; call parameters
	; first end
	; [rbp+16] - X 1
	; [rbp+24] - Y 1
	; [rbp+32] - color1
	; second end
	; [rbp+40] - X 2
	; [rbp+48] - Y 2
	; [rbp+56] - color2


	;mov rcx, 0
	;mov dword ecx, [rbp+32]
	;push rcx
	;mov dword ecx, [rbp+24]
	;push rcx
	;mov dword ecx, [rbp+16]
	;push rcx
	;call change_pixel_XY	; color pixel (param1, param2) with color 'param3'
	
	mov rcx, 0
	mov rax, 0
	mov dword ecx, [rbp + 16]	; read x1
	mov dword eax, [rbp + 40]	; read x2

	cmp ecx, eax	; if x1 > x2 then kx = -1
	jg negative_kx
	sub eax, ecx	; calculate dX
	mov [rbp - 24], rax ; save dX
	mov eax, 1
	mov [rbp - 40], rax	; save kX
	jmp positive_kx

negative_kx:
	sub ecx, eax	; calculate dX
	mov [rbp - 24], rcx ; save dX
	mov eax, -1
	mov [rbp - 40], rax	; save kX
positive_kx:

	mov rcx, 0
	mov rax, 0
	mov dword ecx, [rbp + 24]
	mov dword eax, [rbp + 48]
	cmp ecx, eax	; if y1 > y2 then ky = -1
	jg negative_ky
	sub eax, ecx	; calculate dY
	mov [rbp - 32], rax ; save dY
	mov eax, 1
	mov [rbp - 48], rax	; save kY
	jmp positive_ky
negative_ky:
	sub ecx, eax	; calculate dY
	mov [rbp - 32], rcx ; save dY
	mov eax, -1
	mov [rbp - 48], rax	; save kY
positive_ky:

	mov rax, [rbp - 24] ; read dX
	mov rdx, 0x2
	div dl	; divide by two
	mov ah, 0	; remove the rest
	mov [rbp - 56], rax	; save the 'e' value

	mov rax, [rbp + 32]
	push rax
	mov rax, [rbp - 16]
	push rax
	mov rax, [rbp - 8]
	push rax
	call change_pixel_XY	; color pixel (param1, param2) with color 'param3'

	
	mov eax, [rbp - 24]	; read dX
	mov ebx, [rbp - 32]	; read dY
	cmp eax, ebx	; if dX < dY then invert algorithm
	jl draw_line_inverted

	; calculate 'e'
	mov rax, [rbp - 24] ; read dX
	mov rdx, 0x2
	div dl	; divide by two
	mov ah, 0	; remove the rest
	mov [rbp - 56], rax	; save the 'e' value

	mov rdx, [rbp - 24]	; proceed dY times
	cmp rdx, 0
	jz draw_line_end
	mov rcx, 0


draw_line_loop:
	inc rcx
	mov rax, [rbp - 8]	; read X
	mov rbx, [rbp - 40]	; read kX
	add rax, rbx	; add kX
	mov [rbp - 8], rax	; save X

	mov rax, [rbp - 56] ; read e
	mov rbx, [rbp - 32] ; read dY
	sub rax, rbx	; e = e - dY
	mov [rbp - 56], rax	; save e
	cmp rax, 0

	jge skip_slow_dimension
	mov rax, [rbp - 16]	; read Y
	mov rbx, [rbp -  48]	; read kY
	add rax, rbx	; add kY
	mov [rbp - 16], rax	; save Y


	mov rax, [rbp - 56] ; read e
	mov rbx, [rbp - 24] ; read dX
	add rax, rbx	; e = e + dX
	mov [rbp - 56], rax ; save e

skip_slow_dimension:
	mov rax, [rbp + 32]
	push rax
	mov rax, [rbp - 16]
	push rax
	mov rax, [rbp - 8]
	push rax
	call change_pixel_XY	; color pixel (param1, param2) with color 'param3'
	mov rdx, [rbp - 24]	; read dX
	cmp rcx, rdx	; if loop counter is equal to dX then end
	jl draw_line_loop

	jmp draw_line_end


draw_line_inverted:

	; calculate 'e'
	mov rax, [rbp - 32] ; read dY
	mov rdx, 0x2
	div dl	; divide by two
	mov ah, 0	; remove the rest
	mov [rbp - 56], rax	; save the 'e' value

	mov rdx, [rbp - 32]	; proceed dY times
	cmp rdx, 0
	jz draw_line_end
	mov rcx, 0
draw_line_inverted_loop:
	inc rcx

	;mov rax, 0
	;push rax
	;mov rax, 0
	;push rax
	;mov rax, [rbp - 16]
	;push rax
	;call change_pixel_XY	; color pixel (param1, param2) with color 'param

	mov rax, [rbp - 16]	; read Y
	mov rbx, [rbp - 48]	; read kY
	add rax, rbx	; add kY
	mov [rbp - 16], rax	; save Y

	mov rax, [rbp - 56] ; read e
	mov rbx, [rbp - 24] ; read dX
	sub rax, rbx	; e = e - dX
	mov [rbp - 56], rax	; save e
	cmp rax, 0

	jge skip_slow_dimension_inverted
	mov rax, [rbp - 8]	; read X
	mov rbx, [rbp -  40]	; read kX
	add rax, rbx	; add kX
	mov [rbp - 8], rax	; save X


	mov rax, [rbp - 56] ; read e
	mov rbx, [rbp - 32] ; read dY
	add rax, rbx	; e = e + dY
	mov [rbp - 56], rax ; save e

	;mov rax, 0x00ffffff
	;push rax
	;mov rax, 0
	;push rax
	;mov rax, [rbp - 8]
	;push rax
	;call change_pixel_XY	;DEBUG


skip_slow_dimension_inverted:

	mov rax, [rbp + 32]
	push rax
	mov rax, [rbp - 16]
	push rax
	mov rax, [rbp - 8]
	push rax
	call change_pixel_XY	; color pixel (param1, param2) with color 'param3'
	
	
	mov rdx, [rbp - 32]	; read dY
	cmp rcx, rdx	; if loop counter is greater/equal to dX then end
	jl draw_line_inverted_loop

draw_line_end:
	;epilogue
	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret

change_pixel_XY:
	;prologue
	push rbp	; push "calling procedure" frame pointer
	mov rbp, rsp	; set new frame pointer
	push rax
	push rbx
	push rcx
	push rdx

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
	mov dword edx, [rbp + 32]	; load color

	mov dword [rbx], edx ; change pixel
	;mov qword [rbx+8], rbx ; change pixel

	;epilogue
	pop rdx
	pop rcx
	pop rbx
	pop rax
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
	jz clear_end

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