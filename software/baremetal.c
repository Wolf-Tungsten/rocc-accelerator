#include <stdint.h>
#include <stddef.h>
#include "myprintf.h"
#include "uart.h"


int main (void){
    uart_init();
    printf("Hello, RISC-V!\n\r", 0);
}