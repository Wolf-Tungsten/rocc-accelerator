#include <stdint.h>
#include <stdio.h>
#include "include/convolution.h"
#include "util.h"

int16_t fetchOneResult(uint8_t resultAddr);
void loadFeatureIntoAccel(int8_t* baseAddr, uint8_t size);
void loadAndStoreTestSimple();

int main() {

  printf("Hello, RISCV!\n");
  loadAndStoreTestSimple();
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

void loadAndStoreTestSimple(){
  printf("[INFO]Loading Number 0x98 into position 0x47...\n");
  uint32_t addr = 0x00000047; // addr in rs1
  uint32_t data = 0x00000098; // data in rs2
  doLoadFeatureRow(addr, data);
  printf("[INFO]Load Succeeded!\n");
  uint32_t result = 0;
  printf("[INFO]Fetching Result from position 0x47...\n");
  addr = 0x00000047;
  doStoreResult(result, addr);
  result &= 0xFF; // only check lowest 1 bit
  printf("[INFO]Result of position 0x47 is 0x%x\n", result);
  if(result == data){
    printf("[INFO]Test passed!\n");
  } else {
    printf("[INFO]Test failed!\n");
  }
  return;
}
