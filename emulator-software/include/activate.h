#ifndef SRC_MAIN_C_ACCUMULATOR_H
#define SRC_MAIN_C_ACCUMULATOR_H

#include "xcustom64.h"

#define ACTIVATE_RESOLUTION 256

// val doLoadMap = funct === UInt(0)
// val doCompute = funct === UInt(1)
#define k_DO_LOAD_MAP 0
#define k_DO_LOAD_VALUE 1
#define k_DO_COMPUTE 2
//   val doLoadFeatureRow = funct === UInt(0)
//   val doLoadFilter = funct === UInt(1)
//   val doPushFeatureRowIntoFifo = funct === UInt(2)
//   val doConv = funct === UInt(3)
//   val doStoreResult = funct === UInt(4)

#define XCUSTOM_ACTIVATE 1

#define doLoadActivateMap(addr_rs1, reg_base_rs2)\
  asm volatile ("fence");                                        \
  ROCC_INSTRUCTION_SS(XCUSTOM_ACTIVATE, addr_rs1, reg_base_rs2, k_DO_LOAD_MAP);\
  asm volatile ("fence"); 
#define doLoadActivateValue(addr_rs1)\
  asm volatile ("fence");                                        \
  ROCC_INSTRUCTION_S(XCUSTOM_ACTIVATE, addr_rs1, k_DO_LOAD_VALUE);\
  asm volatile ("fence"); 
#define doComputeActivate(output_rd, num_rs1, num_rs2)                                              \
  ROCC_INSTRUCTION_DSS(XCUSTOM_ACTIVATE, output_rd, num_rs1, num_rs2, k_DO_COMPUTE)


#endif