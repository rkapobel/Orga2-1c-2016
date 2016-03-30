default  rel

section .data
   msg:  DB 'Hola Mundo', 10
   largo EQU $ - msg
global start ;global _start
section .text
   start: ;   _start:
   mov rax, 0x2000004     ; funcion 4
   mov rdi, 1     ; stdout
   lea rsi, [rel msg] ;  mensaje - absolute addressing not allowed: mov rcx, msg
   mov rdx, largo ; longitud
   syscall ; because is x86_64 - int 0x80 on i386
   mov rax, 0x2000001
   mov rdi, 0
   syscall
