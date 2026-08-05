.section .text
.globl main
.p2align 3

main:
    mov     x9, x1

    ldr     x22, [x9, #0x40]

    ldr     x20, [x9, #0x08]

    mov     x0, x22
    adrp    x1, HelloStr
    add     x1, x1, :lo12:HelloStr
    blr     PrintString

PromptLoop:
    mov     x0, x22
    adrp    x1, PromptStr
    add     x1, x1, :lo12:PromptStr
    bl      PrintString

    adrp    x23, InputBuffer
    add     x23, x23, :lo12:InputBuffer
    mov     w24, #0

ReadCharLoop:
    ldr     x21, [x20, #0x08]
    mov     x0, x20
    adrp    x1, KeyBuffer
    add     x1, x1, :lo12:KeyBuffer
    blr     x21
    cbnz    x0, ReadCharLoop

    adrp    x1, KeyBuffer
    add     x1, x1, :lo12:KeyBuffer
    ldrh    w25, [x1, #2]

    cmp     w25, #13
    b.eq    ExecuteCommand

    cbz     w25, ReadCharLoop

    strh    w25, [x1]
    strh    w0, [x1, #2]
    mov     x0, x22
    blr     x22

    strh    w25, [x23]
    add     x23, x23, #2
    b       ReadCharLoop

ExecuteCommand:
    strh    w0, [x23]

    mov     x0, x22
    adrp    x1, NewLineStr
    add     x1, x1, :lo12:NewLineStr
    bl      PrintString

    adrp    x0, InputBuffer
    add     x0, x0, :lo12:InputBuffer

    adrp    x1, CmdHelp
    add     x1, x1, :lo12:CmdHelp

    bl      StrCmp16
    cbz     w0, DoHelp

PrintString:
    ldr     x3, [x0, #0x08]
    br      x3


StrCmp16:
    ldrh    w2, [x0], #2
    ldrh    w3, [x1], #2

    cmp     w, w3
    b.ne    StrCmp_Diff

    cbz     w2, StrCmp_Equal
    b       StrCmp16

StrCmp_Diff:
    mov     w0, #1
    ret

StrCmp_Equal:
    mov     w0, #0
    ret


.section .data
.p2align 1

HelloStr:
    .hword 'W', 'e', 'l', 'c', 'o', 'm', 'e', ' '
    .hword 't', 'o', ' '
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', ' '
    .hword 'v', 'e', 'r', ' '
    .hword '0', '.', '0', '.', '2', '!', 13, 10, 0

PromptStr:
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', '>', ' ', 0

NewLineStr:
    .hword 13, 10, 0

ExecutedStr:
    .hword '[', 'O', 'K', ']', 13, 10, 0

KeyBuffer:
    .hword 0, 0, 0

InputBuffer:
    .space 256

CmdHelp:
    .hword 'h', 'e', 'l', 'p', 0