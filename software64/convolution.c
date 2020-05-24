#include <stdint.h>
#include "include/convolution.h"
#include "myprintf.h"

// 定义内存区域
int64_t featureData[FEATURE_ROW_SIZE * FEATURE_ROW_SIZE / 8];
int64_t filterData[FILTER_ROW_SIZE * FILTER_ROW_SIZE / 8];
int64_t resultData[FEATURE_ROW_SIZE * FEATURE_ROW_SIZE / 2];
int32_t softwareData[RESULT_ROW_SIZE * RESULT_ROW_SIZE / 2];

void convTest(){

    printf("[INFO] Init test data...\n\r",0);
    for(int row = 0; row < FEATURE_ROW_SIZE; row++){
        for(int col = 0; col < FEATURE_ROW_SIZE; col++){
            featureData[row * FEATURE_ROW_SIZE + col] = col;
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
    for(int row = 0; row < FEATURE_ROW_SIZE; row++){
        for(int col = 0; col < FEATURE_ROW_SIZE; col++){
            ((int8_t *)featureData)[row * FEATURE_ROW_SIZE + col] = col;
        }
    }
    for(int row = 0; row < FILTER_ROW_SIZE; row++){
        for(int col = 0; col < FILTER_ROW_SIZE; col++){
            ((int8_t *)filterData)[row * FILTER_ROW_SIZE + col] = 1;
        }
    }
}

void convBySoftware(){
    //int8_t a, b, c;
    for(int row=0; row < RESULT_ROW_SIZE; row++){
        for(int col=0; col < RESULT_ROW_SIZE; col++){
            ((int32_t *)resultData)[row * RESULT_ROW_SIZE + col] = 0;
            for(int filterRow=0; filterRow < FILTER_ROW_SIZE; filterRow++){
                for(int filterCol=0; filterCol < FILTER_ROW_SIZE; filterCol++){
                    ((int8_t *)softwareData)[row * RESULT_ROW_SIZE + col] +=
                    ((int8_t *)featureData)[(row + filterRow) * RESULT_ROW_SIZE + col + filterCol] *
                    ((int8_t *)filterData)[filterRow * FILTER_ROW_SIZE + filterCol];
                    //c += a * b;
                }
            }
        }
    }
}

void convByRocc(){
    for(int i = 0; i < FILTER_ROW_SIZE * FILTER_ROW_SIZE; i++){
        doLoadFilterData(i, ((int8_t *)filterData)[i]);
    }
    // 预装前两行数据
    doLoadFeatureRowDma(featureData);
    doPushFeatureRowIntoFifo();
    doLoadFeatureRowDma((int8_t *)featureData + FEATURE_ROW_SIZE);
    doPushFeatureRowIntoFifo();
    // 开始计算
    for(int i = 2; i < FEATURE_ROW_SIZE; i++){
        doLoadFeatureRowDma((int8_t *)featureData + FEATURE_ROW_SIZE * i);
        doPushFeatureRowIntoFifo();
        doConv();
        printf("before %d\n\r", (i-2) * FEATURE_ROW_SIZE);
        doStoreResult((int32_t *)resultData + (i-2) * FEATURE_ROW_SIZE);
        printf("after %d\n\r", (i-2) * FEATURE_ROW_SIZE);
    }
}

