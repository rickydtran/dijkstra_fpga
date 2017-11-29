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
    mem_out_rd_bus : in  data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
    done_arr       : in  std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
    min_addr       : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    min_dist       : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
  );
end comp_bin;

architecture str of comp_bin is

  component mux_2_1
    generic (width : positive := 32);
    port (
    sel             : in  std_logic;
    input1, input2  : in  std_logic_vector(width-1 downto 0);
    output          : out std_logic_vector(width-1 downto 0)
    );
  end component;

  component comp_min
    generic (width : positive);
    port (
      input1 : in  std_logic_vector(width-1 downto 0);
      input2 : in  std_logic_vector(width-1 downto 0);
      output : out std_logic_vector(width-1 downto 0)
    );
  end component;
  
  -- 4 BIT 16 * 16 SIZE TEST COMPARATOR
  -- constant levels : integer := integer(log2(real(2**C_MEM_ADDR_WIDTH)));

  signal mux_out : data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
  signal level_0 : data_bus_mem_out(((2**C_MEM_ADDR_WIDTH)/2)-1 downto 0); --8
  signal level_1 : data_bus_mem_out(((2**C_MEM_ADDR_WIDTH)/4)-1 downto 0); --4
  signal level_2 : data_bus_mem_out(((2**C_MEM_ADDR_WIDTH)/8)-1 downto 0); --2

  signal s_output : std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0);

begin

  U_MUX_DONE : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
    U_MUX_2_1 : mux_2_1
    generic map (C_MEM_OUT_WIDTH)
    port map (
      sel    => done_arr(i),
      input1(C_MEM_OUT_WIDTH-1 downto C_DATA_WIDTH) => std_logic_vector(to_unsigned(i, C_MEM_ADDR_WIDTH)),
      input1(C_DATA_WIDTH-1 downto 0) => mem_out_rd_bus(i)(C_DATA_WIDTH-1 downto 0),
      input2(C_MEM_OUT_WIDTH-1 downto C_DATA_WIDTH) => std_logic_vector(to_unsigned(i, C_MEM_ADDR_WIDTH)),
      input2(C_DATA_WIDTH-1 downto 0) => std_logic_vector(to_unsigned(2**C_DATA_WIDTH-1, C_DATA_WIDTH)),
      output => mux_out(i)
    );
  end generate U_MUX_DONE;

  U_LEV_ZERO : for i in 0 to ((2**C_MEM_ADDR_WIDTH)/2)-1 generate
    U_COMP_MIN : comp_min
    generic map (C_MEM_OUT_WIDTH)
    port map (
      input1 => mux_out(2*i),
      input2 => mux_out(2*i+1),
      output => level_0(i)
    );
  end generate U_LEV_ZERO;

  U_LEV_ONE : for i in 0 to ((2**C_MEM_ADDR_WIDTH)/4)-1 generate
    U_COMP_MIN : comp_min
    generic map (C_MEM_OUT_WIDTH)
    port map (
      input1 => level_0(2*i),
      input2 => level_0(2*i+1),
      output => level_1(i)
    );
  end generate U_LEV_ONE;

  U_LEV_TWO : for i in 0 to ((2**C_MEM_ADDR_WIDTH)/8)-1 generate
    U_COMP_MIN : comp_min
    generic map (C_MEM_OUT_WIDTH)
    port map (
      input1 => level_1(2*i),
      input2 => level_1(2*i+1),
      output => level_2(i)
    );
  end generate U_LEV_TWO;

  U_COMP_MIN : comp_min
  generic map (C_MEM_OUT_WIDTH)
  port map (
    input1 => level_2(0),
    input2 => level_2(1),
    output => s_output
  );

  min_addr <= s_output(C_MEM_OUT_WIDTH-1 downto C_DATA_WIDTH);
  min_dist <= s_output(C_DATA_WIDTH-1 downto 0);

end str;