#ifndef SRC_MAIN_C_ACCUMULATOR_H
#define SRC_MAIN_C_ACCUMULATOR_H

#include "xcustom.h"

// #define k_DO_WRITE 0
// #define k_DO_READ 1
// #define k_DO_LOAD 2
// #define k_DO_ACCUM 3

#define k_DO_LOAD_FEATURE_ROW 0
#define k_DO_STORE_RESULT 4
//   val doLoadFeatureRow = funct === UInt(0)
//   val doLoadFilter = funct === UInt(1)
//   val doPushFeatureRowIntoFifo = funct === UInt(2)
//   val doConv = funct === UInt(3)
//   val doStoreResult = funct === UInt(4)

#define XCUSTOM_CONV 0
uint32_t empty;

#define doLoadFeatureRow(baseAddr)                                       \
  ROCC_INSTRUCTION_S(XCUSTOM_CONV, baseAddr, k_DO_LOAD_FEATURE_ROW);
#define doStoreResult(baseAddr)                                              \
  ROCC_INSTRUCTION_S(XCUSTOM_CONV, baseAddr, k_DO_STORE_RESULT);

#endif