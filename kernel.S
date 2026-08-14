.section .text.main
.global main
.type main, @function

main:
_kernelLoop:

    j _kernelLoop