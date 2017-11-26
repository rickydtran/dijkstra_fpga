-- Ricky Tran
-- University of Florida
-- comp_bin.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity comp_bin is
  port (
    mem_out_rd_bus : in   data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
    done_arr       : in  std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
    min_addr       : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    min_dist       : out std_logic_vector(C_MEM_IN_WIDTH-1 downto 0)
  );
end comp_bin;

architecture str of comp_bin is

  component comp_lt
    generic (width : positive);
    port (
      bl1    : in  std_logic;
      bl2    : in  std_logic;
      in1    : in  std_logic_vector(width downto 0);
      in2    : in  std_logic_vector(width downto 0);
      lt     : out std_logic;
      output : out std_logic_vector(width downto 0)
    );
  end component;

  constant levels : integer := integer(log2(real(2**C_MEM_ADDR_WIDTH)));
  signal level_out0 : data_bus_mem_out((2**C_MEM_ADDR_WIDTH/2)-1 downto 0);
  signal level_out1 : data_bus_mem_out((2**C_MEM_ADDR_WIDTH/4)-1 downto 0);
  signal level_out2 : data_bus_mem_out((2**C_MEM_ADDR_WIDTH/8)-1 downto 0);
  signal level_out3 : data_bus_mem_out((2**C_MEM_ADDR_WIDTH/16)-1 downto 0);

begin

  U_COMP_ONE : for i in 0 to (2**C_MEM_ADDR_WIDTH/2)-1 generate
    U_COMP_LT : entity work.comp_lt(lev_one)
    generic map (C_MEM_ADDR_WIDTH)
    port map (
      bl1 => done_arr(i),
      bl2 => done_arr((C_MEM_ADDR_WIDTH/2) - 1 - i),
      in1 => mem_out_rd_bus(i),
      in2 => mem_out_rd_bus((C_MEM_ADDR_WIDTH/2) - 1 - i),
      lt  => open,
      output => level_out0(i)
    );
  end generate U_COMP_ONE;


end str;