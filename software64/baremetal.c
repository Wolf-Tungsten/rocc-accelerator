#include <stdint.h>
#include <stddef.h>
#include "myprintf.h"
#include "uart.h"
#include "stat.h"
#include "convolution.h"
#include "activate.h"
#include "maxpool.h"

uint64_t softwareTimeSum = 0;
uint64_t hardwareTimeSum = 0;
uint64_t benchmarkCounter = 0;

int main (void){
    uart_init();
    printf("Hello, RISC-V!\n\r", 0);
    activateBenchmark();
    //convolutionBenchmark();
    //maxpoolBenchmark();
    // for(int i=0; i <= 1000; i++){
    //     printf("relu(%d)=",i);
    //     printf("%d\r\n", relu(i));
    // }
    
}

int convolutionBenchmark(){
    initConvData();
    uint64_t startTime;
    int64_t softwareTime, hardwareTime;
    benchmarkCounter = 0;
    hardwareTimeSum = 0;
    softwareTimeSum = 0;
    do{
        printf("****** Convolution Benchmark :%d ******\r", benchmarkCounter);
        startTime = rdmcycle();
        convBySoftware();
        softwareTime = rdmcycle() - startTime;
        startTime = rdmcycle();
        convByHardware();
        hardwareTime = rdmcycle() - startTime;
        if(softwareTime > 0 && hardwareTime > 0 && checkConvResult()){
            benchmarkCounter++;
            softwareTimeSum += softwareTime;
            hardwareTimeSum += hardwareTime;
        }
    }while(benchmarkCounter < 100);
    printf("****** Convolution Benchmark DONE! ******\n\r", 0);
    printf("software mcycle sum:%d\n\r", softwareTimeSum);
    printf("hardware mcycle sum:%d\n\r", hardwareTimeSum);
    return 0;
}

int maxpoolBenchmark(){
    initMaxpoolData();
    uint64_t startTime;
    int64_t softwareTime, hardwareTime;
    benchmarkCounter = 0;
    hardwareTimeSum = 0;
    softwareTimeSum = 0;
    do{
        printf("****** MAXPOOL Benchmark :%d ******\r", benchmarkCounter);
        startTime = rdmcycle();
        maxpoolBySoftware();
        softwareTime = rdmcycle() - startTime;
        startTime = rdmcycle();
        maxpoolByHardware();
        hardwareTime = rdmcycle() - startTime;
        if(softwareTime > 0 && hardwareTime > 0 && checkMaxpool()){
            benchmarkCounter++;
            softwareTimeSum += softwareTime;
            hardwareTimeSum += hardwareTime;
        }
    }while(benchmarkCounter < 100);
    printf("****** Maxpool Benchmark DONE! ******\n\r", 0);
    printf("software mcycle sum:%d\n\r", softwareTimeSum);
    printf("hardware mcycle sum:%d\n\r", hardwareTimeSum);
    return 0;
}

int activateBenchmark(){
    initActivateData();

    uint64_t startTime;
    int64_t softwareTime, hardwareTime;
    benchmarkCounter = 0;
    hardwareTimeSum = 0;
    softwareTimeSum = 0;
    do{
        printf("****** ACTIVATE Benchmark :%d ******\r", benchmarkCounter);
        startTime = rdmcycle();
        activateBySoftware();
        softwareTime = rdmcycle() - startTime;
        startTime = rdmcycle();
        activateByHardware();
        hardwareTime = rdmcycle() - startTime;
        if(softwareTime > 0 && hardwareTime > 0 && checkActivate()){
            benchmarkCounter++;
            softwareTimeSum += softwareTime;
            hardwareTimeSum += hardwareTime;
        }
    }while(benchmarkCounter < 100);
    printf("****** ACTIVATE Benchmark DONE! ******\n\r", 0);
    printf("software mcycle sum:%d\n\r", softwareTimeSum);
    printf("hardware mcycle sum:%d\n\r", hardwareTimeSum);
    return 0;
}