// THE BOOTLOADER

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

    ldr     x22, [x19, #0x40]    // x22 = EFI_SYSTEM_TABLE->ConOut
    ldr     x20, [x19, #0x30]    // x20 = EFI_SYSTEM_TABLE->ConIn

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

    cmp     w25, #8
    b.eq    HandleBackspace
    cmp     w25, #127
    b.eq    HandleBackspace

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

HandleBackspace:
    cbz     x24, ReadCharLoop

    sub     x23, x23, #2
    sub     x24, x24, #1

    mov     x0, x22
    adrp    x1, BackspaceStr
    add     x1, x1, :lo12:BackspaceStr
    bl      PrintString
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

    // If unknown command
    cbz     w24, PromptLoop
    mov     x0, x22
    adrp    x1, ExecutedStr
    add     x1, x1, :lo12:ExecutedStr
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
.p2align 3

HelloStr:
    .hword 'W', 'e', 'l', 'c', 'o', 'm', 'e', ' '
    .hword 't', 'o', ' '
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', ' ', 13, 10, 0

PromptStr:
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', '>', ' ', 0

NewLineStr:
    .hword 13, 10, 0

BackspaceStr:
    .hword 8, ' ', 8, 0

ExecutedStr:
    .hword 'U', 'n', 'k', 'n', 'o', 'w', 'n', ' '
    .hword 'c', 'o', 'm', 'm', 'a', 'n', 'd', '.', 13, 10, 0

CmdExit:
    .hword '-', 'e', 'x', 'i', 't', 0

.p2align 3
KeyBuffer:      .hword 0, 0, 0
InputBuffer:    .space 1024