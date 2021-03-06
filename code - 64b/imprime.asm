default rel

section .data
    msg: db 'Parameters are:', 0
    fmt: db '%s %d %f and %s', 10

global _imprime
section .text
extern _printf
   _imprime: 
        push rbp
        mov rbp, rsp
        sub rsp, 8
        push rbx
        push r12
        push r13
        push r14
        push r15
        mov rax, 1
        mov rdx, rdi
        lea rcx, [rel rsi]
        lea rdi, [rel fmt]
        lea rsi, [rel msg]
        call _printf
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        add rsp, 8
        pop rbp
    ret
