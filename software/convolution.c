#include <stdint.h>
#include <stdio.h>
#include "include/convolution.h"
#include "util.h"

int16_t fetchOneResult(uint8_t resultAddr);
void loadFeatureIntoAccel(int8_t* baseAddr, uint8_t size);

int main() {

  printf("Hello, RISCV!\n");
  int8_t featureData[256];
  int16_t resultData[256];
  printf("Init featureData...\n");
  for(int i = 0; i < 256; i++){
    featureData[i] = 256 - i;
  }
  printf("Init featureData Done\n");
  printf("Loading feature...\n");
  uint32_t rs1 = 0x03020100;
  uint32_t rs2 = 0x10111212;
  // doLoadFeatureRow(rs1, rs2);
  //loadFeatureIntoAccel(featureData, 255);
  printf("Feature loaded\n");
  //printf("result[0]:%x\n",fetchOneResult(0));
  uint32_t result = 0;
  doStoreResult(result, 0);
  // printf("result[1]:%x\n",result);
  return 0;
}

void loadFeatureIntoAccel(int8_t* baseAddr, uint8_t size){
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
          ptr;
    rs2 = ((uint32_t)baseAddr[ptr+3] << (8 * 3))|
          ((uint32_t)baseAddr[ptr+2] << (8 * 2))|
          ((uint32_t)baseAddr[ptr+1] << (8 * 1))|
          ((uint32_t)baseAddr[ptr]);
    doLoadFeatureRow(rs1, rs2); 
  }
  uint8_t needMore1Cycle = size | 0x3;
  // 再装载剩下的
  if(needMore1Cycle){
    rs1 = 0;
    rs2 = 0;
    for(uint8_t i = 0; i < needMore1Cycle; i++){
      rs1 += (cycle << 2 + i);
      rs1 = rs1 << 8;
      rs2 += baseAddr[(cycle << 2 + i)];
      rs2 = rs2 << 8;
    }
    doLoadFeatureRow(rs1, rs2);
  }
}

int16_t fetchOneResult(uint8_t resultAddr){
  int32_t result = 0;
  doStoreResult(result, resultAddr);
  return (int16_t)(result & 0x00FF);
}