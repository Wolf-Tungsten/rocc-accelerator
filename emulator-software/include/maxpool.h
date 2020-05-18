#ifndef SRC_MAIN_C_ACCUMULATOR_H
#define SRC_MAIN_C_ACCUMULATOR_H

#include "xcustom64.h"

#define MAX_POOL_SIZE 16

// val doLoadMap = funct === UInt(0)
// val doCompute = funct === UInt(1)
#define k_DO_LOAD_ROW0 0
#define k_DO_LOAD_ROW1 1
#define k_DO_MAXPOOL 2
//   val doLoadFeatureRow = funct === UInt(0)
//   val doLoadFilter = funct === UInt(1)
//   val doPushFeatureRowIntoFifo = funct === UInt(2)
//   val doConv = funct === UInt(3)
//   val doStoreResult = funct === UInt(4)

#define XCUSTOM_MAXPOOL 2

#define doLoadMaxpoolRow0(addr_rs1)\
  asm volatile ("fence");                                        \
  ROCC_INSTRUCTION_S(XCUSTOM_MAXPOOL, addr_rs1, k_DO_LOAD_ROW0);\
  asm volatile ("fence"); 
#define doLoadMaxpoolRow1(addr_rs1)\
  asm volatile ("fence");                                        \
  ROCC_INSTRUCTION_S(XCUSTOM_MAXPOOL, addr_rs1, k_DO_LOAD_ROW1);\
  asm volatile ("fence"); 
#define doMaxpool(output_rd)                              \
  ROCC_INSTRUCTION_D(XCUSTOM_MAXPOOL, output_rd, k_DO_MAXPOOL); \



#endif