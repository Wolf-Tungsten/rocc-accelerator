#include <stdint.h>
#include <stdio.h>
#include "include/convolution.h"
#include "util.h"

int main() {

  // printf("Hello, RISCV!\n");
  int8_t featureData[256];
  int16_t resultData[256];
  // printf("Init featureData...\n");
  // for(int i = 0; i < 256; i++){
  //   featureData[i] = 256 - i;
  // }
  // printf("Init featureData Done\n");
  // printf("Loading feature...\n");
  // setStats(1);
  doLoadFeatureRow(&featureData[0]);
  // setStats(0);
  // printf("Feature loaded\n");
  // setStats(1);
  // doStoreResult(&resultData[0]);
  // setStats(0);
  // for(int i = 0; i < 256; i++){
  //   printf("%d ", resultData[i]);
  // }
  // printf("[INFO] Write R[%d] = 0x%lx\n", addr, data[0]);
  // doWrite(y, addr, data[0]);

  // printf("[INFO] Read R[%d]\n", addr);
  // doRead(y, addr);
  // printf("[INFO]   Received 0x%lx (expected 0x%lx)\n", y, data[0]);
  // if(y != data[0]){
  //   printf("[ERROR] Miss match\n");
  // }

  // uint64_t data_accum = -data[0] + data[1];
  // printf("[INFO] Accum R[%d] with 0x%lx\n", addr, data_accum);
  // doAccum(y, addr, data_accum);
  // //assert(y == data[0]);

  // printf("[INFO] Read R[%d]\n", addr);
  // doRead(y, addr);
  // printf("[INFO]   Received 0x%lx (expected 0x%lx)\n", y, data[1]);
  // //assert(y == data[1]);

  // uint64_t data_addr;
  // doTranslate(data_addr, &data[2]);
  // printf("[INFO] Load 0x%lx (virt: 0x%p, phys: 0x%p) via L1 virtual address\n",
  //        data[2], &data[2], (void *) data_addr);
  // doLoad(y, addr, &data[2]);
  // //assert(y == data[1]);

  // printf("[INFO] Read R[%d]\n", addr);
  // doRead(y, addr);
  // printf("[INFO]   Received 0x%lx (expected 0x%lx)\n", y, data[2]);
  // //assert(y == data[2]);
  return 0;
}