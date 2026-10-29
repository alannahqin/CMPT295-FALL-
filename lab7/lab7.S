
.data
seed:
    .quad 1

.text
.globl randint
.globl fill_array
.globl dot
.globl dot_struct

randint:
    # get the seed
    movq seed(%rip), %rax

    # multiply by the big number
    movabsq $6364136223846793005, %r8
    imulq %r8, %rax
    addq $1, %rax

    # save the new seed
    movq %rax, seed(%rip)

    # shift to get random number
    shrq $33, %rax
    ret


fill_array:
    # save registers since randint is called
    pushq %rbx
    pushq %r12
    pushq %r13

    movq %rdi, %rbx
    movq %rsi, %r12
    movq $0, %r13

fill_loop:
    cmpq %r12, %r13
    jae fill_done

    call randint

    # make number between -128 and 127
    andq $0xff, %rax
    subq $128, %rax

    movq %rax, (%rbx,%r13,8)

    incq %r13
    jmp fill_loop

fill_done:
    popq %r13
    popq %r12
    popq %rbx
    ret


dot:
    # rdi = first array, rsi = second array
    # rdx = length
    movq $0, %rax
    movq $0, %rcx

dot_loop:
    cmpq %rdx, %rcx
    jae dot_done

    movq (%rdi,%rcx,8), %r8
    imulq (%rsi,%rcx,8), %r8
    addq %r8, %rax

    incq %rcx
    jmp dot_loop

dot_done:
    ret


dot_struct:
    # each pair takes 16 bytes
    movq $0, %rax
    movq $0, %rcx

struct_loop:
    cmpq %rsi, %rcx
    jae struct_done

    # get the two values in the pair
    movq (%rdi), %r8
    imulq 8(%rdi), %r8
    addq %r8, %rax

    # move to next pair
    addq $16, %rdi
    incq %rcx
    jmp struct_loop

struct_done:
    ret

.section .note.GNU-stack,"",@progbits
