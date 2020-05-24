SECTIONS
{
    . = 0x80000000;
    .text : { *(.text) }
    
  	. = ALIGN(0x1000);
    .rodata : { *(.rodata) }
    .bss : { *(.bss) }
    .sbss : { *(.sbss) }

/* currently we put dtb into the boot.elf image for debug convinence 	*/
/* so we do not need it here. generally it should be put into firmware 	*/
/*  . = ALIGN(0x1000);													*/
/*  .dtb : { *(.dtb) }													*/

    . = 0x80f00000;
    .stack : { *(.stack) }

    . = 0x80ff0000;
    .sdata : { *(.sdata) }
}
