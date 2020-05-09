#include <stdint.h>
#include <stddef.h>
#include "myprintf.h"
#include "uart.h"
#include "convolution.h"

int main (void){
    uart_init();
    printf("Hello, RISC-V!\n\r", 0);
    convTest();
    printf("Test Done!\n\r", 0);
    return 0;
}