.section .note.GNU-stack,"",@progbits

.global abs_value
.global power2
.global hailstone_length

.text

#abs_value
#Returns the absolute value of the number

abs_value:
    mov %rdi, %rax
    cmp $0, %rax
    jge abs_done
    neg %rax
abs_done:
    ret


#power2
#Prints powers of 2 from 1 through 2^n.

power2:
    push %rbx
    push %r12

    mov $1, %rbx
    mov %rdi, %r12
power2_loop:
    mov %rbx, %rdi
    call print_uint64
    cmp $0, %r12
    je power2_done

    add %rbx, %rbx
    dec %r12

    jmp power2_loop
power2_done:
    #restore the saved registers.
    pop %r12
    pop %rbx

    ret


#hailstone_length
#counts how many steps it takes for n to reach 1.

hailstone_length:
    mov $0, %rax
hailstone_loop:
    cmp $1, %rdi
    je hailstone_done
    inc %rax
    mov %rdi, %rcx

    and $1, %rcx
    jz hailstone_even

    #odd case
    #n = 3*n + 1
    imul $3, %rdi
    add $1, %rdi

    jmp hailstone_loop
hailstone_even:
    #even case
    #n = n / 2
    shr $1, %rdi

    jmp hailstone_loop
hailstone_done:
    ret
