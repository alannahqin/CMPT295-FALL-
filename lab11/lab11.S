.text

# double dot product
.globl dot_double
dot_double:
    xorpd %xmm0, %xmm0
    xorq %rax, %rax
dd_loop:
    cmpq %rdx, %rax
    jae dd_end
    movsd (%rdi,%rax,8), %xmm1
    mulsd (%rsi,%rax,8), %xmm1
    addsd %xmm1, %xmm0
    incq %rax
    jmp dd_loop
dd_end:
    ret

# single dot product
.globl dot_single
dot_single:
    xorps %xmm0, %xmm0
    xorq %rax, %rax
ds_loop:
    cmpq %rdx, %rax
    jae ds_end
    movss (%rdi,%rax,4), %xmm1
    mulss (%rsi,%rax,4), %xmm1
    addss %xmm1, %xmm0
    incq %rax
    jmp ds_loop
ds_end:
    ret

# double polynomial
.globl map_poly_double
map_poly_double:
    xorq %rax, %rax
pd_loop:
    cmpq %rdx, %rax
    jae pd_end
    movsd (%rdi,%rax,8), %xmm4
    movapd %xmm0, %xmm5
    mulsd %xmm4, %xmm5
    addsd %xmm1, %xmm5
    mulsd %xmm4, %xmm5
    addsd %xmm2, %xmm5
    mulsd %xmm4, %xmm5
    addsd %xmm3, %xmm5
    movsd %xmm5, (%rsi,%rax,8)
    incq %rax
    jmp pd_loop
pd_end:
    ret

# single polynomial
.globl map_poly_single
map_poly_single:
    xorq %rax, %rax
ps_loop:
    cmpq %rdx, %rax
    jae ps_end
    movss (%rdi,%rax,4), %xmm4
    movaps %xmm0, %xmm5
    mulss %xmm4, %xmm5
    addss %xmm1, %xmm5
    mulss %xmm4, %xmm5
    addss %xmm2, %xmm5
    mulss %xmm4, %xmm5
    addss %xmm3, %xmm5
    movss %xmm5, (%rsi,%rax,4)
    incq %rax
    jmp ps_loop
ps_end:
    ret

# vector double dot product
.globl dot_double_vec
dot_double_vec:
    vxorpd %ymm0, %ymm0, %ymm0
    xorq %rax, %rax
ddv_loop:
    cmpq %rdx, %rax
    jae ddv_end
    vmovupd (%rdi,%rax,8), %ymm1
    vmulpd (%rsi,%rax,8), %ymm1, %ymm1
    vaddpd %ymm1, %ymm0, %ymm0
    addq $4, %rax
    jmp ddv_loop
ddv_end:
    # sum the four doubles
    vextractf128 $1, %ymm0, %xmm1
    vaddpd %xmm1, %xmm0, %xmm0
    vhaddpd %xmm0, %xmm0, %xmm0
    vzeroupper
    ret

# vector single dot product
.globl dot_single_vec
dot_single_vec:
    vxorps %ymm0, %ymm0, %ymm0
    xorq %rax, %rax
dsv_loop:
    cmpq %rdx, %rax
    jae dsv_end
    vmovups (%rdi,%rax,4), %ymm1
    vmulps (%rsi,%rax,4), %ymm1, %ymm1
    vaddps %ymm1, %ymm0, %ymm0
    addq $8, %rax
    jmp dsv_loop
dsv_end:
    # sum the eight floats
    vextractf128 $1, %ymm0, %xmm1
    vaddps %xmm1, %xmm0, %xmm0
    vhaddps %xmm0, %xmm0, %xmm0
    vhaddps %xmm0, %xmm0, %xmm0
    vzeroupper
    ret

# vector double polynomial
.globl map_poly_double_vec
map_poly_double_vec:
    # broadcast coefficients
    vbroadcastsd %xmm0, %ymm0
    vbroadcastsd %xmm1, %ymm1
    vbroadcastsd %xmm2, %ymm2
    vbroadcastsd %xmm3, %ymm3
    xorq %rax, %rax
pdv_loop:
    cmpq %rdx, %rax
    jae pdv_end
    vmovupd (%rdi,%rax,8), %ymm4
    vmulpd %ymm4, %ymm0, %ymm5
    vaddpd %ymm1, %ymm5, %ymm5
    vmulpd %ymm4, %ymm5, %ymm5
    vaddpd %ymm2, %ymm5, %ymm5
    vmulpd %ymm4, %ymm5, %ymm5
    vaddpd %ymm3, %ymm5, %ymm5
    vmovupd %ymm5, (%rsi,%rax,8)
    addq $4, %rax
    jmp pdv_loop
pdv_end:
    vzeroupper
    ret

# vector single polynomial
.globl map_poly_single_vec
map_poly_single_vec:
    vbroadcastss %xmm0, %ymm0
    vbroadcastss %xmm1, %ymm1
    vbroadcastss %xmm2, %ymm2
    vbroadcastss %xmm3, %ymm3
    xorq %rax, %rax
psv_loop:
    cmpq %rdx, %rax
    jae psv_end
    vmovups (%rdi,%rax,4), %ymm4
    vmulps %ymm4, %ymm0, %ymm5
    vaddps %ymm1, %ymm5, %ymm5
    vmulps %ymm4, %ymm5, %ymm5
    vaddps %ymm2, %ymm5, %ymm5
    vmulps %ymm4, %ymm5, %ymm5
    vaddps %ymm3, %ymm5, %ymm5
    vmovups %ymm5, (%rsi,%rax,4)
    addq $8, %rax
    jmp psv_loop
psv_end:
    vzeroupper
    ret

.section .note.GNU-stack,"",@progbits
