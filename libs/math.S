.section .literal, "ax"
.align 4

.section .text
.global power, square, 

.type power, @function
power:
    entry   a1, 32
    beqz    a3, .L_power_zero

    mov     a4, a3
    mov     a5, a2
    movi    a2, 1

.L_power_loop:
    mull    a2, a2, a5
    addi    a4, a4, -1
    bnez    a4, .L_power_loop

    retw

.L_power_zero:
    movi    a2, 1
    retw

.type square, @function
square:
    entry   a1, 32
    mull    a2, a2, a2
    retw