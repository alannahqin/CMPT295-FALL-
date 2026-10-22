.text

.globl strlen_mine
strlen_mine:
    movq $0, %rax

loop_mine:
    cmpb $0, (%rdi)
    je done_mine

    incq %rax
    incq %rdi
    jmp loop_mine

done_mine:
    ret


.globl strlen_utf8
strlen_utf8:
    movq $0, %rax

loop_utf8:
    cmpb $0, (%rdi)
    je done_utf8

    movb (%rdi), %dl
    andb $0xC0, %dl
    cmpb $0x80, %dl
    je skip_utf8

    incq %rax

skip_utf8:
    incq %rdi
    jmp loop_utf8

done_utf8:
    ret

.section .note.GNU-stack,"",@progbits
