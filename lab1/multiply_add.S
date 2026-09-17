    .section .note.GNU-stack, ""
    .global multiply_add
    .text

multiply_add:
    mov %rsi, %rax
    imul %rdx, %rax
    add %rdi, %rax
    ret
