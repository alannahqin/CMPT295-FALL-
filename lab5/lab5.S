
.section .note.GNU-stack,""
.text

.global fibonacci
.global polynomial1
.global polynomial2
.global is_odd1
.global is_odd2
.global mul1
.global mul2

#fibonacci using recursion
fibonacci:
    cmp $1, %rdi
    jbe fib_base

    push %rbx
    sub $16, %rsp
    mov %rdi, %rbx

    sub $1, %rdi
    call fibonacci
    mov %rax, (%rsp)

    lea -2(%rbx), %rdi
    call fibonacci
    add (%rsp), %rax

    add $16, %rsp
    pop %rbx
    ret

fib_base:
    mov %rdi, %rax
    ret


#polynomial 1
polynomial1:
    mov %rsi, %rax
    imul %rdi, %rax
    imul %rdi, %rax
    imul %rdi, %rax

    mov %rdx, %r9
    imul %rdi, %r9
    imul %rdi, %r9
    add %r9, %rax

    mov %rcx, %r9
    imul %rdi, %r9
    add %r9, %rax
    add %r8, %rax
    ret


#polynomial 2
polynomial2:
    mov %rsi, %rax
    imul %rdi, %rax
    add %rdx, %rax
    imul %rdi, %rax
    add %rcx, %rax
    imul %rdi, %rax
    add %r8, %rax
    ret


#odd 1
is_odd1:
    mov %rdi, %rax
    cqo
    mov $2, %rcx
    idiv %rcx
    mov %rdx, %rax
    and $1, %rax
    ret


#odd 2
is_odd2:
    mov %rdi, %rax
    and $1, %rax
    ret


#multiply 1
mul1:
    mov %rdi, %rax
    mov $65537, %rcx
    mul %rcx
    ret


#multiply 2
mul2:
    mov %rdi, %rax
    shl $16, %rax
    add %rdi, %rax
    ret
