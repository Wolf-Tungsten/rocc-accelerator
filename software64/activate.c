#include <stdint.h>
#include "./include/activate.h"
#include "myprintf.h"

// 64位地址对齐，每个 RoCC 内存请求获取两个 int32_t
uint64_t activateMap[ACTIVATE_RESOLUTION / 2];
uint64_t activateValue[ACTIVATE_RESOLUTION / 8];
int8_t relu(int32_t input);
#define SCALE ((int32_t)((int32_t)0x80000000 / (int8_t)0x80))

void activateTest(){
    printf("****** Activate Rocc Test ******\n\r",0);
    printf("[INFO] Init test data...\n\r",0);
    for(int i = 0; i < ACTIVATE_RESOLUTION; i++){
        ((int32_t *)activateMap)[i] = i;
    }
    for(int i = 0; i < ACTIVATE_RESOLUTION; i++){
        ((int8_t *)activateValue)[i] = i;
    }
    //((int8_t *)activateValue)[0] = 0;
    printf("[INFO] Load activate map...\n\r",0);
    doLoadActivateMap(activateMap, 0);
    doLoadActivateMap(activateMap+64*4, 64);
    printf("[INFO] Load activate value...\n\r",0);
    doLoadActivateValue(activateValue);
    int64_t testInput_rs1 = 400;
    uint64_t testInput_rs2 = 0;
    uint64_t result;
    for(int i = -5; i < ACTIVATE_RESOLUTION + 5; i++){
        testInput_rs1 = i;
        doComputeActivate(result, testInput_rs1, 0);
        printf("input:%d, ",(int32_t)(testInput_rs1 & 0xFFFFFFFF));
        printf(" result :%d\n\r", (int8_t)(result & 0xFF));
    }
}