# ==============================================================================
# ESP32-S3 System & Peripheral Registers Map
# Target: ESP32-S3 (Xtensa LX7 Dual-Core)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. System Clocks, Resets & PCR (Peripheral Clock & Reset)
# ------------------------------------------------------------------------------
.equ DR_REG_SYSTEM_BASE,            0x600C0000
.equ SYSTEM_SYSCLK_CONF_REG,        0x600C0000
.equ SYSTEM_CPU_PERI_CLK_EN_REG,    0x600C0004
.equ SYSTEM_PERIP_CLK_EN0_REG,      0x600C0018
.equ SYSTEM_PERIP_CLK_EN1_REG,      0x600C001C
.equ SYSTEM_PERIP_RST_EN0_REG,      0x600C0020
.equ SYSTEM_PERIP_RST_EN1_REG,      0x600C0024
.equ SYSTEM_MEM_PD_MASK_REG,        0x600C0098
.equ SYSTEM_PERIP_CLK_ENABLE_REG,   0x600C00C0

# ------------------------------------------------------------------------------
# 2. Interrupt Matrix (Core 0 & Core 1)
# ------------------------------------------------------------------------------
.equ INTERRUPT_CORE0_BASE,          0x600C2000
.equ INTERRUPT_CORE1_BASE,          0x600C2400
.equ INT_CORE0_CPU_INT_ENABLE_REG,  0x600C2104
.equ INT_CORE0_CPU_INT_TYPE_REG,    0x600C210C
.equ INT_CORE0_CPU_INT_EIP_STATUS_REG, 0x600C2114

# ------------------------------------------------------------------------------
# 3. Cache, MMU & ExtRAM (Octal PSRAM / Flash Controller)
# ------------------------------------------------------------------------------
.equ EXTMEM_BASE,                   0x600C4000
.equ EXTMEM_CACHE_CONF_REG,         0x600C4000
.equ EXTMEM_CACHE_MMU_POWER_CTRL_REG, 0x600C4008
.equ EXTMEM_DCACHE_CTRL_REG,        0x600C4014
.equ EXTMEM_DCACHE_CTRL1_REG,       0x600C4018
.equ EXTMEM_DCACHE_TAG_POWER_CTRL_REG, 0x600C4020
.equ EXTMEM_SPI_SMEM_TIMING_CONFIG_REG, 0x600C40A0

# ------------------------------------------------------------------------------
# 4. USB Serial / JTAG Controller (Native USB Console)
# ------------------------------------------------------------------------------
.equ USB_SERIAL_JTAG_BASE,          0x60043000
.equ USB_SERIAL_JTAG_EP1_REG,       0x60043000
.equ USB_SERIAL_JTAG_EP1_CONF_REG,  0x60043004
.equ USB_SERIAL_JTAG_INT_RAW_REG,   0x60043008
.equ USB_SERIAL_JTAG_INT_ST_REG,    0x6004300C
.equ USB_SERIAL_JTAG_INT_ENA_REG,   0x60043010
.equ USB_SERIAL_JTAG_INT_CLR_REG,   0x60043014
.equ USB_SERIAL_JTAG_CONF0_REG,     0x60043018

# ------------------------------------------------------------------------------
# 5. UART0 (Hardware Serial)
# ------------------------------------------------------------------------------
.equ UART0_BASE,                    0x60000000
.equ UART0_FIFO_REG,                0x60000000
.equ UART0_INT_RAW_REG,             0x60000004
.equ UART0_INT_ST_REG,              0x60000008
.equ UART0_INT_ENA_REG,             0x6000000C
.equ UART0_INT_CLR_REG,             0x60000010
.equ UART0_CLKDIV_REG,              0x60000014
.equ UART0_STATUS_REG,              0x6000001C
.equ UART0_CONF0_REG,               0x60000020
.equ UART0_CONF1_REG,               0x60000024

# ------------------------------------------------------------------------------
# 6. General DMA Controller (GDMA - Channel 0)
# ------------------------------------------------------------------------------
.equ GDMA_BASE,                     0x6003F000
.equ GDMA_IN_INT_RAW_CH0_REG,       0x6003F000
.equ GDMA_IN_INT_ENA_CH0_REG,       0x6003F008
.equ GDMA_OUT_INT_RAW_CH0_REG,      0x6003F010
.equ GDMA_OUT_INT_ENA_CH0_REG,      0x6003F018
.equ GDMA_OUT_LINK_CH0_REG,         0x6003F054
.equ GDMA_IN_LINK_CH0_REG,          0x6003F030
.equ GDMA_MISC_CONF_REG,            0x6003F500

# ------------------------------------------------------------------------------
# 7. Timers & Watchdog (TIMG0 / TIMG1 / SysTimer)
# ------------------------------------------------------------------------------
.equ TIMG0_BASE,                    0x6001F000
.equ TIMG0_T0CONFIG_REG,            0x6001F000
.equ TIMG0_T0LO_REG,                0x6001F004
.equ TIMG0_T0HI_REG,                0x6001F008
.equ TIMG0_T0UPDATE_REG,            0x6001F00C
.equ TIMG0_WDTCONFIG0_REG,          0x6001F048
.equ TIMG0_WDTCONFIG1_REG,          0x6001F04C
.equ TIMG0_WDTFEED_REG,             0x6001F060

.equ SYSTIMER_BASE,                 0x60023000
.equ SYSTIMER_CONF_REG,             0x60023000
.equ SYSTIMER_UNIT0_OP_REG,         0x60023008

# ------------------------------------------------------------------------------
# 8. SPI2 (General Purpose SPI - GPSPI2)
# ------------------------------------------------------------------------------
.equ SPI2_BASE,                     0x60024000
.equ SPI2_CMD_REG,                  0x60024000
.equ SPI2_ADDR_REG,                 0x60024004
.equ SPI2_CTRL_REG,                 0x60024008
.equ SPI2_CLOCK_REG,                0x60024014
.equ SPI2_USER_REG,                 0x60024018
.equ SPI2_USER1_REG,                0x6002401C
.equ SPI2_USER2_REG,                0x60024020
.equ SPI2_MS_DLEN_REG,              0x60024024
.equ SPI2_W0_REG,                   0x60024098

# ------------------------------------------------------------------------------
# 9. I2C0 Controller
# ------------------------------------------------------------------------------
.equ I2C0_BASE,                     0x60013000
.equ I2C0_SCL_LOW_PERIOD_REG,       0x60013000
.equ I2C0_CTR_REG,                  0x60013004
.equ I2C0_SR_REG,                   0x60013008
.equ I2C0_TO_REG,                   0x6001300C
.equ I2C0_FIFO_CONF_REG,            0x60013014
.equ I2C0_DATA_FIFO_REG,            0x6001301C

# ------------------------------------------------------------------------------
# 10. RTC_CNTL (Power, Deep Sleep, Main System Reset)
# ------------------------------------------------------------------------------
.equ RTC_CNTL_BASE,                 0x60008000
.equ RTC_CNTL_OPTIONS0_REG,         0x60008000
.equ RTC_CNTL_SLP_TIMER0_REG,       0x60008004
.equ RTC_CNTL_STATE0_REG,           0x60008018
.equ RTC_CNTL_WDTCONFIG0_REG,       0x60008098
.equ RTC_CNTL_WDTFEED_REG,          0x600080A8
.equ RTC_CNTL_SW_SYS_RST_REG,       0x600080C0

# ------------------------------------------------------------------------------
# 11. EFUSE Controller (Chip Info, MAC Address)
# ------------------------------------------------------------------------------
.equ EFUSE_BASE,                    0x60007000
.equ EFUSE_PGM_DATA0_REG,           0x60007000
.equ EFUSE_RD_MAC_SPI_SYS_0_REG,    0x60007044