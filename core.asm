.section .text
.globl main
.p2align 3

main:
    mov     x19, x1

    ldr     x22, [x19, #0x40]
    ldr     x20, [x19, #0x30]

    mov     x0, x22
    adrp    x1, HelloStr
    add     x1, x1, :lo12:HelloStr
    bl      PrintString

PromptLoop:
    mov     x0, x22
    adrp    x1, PromptStr
    add     x1, x1, :lo12:PromptStr
    bl      PrintString

    adrp    x23, InputBuffer
    add     x23, x23, :lo12:InputBuffer

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

    mov     w2, #0
    strh    w25, [x1]
    strh    w2,  [x1, #2]
    mov     x0, x22
    bl      PrintString

    strh    w25, [x23]
    add     x23, x23, #2
    b       ReadCharLoop

ExecuteCommand:
    mov     w2, #0
    strh    w2, [x23]

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

    mov     x0, x22
    adrp    x1, ExecutedStr
    add     x1, x1, :lo12:ExecutedStr
    bl      PrintString
    b       PromptLoop

DoHelp:
    mov     x0, x22
    adrp    x1, HelpMsgStr
    add     x1, x1, :lo12:HelpMsgStr
    bl      PrintString
    b       PromptLoop

PrintString:
    ldr     x3, [x0, #0x08]
    blr     x3
    ret

StrCmp16:
    ldrh    w2, [x0], #2
    ldrh    w3, [x1], #2

    cmp     w2, w3
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
    .hword 'U', 'n', 'k', 'n', 'o', 'w', 'n', ' '
    .hword 'c', 'o', 'm', 'm', 'a', 'n', 'd', '.', 13, 10, 0

HelpMsgStr:
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', ' '
    .hword 'H', 'e', 'l', 'p', ':', 13, 10
    .hword ' ', ' ', 'h', 'e', 'l', 'p', ' '
    .hword '-', ' ', 's', 'h', 'o', 'w', ' '
    .hword 't', 'h', 'i', 's', ' '
    .hword 'm', 'e', 's', 's', 'a', 'g', 'e', 13, 10, 0

CmdHelp:
    .hword 'h', 'e', 'l', 'p', 0

KeyBuffer:
    .hword 0, 0, 0

InputBuffer:
    .space 256