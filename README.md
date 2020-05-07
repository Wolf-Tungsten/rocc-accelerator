# rocc-accelerator
毕设项目

# 生成模拟器
```make CONFIG=grh.config.GRHRV32EmulatorConfig ROCKETCHIP_ADDONS=rocc-accelerator/accelerator```
```make verilog CONFIG=grh.config.GRHRV32FPGAConfig ROCKETCHIP_ADDONS=rocc-accelerator/accelerator```

# 编译模拟器程序
```riscv32-unknown-elf-gcc -I/home/wolf/rocket-tools/riscv-tests/build/../benchmarks/../env -I/home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common -I/home/wolf/rocket-tools/toolchain/riscv32-unknown-elf/include -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -o accumulator.riscv ./accumulator.c /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/syscalls.c /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/crt.S -static -nostdlib -nostartfiles -lm -lgcc -T /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/test.ld```

```riscv32-unknown-elf-gcc -I/home/wolf/rocket-tools/riscv-tests/build/../benchmarks/../env -I/home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common -I/home/wolf/rocket-tools/toolchain/riscv32-unknown-elf/include -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -o convolution.riscv ./convolution.c /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/syscalls.c /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/crt.S -static -nostdlib -nostartfiles -lm -lgcc -T /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/test.ld```

```riscv64-unknown-elf-gcc  -march=rv32im -I/home/wolf/rocket-tools/riscv-tests/build/../benchmarks/../env -I/home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common -I/home/wolf/rocket-tools/toolchain/riscv32-unknown-elf/include -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -o accumulator.riscv ./accumulator.c /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/syscalls.c /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/crt.S -static -nostdlib -nostartfiles -lm -lgcc -T /home/wolf/rocket-tools/riscv-tests/build/../benchmarks/common/test.ld```