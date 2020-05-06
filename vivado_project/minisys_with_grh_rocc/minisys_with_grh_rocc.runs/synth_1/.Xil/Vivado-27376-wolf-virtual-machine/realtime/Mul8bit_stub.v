// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_15,Vivado 2019.1.3" *)
module Mul8bit(CLK, A, B, CE, SCLR, P);
  input CLK;
  input [7:0]A;
  input [7:0]B;
  input CE;
  input SCLR;
  output [15:0]P;
endmodule
