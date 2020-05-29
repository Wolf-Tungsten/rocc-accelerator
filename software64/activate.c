#include <stdint.h>
#include "./include/activate.h"
#include "myprintf.h"
#include <math.h>

// 64位地址对齐，每个 RoCC 内存请求获取两个 int32_t
uint64_t activateMap[ACTIVATE_RESOLUTION / 2];
uint64_t activateValue[ACTIVATE_RESOLUTION / 8];
int8_t relu(int32_t input);
int8_t intSigmoid(int32_t x);
#define SCALE ((int32_t)((int32_t)0x80000000 / (int8_t)0x80))

#define ACTIVATE_TEST_SIZE 512
uint64_t activateInput[ACTIVATE_TEST_SIZE/2];
int8_t softwareActivateResult[ACTIVATE_TEST_SIZE];
uint32_t hardwareActivateResult[ACTIVATE_TEST_SIZE/4 + 1];

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

void initActivateData(){
    int32_t current=0;
    ((int32_t *)activateMap)[0] = 0;
    for(int i = 0; i < 1000; i++){
        if(relu(i) > current){
            current = relu(i);
            ((int32_t *)activateMap)[current] = i;
        }
    }
    ((int32_t *)activateMap)[127] = 1000;
    ((int8_t *)activateValue)[0] = 0;
    for(int i = 1; i < ACTIVATE_RESOLUTION; i++){
        ((int8_t *)activateValue)[i] = i-1;
    }
    // for(int i = 0; i < ACTIVATE_RESOLUTION; i++){
    //     printf("pos:%d ", i);
    //     printf("map:%d ",  ((int32_t *)activateMap)[i]);
    //     printf("value:%d \n\r",  ((int8_t *)activateValue)[i]);
    // }
    doLoadActivateMap(activateMap, 0);
    doLoadActivateMap(activateMap+64*4, 64);
    doLoadActivateValue(activateValue);
    for(int i = 0; i<ACTIVATE_TEST_SIZE; i++){
        ((int32_t *)activateInput)[i] = 0;
    }
}

void initActivateDataSigmoid(){
    printf("init \r\n",0);
    int32_t current=0;
    ((int32_t *)activateMap)[0] = -310;
    for(int i = -512; i < 512; i++){
        if(intSigmoid(i) > current){
            current = intSigmoid(i);
            ((int32_t *)activateMap)[current] = i;
        }
    }
    ((int32_t *)activateMap)[127] = 1000000;
    ((int8_t *)activateValue)[0] = 0;
    for(int i = 1; i < ACTIVATE_RESOLUTION; i++){
        ((int8_t *)activateValue)[i] = i-1;
    }
    // for(int i = 0; i < ACTIVATE_RESOLUTION; i++){
    //     //printf("pos:%d ", i);
    //     if(((int32_t *)activateMap)[i] < 0){
    //         //printf("map:-%d ",  -((int32_t *)activateMap)[i]);
    //     } else {
    //         //printf("map:%d ",  ((int32_t *)activateMap)[i]);
    //     }
    //     printf("",  ((int8_t *)activateValue)[i]);
    // }
    for(int i = 0; i < ACTIVATE_RESOLUTION; i++){
        ((int8_t *)activateValue)[i]=((int8_t *)activateValue)[i];
        ((int32_t *)activateMap)[i]=((int32_t *)activateMap)[i];
    }
    doLoadActivateMap(activateMap, 0);
    doLoadActivateMap(activateMap+64*4, 64);
    doLoadActivateValue(activateValue);
    for(int i = 0; i<ACTIVATE_TEST_SIZE; i++){
        ((int32_t *)activateInput)[i] = (i%1024)-512;
    }
}

void activateBySoftware(){
    for(int i = 0; i<ACTIVATE_TEST_SIZE; i++){
        softwareActivateResult[i] = relu(((int32_t *)activateInput)[i]);
    }
}

void activateBySoftwareSigmoid(){
    for(int i = 0; i<ACTIVATE_TEST_SIZE; i++){
        softwareActivateResult[i] = intSigmoid(((int32_t *)activateInput)[i]);
    }
}

void activateByHardware(){
    uint64_t result;
    for(int i = 0; i<ACTIVATE_TEST_SIZE; i+=4){
        // doComputeActivate(result, activateInput[i>>1], activateInput[(i>>1)+1])
        // ((int8_t*)hardwareActivateResult)[i] = result & 0xFF;
        // ((int8_t*)hardwareActivateResult)[i+1] = (result >> 8) & 0xFF;
        // ((int8_t*)hardwareActivateResult)[i+2] = (result >> 16) & 0xFF;
        // ((int8_t*)hardwareActivateResult)[i+3] = (result >> 24) & 0xFF;
        doComputeActivate(hardwareActivateResult[i>>2], activateInput[i>>1], activateInput[(i>>1)+1])
    }
}

int checkActivate(){
    for(int i=0; i < ACTIVATE_TEST_SIZE; i++){
        if(softwareActivateResult[i] != ((int8_t *)hardwareActivateResult)[i]){
            printf("pos: %d ",i);
            if(((int32_t *)activateInput)[i] < 0)
                printf("input: -%d ",-((int32_t *)activateInput)[i]);
            else
                printf("input: %d ",((int32_t *)activateInput)[i]);
            printf("software: %d ",softwareActivateResult[i]);
            if(((int8_t *)hardwareActivateResult)[i] < 0)
                printf("hardware: -%d\n\r", -((int8_t *)hardwareActivateResult)[i]);
            else
                printf("hardware: %d\n\r", ((int8_t *)hardwareActivateResult)[i]);
            return 0;
        }
    }
    return 1;
}

int8_t relu(int32_t x){
    if(x <= 0){
        x = 0;
    }
    float scale = 1000.0 / 127;
    return x / scale;
}

int8_t intSigmoid(int32_t x){
    float scaledX = x/64.0;
    return 127/(1+exp(-scaledX));
}
