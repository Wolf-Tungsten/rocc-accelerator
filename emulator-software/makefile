

include_dir = ./include


common_src = \
./common/crt.S	\
./common/syscalls.c \

ld = ./common/test.ld

gcc_args = -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -march=rv64imac -mabi=lp64 -static -nostdlib -nostartfiles -lm -lgcc

hello.elf: $(ld) $(common_src) hello.c
	riscv64-unknown-elf-gcc $(gcc_args) -T $(ld) -I $(include_dir) $(common_src) hello.c -o $@ 

convolution.elf: $(ld) $(common_src) convolution.c
	riscv64-unknown-elf-gcc $(gcc_args) -T $(ld) -I $(include_dir) $(common_src) convolution.c -o $@

activate.elf: $(ld) $(common_src) activate.c
	riscv64-unknown-elf-gcc $(gcc_args) -T $(ld) -I $(include_dir) $(common_src) activate.c -o $@

mem-test.elf: linker.ld head.S mem.c $(c_driver)
	riscv64-unknown-elf-gcc -march=rv64imac -mabi=lp64 -mcmodel=medany -nostdlib -static -fno-builtin-printf -T linker.ld -I $(driver_dir) -I $(include_dir) head.S mem.c $(c_driver) -o $@

clean:
	-rm *.elf

refresh:
	make clean && make all