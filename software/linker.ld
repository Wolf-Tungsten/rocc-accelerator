SECTIONS
{
    . = 0x80000000;
    .text : { *(.text) }
    
  	. = ALIGN(0x1000);
    .rodata : { *(.rodata) }
    .bss : { *(.bss) }
    .sbss : { *(.sbss) }


    . = 0x800f0000;
    .stack : { *(.stack) }

    . = 0x800ff000;
    .sdata : { *(.sdata) }
}