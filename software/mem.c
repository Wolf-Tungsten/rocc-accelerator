#include <stdint.h>
#include <stddef.h>
#include "myprintf.h"
#include "uart.h"

int32_t featureData[32*32];
int32_t filterData[3*3];

int main (void){
    uart_init();
    printf("Hello RISCV\n\r", 0);
    //*(uint32_t *)(0x80000800) = 0xdeadbeef;
    printf("%h\n\r", *(uint32_t *)(0x80000000));
    printf("Test Done!\n\r", 0);
}