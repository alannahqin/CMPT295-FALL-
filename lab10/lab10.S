
.text
.globl dot_double
.globl dot_single
.globl map_poly_double
.globl map_poly_single
.globl sin_x87

dot_double:
    xorpd %xmm0, %xmm0
    mov $0, %rcx
.Ldot_double_loop:
    cmp %rdx, %rcx
    jae .Ldot_double_done
    movsd (%rdi, %rcx, 8), %xmm1
    mulsd (%rsi, %rcx, 8), %xmm1
    addsd %xmm1, %xmm0
    inc %rcx
    jmp .Ldot_double_loop
.Ldot_double_done:
    ret

dot_single:
    xorps %xmm0, %xmm0
    mov $0, %rcx
.Ldot_single_loop:
    cmp %rdx, %rcx
    jae .Ldot_single_done
    movss (%rdi, %rcx, 4), %xmm1
    mulss (%rsi, %rcx, 4), %xmm1
    addss %xmm1, %xmm0
    inc %rcx
    jmp .Ldot_single_loop
.Ldot_single_done:
    ret

map_poly_double:
    mov $0, %rcx
.Lpoly_double_loop:
    cmp %rdx, %rcx
    jae .Lpoly_double_done
    movsd (%rdi, %rcx, 8), %xmm4
    movapd %xmm0, %xmm5
    mulsd %xmm4, %xmm5
    addsd %xmm1, %xmm5
    mulsd %xmm4, %xmm5
    addsd %xmm2, %xmm5
    mulsd %xmm4, %xmm5
    addsd %xmm3, %xmm5
    movsd %xmm5, (%rsi, %rcx, 8)
    inc %rcx
    jmp .Lpoly_double_loop
.Lpoly_double_done:
    ret

map_poly_single:
    mov $0, %rcx
.Lpoly_single_loop:
    cmp %rdx, %rcx
    jae .Lpoly_single_done
    movss (%rdi, %rcx, 4), %xmm4
    movaps %xmm0, %xmm5
    mulss %xmm4, %xmm5
    addss %xmm1, %xmm5
    mulss %xmm4, %xmm5
    addss %xmm2, %xmm5
    mulss %xmm4, %xmm5
    addss %xmm3, %xmm5
    movss %xmm5, (%rsi, %rcx, 4)
    inc %rcx
    jmp .Lpoly_single_loop
.Lpoly_single_done:
    ret

sin_x87:
    mov $0, %rcx
.Ls87_loop:
    cmp %rdx, %rcx
    jae .Ls87_done
    fldl (%rdi, %rcx, 8)
    fsin
    fstpl (%rsi, %rcx, 8)
    inc %rcx
    jmp .Ls87_loop
.Ls87_done:
    ret

.section .note.GNU-stack,"",@progbits
