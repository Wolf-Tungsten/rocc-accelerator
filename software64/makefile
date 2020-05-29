all: baremetal.elf #program.txt 

CXX=/home/wolf/riscv-gnu-toolchain/toolchain/bin/riscv64-unknown-elf-gcc
LIB1=/home/wolf/riscv-gnu-toolchain/toolchain/riscv64-unknown-elf-gcc/lib
LIB2=/home/wolf/riscv-gnu-toolchain/toolchain/lib/gcc/riscv64-unknown-elf/9.2.0
driver_dir = ./driver

c_driver =  				\
$(driver_dir)/uart.c 		\
$(driver_dir)/myprintf.c 	\

common_src= \
./head.S \

include_dir = ./include

gcc_args = -march=rv64imac -mabi=lp64 -mcmodel=medany  -fno-builtin-printf -ffast-math  -O0

baremetal.elf: linker.ld $(common_src) baremetal.c convolution.c activate.c maxpool.c $(c_driver) $(include_dir)  # devicetree.dtb
	$(CXX) $(gcc_args) -I $(driver_dir) -I $(include_dir) $(common_src) baremetal.c convolution.c activate.c maxpool.c $(c_driver) -static -nostdlib -nostartfiles -lm -lgcc -ffast-math -o $@ -T linker.ld

mem.elf: linker.ld head.S mem.c $(c_driver)
	riscv64-unknown-elf-gcc -march=rv64imac -mabi=lp64 -mcmodel=medany -nostdlib -static -fno-builtin-printf -T linker.ld -I $(driver_dir) -I $(include_dir) head.S mem.c $(c_driver) -o $@

clean:
	-rm *.elf

refresh:
	make clean && make all