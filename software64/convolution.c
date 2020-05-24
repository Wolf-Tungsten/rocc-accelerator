#include <stdint.h>
#include "include/convolution.h"
#include "myprintf.h"

#define TEST_FEATURE_SIZE 256
#define TEST_RESULT_ROW_SIZE ((TEST_FEATURE_SIZE / RESULT_ROW_SIZE + (TEST_FEATURE_SIZE % RESULT_ROW_SIZE ? 1 : 0)) * RESULT_ROW_SIZE)
// 定义内存区域
int8_t featureData[FEATURE_ROW_SIZE * FEATURE_ROW_SIZE];
int8_t filterData[FILTER_ROW_SIZE * FILTER_ROW_SIZE];
int32_t resultData[RESULT_ROW_SIZE * RESULT_ROW_SIZE];
int32_t softwareData[RESULT_ROW_SIZE * RESULT_ROW_SIZE];

int8_t testFeatureData[TEST_FEATURE_SIZE * TEST_FEATURE_SIZE];
int8_t testFilterData[FILTER_ROW_SIZE * FILTER_ROW_SIZE];
int32_t testHardwareResult[(TEST_RESULT_ROW_SIZE+1) * (TEST_FEATURE_SIZE-2)];
int32_t testSoftwareResult[(TEST_FEATURE_SIZE-2) * (TEST_FEATURE_SIZE-2)];



void convTest(){

    printf("[INFO] Init test data...\n\r",0);
    for(int row = 0; row < FEATURE_ROW_SIZE; row++){
        for(int col = 0; col < FEATURE_ROW_SIZE; col++){
            featureData[row * FEATURE_ROW_SIZE + col] = row;
        }
    }
    for(int row = 0; row < FILTER_ROW_SIZE; row++){
        for(int col = 0; col < FILTER_ROW_SIZE; col++){
            filterData[row * FILTER_ROW_SIZE + col] = 1;
        }
    }
    printf("[INFO] Init test data DONE!\n\r",0);
    doLoadFeatureRowDma(featureData);
    doPushFeatureRowIntoFifo();
    doLoadFeatureRowDma(featureData + FEATURE_ROW_SIZE);
    doPushFeatureRowIntoFifo();
    doLoadFeatureRowDma(featureData + FEATURE_ROW_SIZE * 2);
    doPushFeatureRowIntoFifo();
    // 装载卷积核数据
    for(int i = 0; i < FILTER_ROW_SIZE * FILTER_ROW_SIZE; i++){
        doLoadFilterData(i, filterData[i]);
    }
    // 数据装载完毕
    printf("[INFO] Load test data...\n\r",0);
    printf("[INFO] Fire the hole!\n\r",0);
    doConv();
    printf("[INFO] Conv DONE\n\r",0);
    doStoreResult(resultData)
    for(int i = 0; i < RESULT_ROW_SIZE; i++){
        printf("[RESULT] addr:%d, \n\r", i);
        printf("data:%d\n\r", resultData[i]);
    }
}

void initConvData(){
    printf("TEST_FEATURE_SIZE:%d \n\r", TEST_FEATURE_SIZE);
    printf("TEST_RESULT_ROW_SIZE:%d \n\r", TEST_RESULT_ROW_SIZE);
    for(int row = 0; row < TEST_FEATURE_SIZE; row++){
        for(int col = 0; col < TEST_FEATURE_SIZE; col++){
            testFeatureData[row * TEST_FEATURE_SIZE + col] = row * TEST_FEATURE_SIZE + col;
        }
    }
    for(int row = 0; row < FILTER_ROW_SIZE; row++){
        for(int col = 0; col < FILTER_ROW_SIZE; col++){
            testFilterData[row * FILTER_ROW_SIZE + col] = 0;
        }
    }
    testFilterData[0]=1;
    // for(int row=0; row < TEST_FEATURE_SIZE - 2; row++){
    //     for(int col=0; col < TEST_RESULT_ROW_SIZE; col++){
    //         testHardwareResult[row * TEST_RESULT_ROW_SIZE + col] = 0;
    //     }
    // }
}

void convBySoftware(){
    for(int row=0; row < TEST_FEATURE_SIZE - 2; row++){
        for(int col=0; col < TEST_FEATURE_SIZE - 2; col++){
            testSoftwareResult[row * (TEST_FEATURE_SIZE - 2) + col] = 0;
            for(int filterRow=0; filterRow < FILTER_ROW_SIZE; filterRow++){
                for(int filterCol=0; filterCol < FILTER_ROW_SIZE; filterCol++){
                    testSoftwareResult[row * (TEST_FEATURE_SIZE - 2) + col] +=
                    testFeatureData[(row + filterRow) * TEST_FEATURE_SIZE + col + filterCol] *
                    testFilterData[filterRow * FILTER_ROW_SIZE + filterCol];
                }
            }
        }
    }
}

void convByHardware(){
    // 装载卷积核
    for(int i = 0; i < FILTER_ROW_SIZE * FILTER_ROW_SIZE; i++){
        doLoadFilterData(i, testFilterData[i]);
    }
    // 计算横向展开
    int colWiseExtend = TEST_RESULT_ROW_SIZE / RESULT_ROW_SIZE;
    for(int i = 0; i < colWiseExtend; i++){
        doLoadFeatureRowDma(testFeatureData + i * RESULT_ROW_SIZE);
        doPushFeatureRowIntoFifo();
        doLoadFeatureRowDma(testFeatureData + TEST_FEATURE_SIZE + i * RESULT_ROW_SIZE);
        doPushFeatureRowIntoFifo();
        for(int j = 2; j < TEST_FEATURE_SIZE; j++){
            doLoadFeatureRowDma(testFeatureData + (TEST_FEATURE_SIZE * j) + (i * RESULT_ROW_SIZE));
            doPushFeatureRowIntoFifo();
            doConv();
            doStoreResult(testHardwareResult + 4 * ((TEST_RESULT_ROW_SIZE+1) * (j-2) + (i * RESULT_ROW_SIZE)));
        }
    }
    
    // 开始计算
    
}

int checkConvResult(){
    for(int row=0; row < TEST_FEATURE_SIZE-2; row++){
        for(int col=0; col < TEST_FEATURE_SIZE-2; col++){
            // testSoftwareResult[row * (TEST_FEATURE_SIZE-2) + col] != testHardwareResult[row * TEST_RESULT_ROW_SIZE + col]
            if(testSoftwareResult[row * (TEST_FEATURE_SIZE-2) + col] != testHardwareResult[row * (TEST_RESULT_ROW_SIZE+1) + col]){
                printf("row: %d ", row);
                printf("col: %d ", col);
                printf("software: %d ", testSoftwareResult[row * (TEST_FEATURE_SIZE-2)  + col]);
                printf("hardware: %d\n\r", testHardwareResult[row * (TEST_RESULT_ROW_SIZE+1) + col]);
            }
        }
    }
}



