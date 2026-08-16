.include "./include/registers.inc"

.equ LED_GPIO_NUM,           48
.equ GPIO_OUT_W1TS_REG,      0x60004008
.equ GPIO_ENABLE_W1TS_REG,   0x60004020

.section .literal, "ax"
.align 4

.L_rmt_base:        .word RMT_BASE
.L_rmt_ram_ch0:     .word RMT_RAM_CH0_BASE
.L_sys_clk_en:      .word SYSTEM_PERIP_CLK_EN0_REG
.L_gpio_mux_reg:    .word (GPIO_FUNC0_OUT_SEL_REG + (LED_GPIO_NUM * 4))

.section .text
.global led_init, led_turn_on, led_turn_off

.type led_init, @function
led_init:
    entry a1, 32

    retw

.type led_turn_on, @function
led_turn_on:
    entry a1, 32

    retw

.type led_turn_off, @function
led_turn_off:
    entry a1, 32

    retw