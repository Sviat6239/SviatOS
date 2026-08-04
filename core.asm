.section .text
.globl main
.p2align 3

main:
    mov     x9, x1

    ldr     x2, [x9, #0x40]

    ldr     x3, [x2, #0x08]

    mov     x0, x2
    adrp    x1, HelloStr
    add     x1, x1, :lo12:HelloStr

    blr     x3

    mov     x0, #0
    ret

.section .data
.p2align 1

HelloStr:
    .hword 'W', 'e', 'l', 'c', 'o', 'm', 'e', ' '
    .hword 't', 'o', ' '
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', ' '
    .hword 'v', 'e', 'r', ' '
    .hword '0', '.', '0', '.', '1', '!', 13, 10, 0