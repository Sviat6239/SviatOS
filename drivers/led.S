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