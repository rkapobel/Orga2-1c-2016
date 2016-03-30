x default  rel

section .data
   msg:  DB 'en 10 me voy ... 9', 10
   largo EQU $ - msg
global start
section .text
   start:
   mov r14, 10
   ciclo:
     mov rax, 0x2000004 ;sys write
     mov rdi, 1 ;stdout salida standard
     lea rsi, [rel msg]
     mov rdx, largo 
     syscall
     mov r15, (msg + largo)-2
     dec byte [(msg  + largo)-2]
     dec r14
     cmp r14, 0
   jnz ciclo

   mov rax, 0x2000001
   mov rdi, 0
   syscall
