.include "include/gpio.inc"
.include "include/registers.inc"

.section .literal, "ax"
.align 4

.section .text.main
.global main
.type main, @function

main:
    entry a1, 32
    
_kernelLoop:
    j _kernelLoop