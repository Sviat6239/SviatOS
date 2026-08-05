.section .text
.globl main
.p2align 3

main:
    stp     x29, x30, [sp, #-80]!
    mov     x29, sp
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]
    stp     x23, x24, [sp, #48]
    stp     x25, x26, [sp, #64]

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

    mov     x24, #0              

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

    cbz     w25, ReadCharLoop

    cmp     w25, #13
    b.eq    ExecuteCommand

    mov     w26, #500
    cmp     w24, w26
    b.hs    ReadCharLoop

    mov     w2, #0
    strh    w25, [x1]
    strh    w2,  [x1, #2]
    mov     x0, x22
    bl      PrintString

    strh    w25, [x23]
    add     x23, x23, #2
    add     x24, x24, #1
    b       ReadCharLoop

ExecuteCommand:
    mov     w2, #0
    strh    w2, [x23]

    mov     x0, x22
    adrp    x1, NewLineStr
    add     x1, x1, :lo12:NewLineStr
    bl      PrintString

    // Compare to'-exit'
    adrp    x0, InputBuffer
    add     x0, x0, :lo12:InputBuffer
    adrp    x1, CmdExit
    add     x1, x1, :lo12:CmdExit
    bl      StrCmp16
    cbz     w0, ExitShell

    // Compare to '-help'
    adrp    x0, InputBuffer
    add     x0, x0, :lo12:InputBuffer
    adrp    x1, CmdHelp
    add     x1, x1, :lo12:CmdHelp
    bl      StrCmp16
    cbz     w0, DoHelp

    // Compare to '-ver'
    adrp    x0, InputBuffer
    add     x0, x0, :lo12:InputBuffer
    adrp    x1, CmdVersion
    add     x1, x1, :lo12:CmdVersion
    bl      StrCmp16
    cbz     w0, DoVersion

    cbz     w24, PromptLoop
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

DoVersion:
    mov     x0, x22
    adrp    x1, VersionMsg
    add     x1, x1, :lo12:VersionMsg
    bl      PrintString
    b       PromptLoop

ExitShell:
    mov     x0, #0

    ldp     x25, x26, [sp, #64]
    ldp     x23, x24, [sp, #48]
    ldp     x21, x22, [sp, #32]
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #80
    ret

PrintString:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    ldr     x3, [x0, #0x08]
    blr     x3

    ldp     x29, x30, [sp], #16
    ret

StrCmp16:
    
StrCmp16_Loop:
    ldrh    w2, [x0], #2
    ldrh    w3, [x1], #2

    cmp     w2, w3
    b.ne    StrCmp_Diff

    cbz     w2, StrCmp_Equal
    b       StrCmp16_Loop

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
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', ' ', 13, 10, 0

PromptStr:
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', '>', ' ', 0

NewLineStr:
    .hword 13, 10, 0

ExecutedStr:
    .hword 'U', 'n', 'k', 'n', 'o', 'w', 'n', ' '
    .hword 'c', 'o', 'm', 'm', 'a', 'n', 'd', '.', 13, 10, 0

HelpMsgStr:
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', ' '
    .hword 'C', 'o', 'm', 'm', 'a', 'n', 'd', 's', ':', 13, 10
    .hword ' ', ' ', '-', 'h', 'e', 'l', 'p', ' '
    .hword '-', ' ', 's', 'h', 'o', 'w', ' '
    .hword 't', 'h', 'i', 's', ' '
    .hword 'm', 'e', 's', 's', 'a', 'g', 'e', 13, 10
    .hword ' ', ' ', '-', 'v', 'e', 'r', ' '
    .hword ' ', '-', ' ', 's', 'h', 'o', 'w', ' '
    .hword 'v', 'e', 'r', 's', 'i', 'o', 'n', 13, 10
    .hword ' ', ' ', '-', 'e', 'x', 'i', 't', ' '
    .hword '-', ' ', 'e', 'x', 'i', 't', ' '
    .hword 's', 'h', 'e', 'l', 'l', 13, 10, 0

CmdHelp:
    .hword '-', 'h', 'e', 'l', 'p', 0

CmdVersion:
    .hword '-', 'v', 'e', 'r', 0

CmdExit:
    .hword '-', 'e', 'x', 'i', 't', 0

VersionMsg:
    .hword 'K', 'e', 'r', 'n', 'e', 'l', ':' , ' ', '0', '.', '0', '.', '2', 13, 10
    .hword 'S', 'h', 'e', 'l', 'l', ':', ' ', '0', '.', '0', '.', '1', 13, 10, 0

KeyBuffer:
    .hword 0, 0, 0

InputBuffer:
    .space 1024