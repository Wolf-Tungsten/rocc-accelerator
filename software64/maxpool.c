#include <stdint.h>
#include "./include/maxpool.h"
#include "myprintf.h"

uint64_t row0[MAX_POOL_SIZE / 8];
uint64_t row1[MAX_POOL_SIZE / 8];

#define MAXPOOL_TEST_SIZE 512
int8_t maxpoolInputData[MAXPOOL_TEST_SIZE * MAXPOOL_TEST_SIZE];
int8_t maxpoolSoftwareOutputData[(MAXPOOL_TEST_SIZE / 2) * (MAXPOOL_TEST_SIZE / 2)];
int8_t maxpoolHardwareOutputData[(MAXPOOL_TEST_SIZE / 2) * (MAXPOOL_TEST_SIZE / 2)];

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

void initMaxpoolData(){
    for(int row = 0; row < MAXPOOL_TEST_SIZE; row++){
        for(int col = 0; col < MAXPOOL_TEST_SIZE; col++){
            maxpoolInputData[row * MAXPOOL_TEST_SIZE + col] = row + col;
        }
    }
}

void maxpoolBySoftware(){
    for(int row = 0; row < MAXPOOL_TEST_SIZE; row += 2){
        for(int col = 0; col < MAXPOOL_TEST_SIZE; col += 2){
            int8_t max0 = 
            (maxpoolInputData[row * MAXPOOL_TEST_SIZE + col] > maxpoolInputData[row * MAXPOOL_TEST_SIZE + col + 1] ? 
            maxpoolInputData[row * MAXPOOL_TEST_SIZE + col] : maxpoolInputData[row * MAXPOOL_TEST_SIZE + col + 1]);
            int8_t max1 =
            (maxpoolInputData[(row+1) * MAXPOOL_TEST_SIZE + col] > maxpoolInputData[(row+1) * MAXPOOL_TEST_SIZE + col + 1] ? 
            maxpoolInputData[(row+1) * MAXPOOL_TEST_SIZE + col] : maxpoolInputData[(row+1) * MAXPOOL_TEST_SIZE + col + 1]);
            maxpoolSoftwareOutputData[(row >> 1) * (MAXPOOL_TEST_SIZE / 2)+(col >> 1)] = max0 > max1 ? max0 : max1;
        }
    }
}

void maxpoolByHardware(){
    uint8_t colWiseExpand = MAXPOOL_TEST_SIZE / MAX_POOL_SIZE;
    uint64_t result;
    for(int i = 0; i < colWiseExpand; i++){
        for(int row=0; row < MAXPOOL_TEST_SIZE; row += 2){
            doLoadMaxpoolRow0(maxpoolInputData + row * MAXPOOL_TEST_SIZE + i * MAX_POOL_SIZE);
            doLoadMaxpoolRow1(maxpoolInputData + (row + 1) * MAXPOOL_TEST_SIZE + i * MAX_POOL_SIZE);
            // doMaxpool(result)
            // for(int col=0; col < MAX_POOL_SIZE / 2; col++){
            //     maxpoolHardwareOutputData[(row >> 1)*(MAXPOOL_TEST_SIZE/2) + ((i * MAX_POOL_SIZE) >> 1) + col]=(int8_t)((result >> (col*8)) & 0xFF);
            // }
            doMaxpool(*(uint64_t *)(maxpoolHardwareOutputData + (row >> 1)*(MAXPOOL_TEST_SIZE/2) + ((i * MAX_POOL_SIZE) >> 1)))
        }
    }
}

int checkMaxpool(){
    for(int i=0; i < MAXPOOL_TEST_SIZE/2 ;i++){
        for(int j=0; j < MAXPOOL_TEST_SIZE/2; j++){
            if(maxpoolSoftwareOutputData[i * (MAXPOOL_TEST_SIZE/2) + j] != maxpoolHardwareOutputData[i * (MAXPOOL_TEST_SIZE/2) + j]){
                printf("[MAXPOOL ERROR] row:%d ", i);
                printf("col:%d ", j);
                printf("software:%d ", maxpoolSoftwareOutputData[i * (MAXPOOL_TEST_SIZE/2) + j]);
                printf("hardware:%d \n\r", maxpoolHardwareOutputData[i * (MAXPOOL_TEST_SIZE/2) + j]);
            }
        }
    }
}