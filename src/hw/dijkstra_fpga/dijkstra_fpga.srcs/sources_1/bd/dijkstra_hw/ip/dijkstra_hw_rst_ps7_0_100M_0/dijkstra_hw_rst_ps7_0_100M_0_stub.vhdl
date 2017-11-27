-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
-- Date        : Mon Nov 27 12:42:27 2017
-- Host        : ricky-U400 running 64-bit elementary OS 0.4.1 Loki
-- Command     : write_vhdl -force -mode synth_stub
--               /mnt/windows/Users/ricky/Seafile/Library/School/F17/EEL4720/prj/dijkstra_fpga/src/hw/dijkstra_fpga/dijkstra_fpga.srcs/sources_1/bd/dijkstra_hw/ip/dijkstra_hw_rst_ps7_0_100M_0/dijkstra_hw_rst_ps7_0_100M_0_stub.vhdl
-- Design      : dijkstra_hw_rst_ps7_0_100M_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dijkstra_hw_rst_ps7_0_100M_0 is
  Port ( 
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end dijkstra_hw_rst_ps7_0_100M_0;

architecture stub of dijkstra_hw_rst_ps7_0_100M_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "slowest_sync_clk,ext_reset_in,aux_reset_in,mb_debug_sys_rst,dcm_locked,mb_reset,bus_struct_reset[0:0],peripheral_reset[0:0],interconnect_aresetn[0:0],peripheral_aresetn[0:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "proc_sys_reset,Vivado 2017.2";
begin
end;
