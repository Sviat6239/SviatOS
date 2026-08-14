.section .text._start
.global _start
.type _start, @function

_start:
    l32r    a1, .L_STACK_TOP
    movi    a0, 0

    l32r    a2, .L_TG0_WDT_WP
    l32r    a3, .L_WDT_KEY
    s32i    a3, a2, 0

    l32r    a2, .L_TG0_WDT_CFG0
    movi    a3, 0
    s32i    a3, a2, 0

    l32r    a2, .L_TG1_WDT_WP
    l32r    a3, .L_WDT_KEY
    s32i    a3, a2, 0

    l32r    a2, .L_TG1_WDT_CFG0
    movi    a3, 0
    s32i    a3, a2, 0

    l32r    a2, .L_RTC_WDT_WP
    l32r    a3, .L_WDT_KEY
    s32i    a3, a2, 0

    l32r    a2, .L_RTC_WDT_CFG0
    movi    a3, 0
    s32i    a3, a2, 0

    l32r    a2, .L_RTC_SWD_WP
    l32r    a3, .L_SWD_KEY
    s32i    a3, a2, 0

    l32r    a2, .L_RTC_SWD_CFG
    l32r    a3, .L_SWD_DISABLE_VAL
    s32i    a3, a2, 0

    call0   main

1:  j       1b

.section .literal._start, "ax"
.align 4
.L_STACK_TOP:           .word 0x3FC90000

.L_WDT_KEY:             .word 0x50D83AA1
.L_SWD_KEY:             .word 0x123B54D

# TG0 / TG1
.L_TG0_WDT_CFG0:        .word 0x6001F048
.L_TG0_WDT_WP:          .word 0x6001F064
.L_TG1_WDT_CFG0:        .word 0x60020048
.L_TG1_WDT_WP:          .word 0x60020064

# RTC WDT
.L_RTC_WDT_CFG0:        .word 0x60008090
.L_RTC_WDT_WP:          .word 0x600080A4

# SWD (Super WDT)
.L_RTC_SWD_CFG:         .word 0x600080AC
.L_RTC_SWD_WP:          .word 0x600080B0
.L_SWD_DISABLE_VAL:     .word 0xE0000000