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
  
  signal mux_out : data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
  signal bin_tree : data_bus_mem_out(2**C_MEM_ADDR_WIDTH-2 downto 0);

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

  U_COMP_MIN_TREE : for i in 0 to C_MEM_ADDR_WIDTH - 1 generate
    U_COMP_MIN_LEV : for j in 0 to 2**i - 1 generate
      U_LEVEL_0 : if (i = C_MEM_ADDR_WIDTH - 1) generate
        U_COMP_MIN : comp_min
        generic map (C_MEM_OUT_WIDTH)
        port MAP (
          input1 => mux_out(2*j),
          input2 => mux_out(2*j+1),
          output => bin_tree((2**i-1)+j)      
        );
      end generate U_LEVEL_0;
      U_LEVEL_J : if (i < C_MEM_ADDR_WIDTH -1) generate
        U_COMP_MIN : comp_min
        generic map (C_MEM_OUT_WIDTH)
        port MAP (
          input1 => bin_tree(2*((2**i-1)+j)+1),
          input2 => bin_tree(2*((2**i-1)+j)+2),
          output => bin_tree((2**i-1)+j)      
        );
      end generate U_LEVEL_J;
    end generate U_COMP_MIN_LEV;
  end generate U_COMP_MIN_TREE;

  min_addr <= bin_tree(0)(C_MEM_OUT_WIDTH-1 downto C_DATA_WIDTH);
  min_dist <= bin_tree(0)(C_DATA_WIDTH-1 downto 0);

end str;