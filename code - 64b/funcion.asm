global _obtenerPosicionDelPrimerMaximo

section .text

_obtenerPosicionDelPrimerMaximo:
	;rdi matriz 
	;rsi *f
	;rdx *c
	
	push rbp;
	mov rbp, rsp;
	push rbx;

	xor rcx, rcx; contador
	xor rbx, rbx; columna
	xor r11, r11; fila
	
	xor r12, r12; maximo actual
	
	mov r8d, [rsi]; #fila
	mov r9d, [rdx]; #columna
	
	xor rax, rax
	mov eax, r9d
	push rdx ; mul mata rdx
	mul r8d; fila * columna ;eax me queda fila * columna
	pop rdx 
.ciclo:
	cmp r12d, [rdi + rcx * 4]
	jge _obtenerPosicionDelPrimerMaximo.compCol
	mov r12d, [rdi + rcx * 4]
	mov [rsi], r11d
	mov [rdx], ebx
	
.compCol:
	inc ebx
	cmp ebx, r9d 
	jne _obtenerPosicionDelPrimerMaximo.contador
	xor ebx, ebx
	inc r11d	
	
.contador:
	inc ecx
	cmp ecx, eax
	jne _obtenerPosicionDelPrimerMaximo.ciclo
	
	pop rbx
	pop rbp
	ret
