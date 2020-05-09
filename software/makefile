all: baremetal.elf #program.txt 


driver_dir = ./driver

c_driver =  				\
$(driver_dir)/uart.c 		\
$(driver_dir)/myprintf.c 	\



baremetal.elf: linker.ld head.S baremetal.c $(c_driver) # devicetree.dtb
	riscv32-unknown-elf-gcc -nostdlib -static -fno-builtin-printf -T linker.ld -I $(driver_dir) head.S baremetal.c $(c_driver) -o $@ 

clean:
	-rm baremetal.elf

refresh:
	make clean && make all