#include <stdint.h>
#include <stdio.h>
#include "include/convolution.h"
#include "util.h"

int8_t fetchOneResult(uint8_t resultAddr);
void loadFeatureIntoAccel(int8_t* baseAddr, uint16_t size);
void loadAndStoreTestSimple();
void pushFIFOTest();
int8_t fetchOneResultFIFO(uint8_t resultAddr);

int main() {

  printf("Hello, RISCV!\n");
  //loadAndStoreTestSimple();
  pushFIFOTest();
  //setStats(1);
  //loadFeatureIntoAccel(featureDataRow, 256);
  //setStats(0);
  
  // printf("Storing Result from Accelerator to Mem...\n");
  // doStoreResult(resultData);
  // printf("Storing Result from Accelerator to Mem Done!\n");
  
}

void loadFeatureIntoAccel(int8_t* baseAddr, uint16_t size){
  // 指令设计为每次装载 4 个 8 位符号整数
  uint8_t cycle = size >> 2;
  uint32_t rs1;
  uint32_t rs2;
  // 先装载4的整数倍的部分
  for(uint8_t i = 0; i < cycle; i++){
    uint32_t ptr = (uint32_t)i << 2;
    rs1 = ((ptr + 3) << (8 * 3)) |
          ((ptr + 2) << (8 * 2)) |
          ((ptr + 1) << (8 * 1)) |
          ptr; // addr
    rs2 = (((uint32_t)baseAddr[ptr+3] << (8 * 3)) & 0xFF000000)|
          (((uint32_t)baseAddr[ptr+2] << (8 * 2)) & 0x00FF0000)|
          (((uint32_t)baseAddr[ptr+1] << (8 * 1)) & 0x0000FF00)|
          (((uint32_t)baseAddr[ptr]) & 0x000000FF); // data
    // printf("addr: %x - data: %x \n", rs1, rs2);
    doLoadFeatureRow(rs1, rs2); 
  }
  uint8_t needMore1Cycle = size & 0x3;
  // 再装载剩下的
  if(needMore1Cycle){
    rs1 = 0;
    rs2 = 0;
    for(uint8_t i = 0; i < needMore1Cycle; i++){
      rs1 = (cycle << 2) + i;
      rs2 = baseAddr[(cycle << 2) + i];
      // printf("addr: %x - data: %x \n", rs1, rs2);
    }
    //doLoadFeatureRow(rs1, rs2);
  }
}

int8_t fetchOneResult(uint8_t resultAddr){
  int32_t result = 0;
  doFetchResult(result, resultAddr);
  return (int8_t)((result >> 16) & 0x00FF);
}

int8_t fetchOneResultFIFO(uint8_t resultAddr){
  int32_t result = 0;
  doFetchResult(result, resultAddr);
  return (int8_t)((result >> 0) & 0x00FF);
}

void loadAndStoreTestSimple(){
  printf("[INFO]Loading Number 0x98 into position 0x47...\n");
  uint32_t addr = 0x00000047; // addr in rs1
  uint32_t data = 0x00000098; // data in rs2
  doLoadFeatureRow(addr, data);
  printf("[INFO]Load Succeeded!\n");
  uint32_t result = 0;
  printf("[INFO]Fetching Result from position 0x47...\n");
  addr = 0x00000047;
  doFetchResult(result, addr);
  result &= 0xFF; // only check lowest 1 bit
  printf("[INFO]Result of position 0x47 is 0x%x\n", result);
  if(result == data){
    printf("[INFO]Test passed!\n");
  } else {
    printf("[INFO]Test failed!\n");
  }
  return;
}

void pushFIFOTest(){
  printf("Preparing Test Data...\n");
  int8_t featureDataRow[256];
  for(int i = 0; i < 256; i++){
    featureDataRow[i] = i - 128;
  }
  printf("Loading Result into Accelerator By DMA...\n");
  doLoadFeatureRowDma(featureDataRow);
  doLoadFeatureRowDma(featureDataRow);
  printf("Load Result into Accelerator By DMA Done!\n");
  int passed = 0;
  int failed = 0;
  for(int i = 0; i < 256; i++){
    if(featureDataRow[i] == fetchOneResult(i)){
      passed++;
    } else {
      printf("[ERROR] addr:%x, expect:%d, actually:%d\n",i,featureDataRow[i],fetchOneResult(i));
      failed++;
    }
  }
  printf("[INFO] before push passed:%d, failed:%d\n", passed, failed);
  doPushFeatureRowIntoFifo();
  passed = 0;
  failed = 0;
  for(int i = 0; i < 256; i++){
    if(featureDataRow[i] == fetchOneResultFIFO(i)){
      passed++;
    } else {
      printf("[ERROR] addr:%x, expect:%d, feature:%d, fifo:%d\n",i,featureDataRow[i],fetchOneResult(i), fetchOneResultFIFO(i));
      failed++;
    }
  }
  printf("[INFO] after push passed:%d, failed:%d\n", passed, failed);
}