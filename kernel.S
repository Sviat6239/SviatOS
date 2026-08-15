.section .literal, "ax"
.align 4

.include "gpio.inc"

.section .text.main
.global main
.type main, @function

main:
_kernelLoop:

    j _kernelLoop