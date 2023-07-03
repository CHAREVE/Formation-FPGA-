-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Sat Jun 17 18:21:37 2023
-- Host        : LAPTOP-PE8R3QLA running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top fifo_generator_2 -prefix
--               fifo_generator_2_ fifo_generator_0_stub.vhdl
-- Design      : fifo_generator_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_generator_2 is
  Port ( 
    clk : in STD_LOGIC;
    srst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 11 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 11 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC
  );

end fifo_generator_2;

architecture stub of fifo_generator_2 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,srst,din[11:0],wr_en,rd_en,dout[11:0],full,empty";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_5,Vivado 2020.2";
begin
end;
