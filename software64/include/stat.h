#ifndef STAT_H
#define STAT_H

#define read_csr(reg) ({ uint64_t __tmp; \
  asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
  __tmp; })

#define rdmcycle() read_csr(0xb00)
#define rdminstret() read_csr(0xb02)

#endif