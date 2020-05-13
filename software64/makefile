all: baremetal.elf #program.txt 


driver_dir = ./driver

c_driver =  				\
$(driver_dir)/uart.c 		\
$(driver_dir)/myprintf.c 	\

include_dir = ./include

baremetal.elf: linker.ld head.S baremetal.c convolution.c $(c_driver)  # devicetree.dtb
	riscv32-unknown-elf-gcc -nostdlib -static -fno-builtin-printf -T linker.ld -I $(driver_dir) -I $(include_dir) head.S baremetal.c convolution.c $(c_driver) -o $@ 

mem.elf: linker.ld head.S mem.c $(c_driver)
	riscv64-unknown-elf-gcc -march=rv64imac -mabi=lp64 -mcmodel=medany -nostdlib -static -fno-builtin-printf -T linker.ld -I $(driver_dir) -I $(include_dir) head.S mem.c $(c_driver) -o $@

clean:
	-rm *.elf

refresh:
	make clean && make all