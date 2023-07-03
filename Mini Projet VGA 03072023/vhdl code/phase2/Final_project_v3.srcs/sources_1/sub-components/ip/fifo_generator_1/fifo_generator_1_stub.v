// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Jun 17 18:21:37 2023
// Host        : LAPTOP-PE8R3QLA running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top fifo_generator_1 -prefix
//               fifo_generator_1_ fifo_generator_0_stub.v
// Design      : fifo_generator_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.2" *)
module fifo_generator_1(clk, srst, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[11:0],wr_en,rd_en,dout[11:0],full,empty" */;
  input clk;
  input srst;
  input [11:0]din;
  input wr_en;
  input rd_en;
  output [11:0]dout;
  output full;
  output empty;
endmodule
