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
    min_dist       : out std_logic_vector(C_MEM_IN_WIDTH-1 downto 0)
  );
end comp_bin;

architecture str of comp_bin is

  component comp_min
    generic (width : positive);
    port (
      bool1  : in  std_logic;
      bool2  : in  std_logic;
      input1 : in  std_logic_vector(width-1 downto 0);
      input2 : in  std_logic_vector(width-1 downto 0);
      output : out std_logic_vector(width-1 downto 0)
    );
  end component;
  
  -- 4 BIT 16 * 16 SIZE TEST COMPARATOR
  -- constant levels : integer := integer(log2(real(2**C_MEM_ADDR_WIDTH)));
  signal level_0 : data_bus_mem_out(((2**C_MEM_ADDR_WIDTH)/2)-1 downto 0); --8
  signal level_1 : data_bus_mem_out(((2**C_MEM_ADDR_WIDTH)/4)-1 downto 0); --4
  signal level_2 : data_bus_mem_out(((2**C_MEM_ADDR_WIDTH)/8)-1 downto 0); --2

  signal s_output : std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0);

begin

  U_LEV_ZERO : for i in 0 to ((2**C_MEM_ADDR_WIDTH)/2)-1 generate
    U_COMP_MIN : comp_min
    generic map (C_MEM_OUT_WIDTH)
    port map (
      bool1  => done_arr(i),
      bool2  => done_arr((2**C_MEM_ADDR_WIDTH-1) - i),
      input1(C_MEM_OUT_WIDTH-1 downto C_MEM_IN_WIDTH) => std_logic_vector(to_unsigned(i, C_MEM_ADDR_WIDTH)),
      input1(C_MEM_IN_WIDTH-1 downto 0) => mem_out_rd_bus(i)(C_MEM_IN_WIDTH-1 downto 0),
      input2(C_MEM_OUT_WIDTH-1 downto C_MEM_IN_WIDTH) => std_logic_vector(to_unsigned((2**C_MEM_ADDR_WIDTH-1) - i, C_MEM_ADDR_WIDTH)),
      input2(C_MEM_IN_WIDTH-1 downto 0) => mem_out_rd_bus((2**C_MEM_ADDR_WIDTH-1) - i)(C_MEM_IN_WIDTH-1 downto 0),
      output => level_0(i)
    );
  end generate U_LEV_ZERO;

  U_LEV_ONE : for i in 0 to ((2**C_MEM_ADDR_WIDTH)/4)-1 generate
    U_COMP_MIN : comp_min
    generic map (C_MEM_OUT_WIDTH)
    port map (
      bool1  => '0',
      bool2  => '0',
      input1 => level_0(i),
      input2 => level_0((((2**C_MEM_ADDR_WIDTH)/2)-1) - i),
      output => level_1(i)
    );
  end generate U_LEV_ONE;

  U_LEV_TWO : for i in 0 to ((2**C_MEM_ADDR_WIDTH)/8)-1 generate
    U_COMP_MIN : comp_min
    generic map (C_MEM_OUT_WIDTH)
    port map (
      bool1  => '0',
      bool2  => '0',
      input1 => level_1(i),
      input2 => level_1((((2**C_MEM_ADDR_WIDTH)/4)-1) - i),
      output => level_2(i)
    );
  end generate U_LEV_TWO;

  U_COMP_MIN : comp_min
  generic map (C_MEM_OUT_WIDTH)
  port map (
    bool1  => '0',
    bool2  => '0',
    input1 => level_2(0),
    input2 => level_2(1),
    output => s_output
  );

  min_addr <= s_output(C_MEM_OUT_WIDTH-1 downto C_MEM_IN_WIDTH);
  min_dist <= s_output(C_MEM_IN_WIDTH-1 downto 0);

end str;