ENTRY(_start)

MEMORY
{
  iram0_seg (rx) : ORIGIN = 0x4037C000, LENGTH = 0x8000
  dram0_seg (rw) : ORIGIN = 0x3FC88000, LENGTH = 0x8000
}

SECTIONS
{
  .text : ALIGN(4)
  {
    _text_start = .;
    *(.literal._start .text._start)
    *(.literal .literal.* .text .text.*)
    . = ALIGN(4);
    _text_end = .;
  } > iram0_seg

  .data : ALIGN(4)
  {
    _data_start = .;
    *(.rodata .rodata.*)
    *(.data .data.*)
    . = ALIGN(4);
    _data_end = .;
  } > dram0_seg AT > iram0_seg

  .bss : ALIGN(4)
  {
    _bss_start = .;
    *(.bss .bss.* COMMON)
    . = ALIGN(4);
    _bss_end = .;
  } > dram0_seg

  /DISCARD/ :
  {
    *(.comment)
    *(.note.*)
    *(.eh_frame*)
  }
}