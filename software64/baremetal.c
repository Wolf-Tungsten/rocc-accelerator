#include <stdint.h>
#include <stddef.h>
#include "myprintf.h"
#include "uart.h"
#include "stat.h"
#include "convolution.h"
#include "activate.h"
#include "maxpool.h"

int main (void){
    uart_init();
    printf("Hello, RISC-V!\n\r", 0);
    initConvData();
    uint64_t startTime = rdmcycle();
    convBySoftware();
    printf("software mcycle:%d\n\r", rdmcycle()-startTime);
    startTime = rdmcycle();
    convByRocc();
    printf("hardware mcycle:%d\n\r", rdmcycle()-startTime);
    //printf("mcycle:%d\n\r", endTime-startTime);
    printf("Test Done!\n\r", 0);
    //while(1);
    return 0;
}
