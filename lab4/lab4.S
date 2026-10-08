
.section .note.GNU-stack,""
.text

.global is_prime
.global largest_power_unsigned
.global overflowing_subtract
.global dumb


#check if a number is prime
is_prime:
    #check divisors from 2
    mov $2, %r8

#loop to check if prime
prime_loop:
    cmp %rdi, %r8
    jae prime_yes
    mov %rdi, %rax
    mov $0, %rdx
    div %r8
    cmp $0, %rdx
    je prime_no
    inc %r8
    jmp prime_loop

#return 0 if not prime
prime_no:
    mov $0, %rax
    ret

#return 1 if prime
prime_yes:
    mov $1, %rax
    ret


#find the largest unsigned power without overflow
largest_power_unsigned:
    #start with 1 and handle 0 and 1
    mov $1, %rax
    cmp $1, %rdi
    jbe power_small

power_loop:
    #save the previous result
    mov %rax, %r8

    #multiply and check for overflow
    mul %rdi
    jc power_done

    #keep multiplying if no overflow
    jmp power_loop

power_done:
    #return the last valid power
    mov %r8, %rax
    ret

power_small:
    mov %rdi, %rax
    ret



#subtract two signed numbers
overflowing_subtract:
    #calculate a - b
    mov %rdi, %rax
    sub %rsi, %rax

    #check if signed overflow happened
    jno subtract_done

    #return 0 if there was overflow
    mov $0, %rax

subtract_done:
    ret




#recursive function using a and b
dumb:
    #check the first base case
    cmp $0, %rdi
    je dumb_a_zero

    #check the second base case
    cmp $0, %rsi
    je dumb_b_zero

    #save the original values on the stack
    push %rdi
    push %rsi

    #align stack
    sub $8, %rsp

    #call dumb with a - 1 and b - 1
    dec %rdi
    dec %rsi
    call dumb

    #restore the stack
    add $8, %rsp
    pop %rsi
    pop %rdi

    #add a + a + b to the recursive result
    add %rdi, %rax
    add %rdi, %rax
    add %rsi, %rax

    ret

dumb_a_zero:
    #return b + 1 if a is 0
    mov %rsi, %rax
    inc %rax
    ret

dumb_b_zero:
    #return a if b is 0
    mov %rdi, %rax
    ret
