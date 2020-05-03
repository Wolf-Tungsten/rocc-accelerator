#ifndef SRC_MAIN_C_ACCUMULATOR_H
#define SRC_MAIN_C_ACCUMULATOR_H

#include "xcustom.h"

// #define k_DO_WRITE 0
// #define k_DO_READ 1
// #define k_DO_LOAD 2
// #define k_DO_ACCUM 3

#define k_DO_LOAD_FEATURE_ROW 0
#define k_DO_STORE_RESULT 1
//   val doLoadFeatureRow = funct === UInt(0)
//   val doLoadFilter = funct === UInt(1)
//   val doPushFeatureRowIntoFifo = funct === UInt(2)
//   val doConv = funct === UInt(3)
//   val doStoreResult = funct === UInt(4)

#define XCUSTOM_CONV 0
uint32_t empty;

#define doLoadFeatureRow(rs1, rs2)                                       \
  ROCC_INSTRUCTION_SS(XCUSTOM_CONV, rs1, rs2, k_DO_LOAD_FEATURE_ROW);
#define doStoreResult(rd, rs1)                                              \
  ROCC_INSTRUCTION_DSS(XCUSTOM_CONV, rd, 0, rs1, k_DO_STORE_RESULT)

#endif