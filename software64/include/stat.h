#ifndef STAT_H
#define STAT_H

#define read_csr(reg) ({ uint32_t __tmp; \
  asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
  __tmp; })

#define rdtime() read_csr(0xc01)
#define rdcycle() read_csr(0xc00)
#define rdinstret() read_csr(0xc02)

#endif