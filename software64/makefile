all: baremetal.elf #program.txt 


driver_dir = ./driver

c_driver =  				\
$(driver_dir)/uart.c 		\
$(driver_dir)/myprintf.c 	\

common_src= \
./head.S \

include_dir = ./include

gcc_args = -march=rv64imac -mabi=lp64 -mcmodel=medany -nostdlib -static -fno-builtin-printf -nostartfiles

baremetal.elf: linker.ld $(common_src) baremetal.c convolution.c activate.c maxpool.c $(c_driver) $(include_dir)  # devicetree.dtb
	riscv64-unknown-elf-gcc $(gcc_args) -T linker.ld -I $(driver_dir) -I $(include_dir) $(common_src) baremetal.c convolution.c activate.c maxpool.c $(c_driver) -o $@ 

mem.elf: linker.ld head.S mem.c $(c_driver)
	riscv64-unknown-elf-gcc -march=rv64imac -mabi=lp64 -mcmodel=medany -nostdlib -static -fno-builtin-printf -T linker.ld -I $(driver_dir) -I $(include_dir) head.S mem.c $(c_driver) -o $@

clean:
	-rm *.elf

refresh:
	make clean && make all