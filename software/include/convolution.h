#ifndef SRC_MAIN_C_ACCUMULATOR_H
#define SRC_MAIN_C_ACCUMULATOR_H

#include "xcustom.h"

// #define k_DO_WRITE 0
// #define k_DO_READ 1
// #define k_DO_LOAD 2
// #define k_DO_ACCUM 3

#define k_DO_LOAD_FEATURE_ROW 0
#define k_DO_LOAD_FEATURE_ROW_DMA 1
#define k_DO_FETCH_RESULT 5
#define k_DO_STORE_RESULT 6
//   val doLoadFeatureRow = funct === UInt(0)
//   val doLoadFilter = funct === UInt(1)
//   val doPushFeatureRowIntoFifo = funct === UInt(2)
//   val doConv = funct === UInt(3)
//   val doStoreResult = funct === UInt(4)

#define XCUSTOM_CONV 0
uint32_t empty;

#define doLoadFeatureRow(addr_rs1, data_rs2)                                       \
  ROCC_INSTRUCTION_SS(XCUSTOM_CONV, addr_rs1, data_rs2, k_DO_LOAD_FEATURE_ROW);
#define doLoadFeatureRowDma(addr_rs1)                                       \
  ROCC_INSTRUCTION_S(XCUSTOM_CONV, addr_rs1, k_DO_LOAD_FEATURE_ROW_DMA);
#define doFetchResult(result_rd, addr_rs1)                                              \
  ROCC_INSTRUCTION_DSS(XCUSTOM_CONV, result_rd, addr_rs1, 0, k_DO_FETCH_RESULT)
#define doStoreResult(addr_rs1)                                       \
  ROCC_INSTRUCTION_S(XCUSTOM_CONV, addr_rs1, k_DO_STORE_RESULT);

#endif