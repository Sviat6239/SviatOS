//SHELL

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

    // Compare to '-sysfetch'
    adrp    x0, InputBuffer
    add     x0, x0, :lo12:InputBuffer
    adrp    x1, CmdSysFetch
    add     x1, x1, :lo12:CmdSysFetch
    bl      StrCmp16
    cbz     w0, DoSysFetch

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

DoSysFetch:
    stp     x29, x30, [sp, #-48]!
    mov     x29, sp
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]

    mov     x0, x22
    adrp    x1, FetchHeader
    add     x1, x1, :lo12:FetchHeader
    bl      PrintString

    mov     x0, x22
    adrp    x1, FetchOS
    add     x1, x1, :lo12:FetchOS
    bl      PrintString

    mov     x0, x22
    adrp    x1, FetchFirmware
    add     x1, x1, :lo12:FetchFirmware
    bl      PrintString

    ldr     x1, [x19, #0x18]
    mov     x0, x22
    bl      PrintString

    mov     x0, x22
    adrp    x1, NewLineStr
    add     x1, x1, :lo12:NewLineStr
    bl      PrintString

    mov     x0, x22
    adrp    x1, FetchCPU
    add     x1, x1, :lo12:FetchCPU
    bl      PrintString

    mrs     x0, MIDR_EL1
    adrp    x1, NumBuffer
    add     x1, x1, :lo12:NumBuffer
    bl      UIntToHexStr16

    mov     x0, x22
    adrp    x1, NumBuffer
    add     x1, x1, :lo12:NumBuffer
    bl      PrintString

    mov     x0, x22
    adrp    x1, NewLineStr
    add     x1, x1, :lo12:NewLineStr
    bl      PrintString

    ldr     x20, [x19, #0x60]    // x20 = BootServices

    adrp    x0, MemMapSize
    add     x0, x0, :lo12:MemMapSize
    mov     x1, #16384
    str     x1, [x0]

    adrp    x0, MemMapSize
    add     x0, x0, :lo12:MemMapSize
    adrp    x1, MemMapBuffer
    add     x1, x1, :lo12:MemMapBuffer
    adrp    x2, MapKey
    add     x2, x2, :lo12:MapKey
    adrp    x3, DescSize
    add     x3, x3, :lo12:DescSize
    adrp    x4, DescVersion
    add     x4, x4, :lo12:DescVersion

    ldr     x5, [x20, #0x38]     // GetMemoryMap offset
    blr     x5

    cbnz    x0, FetchMemError

    adrp    x20, MemMapBuffer
    add     x20, x20, :lo12:MemMapBuffer
    adrp    x1, MemMapSize
    add     x1, x1, :lo12:MemMapSize
    ldr     x21, [x1]
    add     x21, x20, x21

    adrp    x1, DescSize
    add     x1, x1, :lo12:DescSize
    ldr     x22, [x1]

    mov     x23, #0              // TotalBytes
    mov     x24, #0              // FreeBytes

ParseMemLoop:
    cmp     x20, x21
    b.hs    ParseMemDone

    ldr     w25, [x20]
    ldr     x26, [x20, #24]
    lsl     x26, x26, #12

    cmp     w25, #1
    b.lt    NextDescriptor
    cmp     w25, #7
    b.gt    NextDescriptor

    add     x23, x23, x26

    cmp     w25, #7
    b.ne    NextDescriptor
    add     x24, x24, x26

NextDescriptor:
    add     x20, x20, x22
    b       ParseMemLoop

ParseMemDone:
    lsr     x23, x23, #20
    lsr     x24, x24, #20

    mov     x0, x22
    adrp    x1, FetchRAM
    add     x1, x1, :lo12:FetchRAM
    bl      PrintString

    mov     x0, x24
    adrp    x1, NumBuffer
    add     x1, x1, :lo12:NumBuffer
    bl      UIntToDecStr16

    mov     x0, x22
    adrp    x1, NumBuffer
    add     x1, x1, :lo12:NumBuffer
    bl      PrintString

    mov     x0, x22
    adrp    x1, RamSeparator
    add     x1, x1, :lo12:RamSeparator
    bl      PrintString

    mov     x0, x23
    adrp    x1, NumBuffer
    add     x1, x1, :lo12:NumBuffer
    bl      UIntToDecStr16

    mov     x0, x22
    adrp    x1, NumBuffer
    add     x1, x1, :lo12:NumBuffer
    bl      PrintString

    mov     x0, x22
    adrp    x1, RamSuffix
    add     x1, x1, :lo12:RamSuffix
    bl      PrintString

    mov     x0, x22
    adrp    x1, FetchCPULoad
    add     x1, x1, :lo12:FetchCPULoad
    bl      PrintString

FetchEnd:
    ldp     x21, x22, [sp, #32]
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #48
    b       PromptLoop

FetchMemError:
    mov     x0, x22
    adrp    x1, MemErrStr
    add     x1, x1, :lo12:MemErrStr
    bl      PrintString
    b       FetchEnd

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

// UIntToDecStr16(uint64_t val [x0], CHAR16 *buf [x1])
UIntToDecStr16:
    stp     x29, x30, [sp, #-32]!
    mov     x29, sp
    stp     x19, x20, [sp, #16]
    mov     x19, x1
    mov     x20, x0

    cbnz    x20, DecConvert
    mov     w2, #'0'
    strh    w2, [x19]
    mov     w2, #0
    strh    w2, [x19, #2]
    b       DecDone

DecConvert:
    mov     x2, x19
    mov     x3, #10
1:  cbz     x20, 2f
    udiv    x4, x20, x3
    msub    x5, x4, x3, x20
    add     w5, w5, #'0'
    strh    w5, [x2], #2
    mov     x20, x4
    b       1b
2:  mov     w5, #0
    strh    w5, [x2]

    // Reverse string
    mov     x3, x19
    sub     x4, x2, #2
3:  cmp     x3, x4
    b.hs    DecDone
    ldrh    w5, [x3]
    ldrh    w6, [x4]
    strh    w6, [x3], #2
    strh    w5, [x4], #-2
    b       3b

DecDone:
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #32
    ret

// UIntToHexStr16(uint64_t val [x0], CHAR16 *buf [x1])
UIntToHexStr16:
    stp     x29, x30, [sp, #-32]!
    mov     x29, sp
    stp     x19, x20, [sp, #16]
    mov     x19, x1
    mov     x20, x0

    // '0x' prefix
    mov     w2, #'0'
    strh    w2, [x19], #2
    mov     w2, #'x'
    strh    w2, [x19], #2

    mov     x2, #60

HexLoop:
    lsr     x3, x20, x2
    and     x3, x3, #0xF
    cmp     x3, #10
    b.lt    HexDigit
    add     x3, x3, #('A' - 10)
    b       HexStore

HexDigit:
    add     x3, x3, #'0'

HexStore:
    strh    w3, [x19], #2
    subs    x2, x2, #4
    b.ge    HexLoop

    mov     w2, #0
    strh    w2, [x19]

    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #32
    ret

.section .data
.p2align 3

PromptStr:
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', '>', ' ', 0

NewLineStr:
    .hword 13, 10, 0

BackspaceStr:
    .hword 8, ' ', 8, 0

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
    .hword ' ', ' ', '-', 's', 'y', 's', 'f', 'e', 't', 'c', 'h', ' '
    .hword '-', ' ', 's', 'h', 'o', 'w', ' '
    .hword 's', 'y', 's', 't', 'e', 'm', ' '
    .hword 'i', 'n', 'f', 'o', 13, 10
    .hword ' ', ' ', '-', 'e', 'x', 'i', 't', ' '
    .hword '-', ' ', 'e', 'x', 'i', 't', ' '
    .hword 's', 'h', 'e', 'l', 'l', 13, 10, 0

CmdHelp:
    .hword '-', 'h', 'e', 'l', 'p', 0

CmdVersion:
    .hword '-', 'v', 'e', 'r', 0

CmdSysFetch:
    .hword '-', 's', 'y', 's', 'f', 'e', 't', 'c', 'h', 0

CmdExit:
    .hword '-', 'e', 'x', 'i', 't', 0

VersionMsg:
    .hword 'K', 'e', 'r', 'n', 'e', 'l', ':' , ' ', '0', '.', '0', '.', '2', 13, 10
    .hword 'S', 'h', 'e', 'l', 'l', ':', ' ', '0', '.', '0', '.', '1', 13, 10, 0

FetchHeader:
    .hword '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', 13, 10
    .hword ' ', ' ', 'S', 'v', 'i', 'a', 't', 'O', 'S', ' '
    .hword 'S', 'y', 's', 't', 'e', 'm', ' '
    .hword 'F', 'e', 't', 'c', 'h', 13, 10
    .hword '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', '=', 13, 10, 0

FetchOS:
    .hword 'O', 'S', ':', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
    .hword 'S', 'v', 'i', 'a', 't', 'O', 'S', ' '
    .hword '(', 'A', 'A', 'r', 'c', 'h', '6', '4', ' ', 'U', 'E', 'F', 'I', ')', 13, 10, 0

FetchFirmware:
    .hword 'F', 'i', 'r', 'm', 'w', 'a', 'r', 'e', ':', ' '
    .hword 'U', 'E',102, 'I', ' ', 'b', 'y', ' ', 0

FetchCPU:
    .hword 'C', 'P', 'U', ' ', 'M', 'I', 'D', 'R', ':', ' '
    .hword 'A', 'R', 'M', '6', '4', ' ', '(', 0

FetchRAM:
    .hword 'M', 'e', 'm', 'o', 'r', 'y', ':', ' ', ' ', ' '
    .hword 'F', 'r', 'e', 'e', ' ', 0

RamSeparator:
    .hword ' ', 'M', 'B', ' ', '/', ' ', 0

RamSuffix:
    .hword ' ', 'M', 'B', ' ', 'T', 'o', 't', 'a', 'l', 13, 10, 0

FetchCPULoad:
    .hword 'C', 'P', 'U', ' ', 'L', 'o', 'a', 'd', ':', ' '
    .hword '1', ' ', 'C', 'o', 'r', 'e', ' '
    .hword 'A', 'c', 't', 'i', 'v', 'e', ' '
    .hword '(', 'B', 'a', 'r', 'e', '-', 'M', 'e', 't', 'a', 'l', ')', 13, 10, 0

MemErrStr:
    .hword 'F', 'a', 'i', 'l', 'e', 'd', ' '
    .hword 't', 'o', ' '
    .hword 'r', 'e', 'a', 'd', ' '
    .hword 'U', 'E', 'F', 'I', ' '
    .hword 'M', 'e', 'm', 'o', 'r', 'y', ' '
    .hword 'M', 'a', 'p', 13, 10, 0


.p2align 3
MemMapSize:     .quad 16384
MapKey:         .quad 0
DescSize:       .quad 0
DescVersion:    .word 0

KeyBuffer:      .hword 0, 0, 0
NumBuffer:      .space 64
InputBuffer:    .space 1024
MemMapBuffer:   .space 16384