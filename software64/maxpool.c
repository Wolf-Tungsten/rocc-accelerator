#include <stdint.h>
#include "./include/maxpool.h"
#include "myprintf.h"

uint64_t row0[MAX_POOL_SIZE / 8];
uint64_t row1[MAX_POOL_SIZE / 8];

void maxpoolTest(){
    printf("****** Maxpool Rocc Test ******\n\r",0);
    printf("[INFO] Init test data...\n\r",0);
    for(int i=0; i < MAX_POOL_SIZE; i++){
        ((int8_t *)row0)[i] = i;
        ((int8_t *)row1)[i] = i*2;
    }
    printf("[INFO] Load Row0...\n\r",0);
    doLoadMaxpoolRow0(row0);
    printf("[INFO] Load Row1...\n\r",0);
    doLoadMaxpoolRow1(row1);
    printf("[INFO] Do maxpool...\n\r",0);
    uint64_t result;
    doMaxpool(result);
    for(int i=0; i < MAX_POOL_SIZE / 2; i++){
        printf("[RESULT] pos:%d,", i);
        printf("result:%d\n\r", (int8_t)((result >> (i*8)) & 0xFF));
    }
}