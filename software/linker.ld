SECTIONS
{
    . = 0x80000000;
    .text : { *(.text) }
    
  	. = ALIGN(0x1000);
    .rodata : { *(.rodata) }
    .bss : { *(.bss) }
    .sbss : { *(.sbss) }


    . = 0x8000f000;
    .stack : { *(.stack) }

    . = 0x8000ff00;
    .sdata : { *(.sdata) }
}