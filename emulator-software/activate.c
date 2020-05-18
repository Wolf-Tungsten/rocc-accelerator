#include <stdint.h>
#include <stdio.h>
#include "util.h"
#include "./include/activate.h"

// 64位地址对齐，每个 RoCC 内存请求获取两个 int32_t
uint64_t activateMap[ACTIVATE_RESOLUTION / 2];
uint64_t activateValue[ACTIVATE_RESOLUTION / 8];
int8_t relu(int32_t input);
#define SCALE ((int32_t)((int32_t)0x80000000 / (int8_t)0x80))

void main(){
    printf("****** Activate Rocc Test *****\n",0);
    printf("[INFO] Init test data...\n",0);
    for(int i = 0; i < ACTIVATE_RESOLUTION; i++){
        ((int32_t *)activateMap)[i] = i;
    }
    for(int i = 0; i < ACTIVATE_RESOLUTION; i++){
        ((int8_t *)activateValue)[i] = i - 1;
    }
    //((int8_t *)activateValue)[0] = 0;
    printf("[Map] %d, %d, %d...%d\n",  ((int32_t *)activateMap)[0],  ((int32_t *)activateMap)[1],  ((int32_t *)activateMap)[2], ((int32_t *)activateMap)[ACTIVATE_RESOLUTION-1]);
    printf("[Value] %d, %d, %d...%d\n",  ((int8_t *)activateValue)[0],  ((int8_t *)activateValue)[1],  ((int8_t *)activateValue)[2], ((int8_t *)activateValue)[ACTIVATE_RESOLUTION-1]);
    printf("[INFO] Load activate map...\n",0);
    //doLoadActivateMap(activateMap, 0);
    //doLoadActivateMap(activateMap+64*4, 64);
    //doLoadActivateMap(activateMap+128*4, 128);
    doLoadActivateMap(activateMap+192*4, 192);
    printf("[INFO] Load activate value...\n",0);
    doLoadActivateValue(activateValue);
    uint64_t testInput_rs1 = 0;
    uint64_t testInput_rs2 = 0;
    uint64_t result = 0;
    //doComputeActivate(result, testInput_rs1, 0);
    for(int i = 192; i < ACTIVATE_RESOLUTION; i++){
        testInput_rs1 = i;
        doComputeActivate(result, testInput_rs1, 0);
        //printf("success at %d\n", i);
        if(((int32_t *)activateMap)[i] != ((result & 0xFFFFFFFF00000000) >> 32)){
            printf("[MEM] map:%d, value:%d, index:%d",  ((int32_t *)activateMap)[i],  ((int8_t *)activateValue)[i], i);
            printf(" [ROCC] H:0x%x, L:0x%x map:%d, value:%d, index:%d\n",result >> 32, result,  ((result & 0xFFFFFFFF00000000) >> 32), (int8_t)(result & 0xFF), (uint8_t)((result >> 8) & 0xFF));
        }
    }
    printf("success\n");
}


int8_t relu(int32_t input){
    int32_t relu32 = (input > 0 ? input : 0);
    return relu32 / SCALE;
}