#include <stdint.h>
#include "include/convolution.h"
#include "myprintf.h"

// 定义内存区域
int8_t featureData[FEATURE_ROW_SIZE * FEATURE_ROW_SIZE];
int8_t filterData[FILTER_ROW_SIZE * FILTER_ROW_SIZE];
int32_t resultData[RESULT_ROW_SIZE * RESULT_ROW_SIZE];

void convTest(){

    printf("[INFO] Init test data...\n\r",0);
    for(int row = 0; row < FEATURE_ROW_SIZE; row++){
        for(int col = 0; col < FEATURE_ROW_SIZE; col++){
            featureData[row * FEATURE_ROW_SIZE + col] = 1;
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