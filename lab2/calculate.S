.section .note.GNU-stack,""
.global calculate
.text

calculate:
    #make stack space and store
    push %rbx
    sub $16, %rsp
    mov %rdi, %rbx

    #a = x + 3
    lea 3(%rbx), %rax
    mov %rax, 0(%rsp)

    #b = f(x, a)
    mov %rbx, %rdi
    mov 0(%rsp), %rsi
    call f

    #save b since r10 is not call-preserved
    mov %rax, %r10
    mov %r10, 8(%rsp)

    #c = f(b, x)
    mov %r10, %rdi
    mov %rbx, %rsi
    call f

    #restore b and save b + c
    mov 8(%rsp), %r10
    add %rax, %r10
    mov %r10, 8(%rsp)

    #d = f(x, c)
    mov %rbx, %rdi
    mov %rax, %rsi
    call f

    #Return a + b + c + d
    mov 8(%rsp), %r10
    add %r10, %rax
    add 0(%rsp), %rax

    #Restore stack and rbx
    add $16, %rsp
    pop %rbx
    ret
