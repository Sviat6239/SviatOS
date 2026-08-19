.include "./include/registers.inc"

.equ LED_GPIO_NUM,           48
.equ GPIO_OUT_W1TS_REG,      0x60004014
.equ GPIO_OUT_W1TC_REG,      0x60004018
.equ GPIO_ENABLE_W1TS_REG,   0x60004030

.section .literal, "ax"
.align 4

.L_rmt_base:                .word RMT_BASE
.L_rmt_ram_ch0:             .word RMT_RAM_CH0_BASE
.L_sys_clk_en:              .word SYSTEM_PERIP_CLK_EN0_REG
.L_gpio_mux_reg:            .word (GPIO_FUNC0_OUT_SEL_REG + (LED_GPIO_NUM * 4))

.L_GPIO_ENABLE_W1TS:        .word GPIO_ENABLE_W1TS_REG
.L_LED_GPIO_MASK:           .word (1 << (LED_GPIO_NUM - 32))

.section .text
.global led_init, led_turn_on, led_turn_off

.type led_init, @function
led_init:
    entry a1, 32

    #init clock
    l32r a2, .L_sys_clk_en
    l32i a3, a2, 0
    movi a4, 1
    or   a3, a3, a4
    s32i a3, a2, 0

    #enable led gpio
    l32r a4, .L_GPIO_ENABLE_W1TS
    l32r a5, .L_LED_GPIO_MASK
    s32i a5, a4, 0

    retw

.type led_turn_on, @function
led_turn_on:
    entry a1, 32

    retw

.type led_turn_off, @function
led_turn_off:
    entry a1, 32

    retw