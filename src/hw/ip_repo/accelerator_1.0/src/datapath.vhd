-- Ricky Tran
-- University of Florida
-- datapath.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity datapath is
  generic (width : positive);
  port (
    clk : in  std_logic;
    rst : in  std_logic;
    en  : in  std_logic;

    mem_in_rd_addr : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    mem_in_rd_data : in  data_bus_type(2**C_MEM_ADDR_WIDTH-1 downto 0);

    mem_out_wr_bus : out  data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
    mem_out_rd_bus : in   data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
    valid_in : in std_logic
  );
end datapath;

architecture str of datapath is

  component reg
    generic(
      width  :     positive
    );
    port(
      clk    : in  std_logic;
      rst    : in  std_logic;
      en     : in  std_logic;
      input  : in  std_logic_vector(width-1 downto 0);
      output : out std_logic_vector(width-1 downto 0)
    );
  end component;

  component add_pipe
    generic(
      width : positive := 16
    );
    port(
      clk    : in  std_logic;
      rst    : in  std_logic;
      en     : in  std_logic;
      in1    : in  std_logic_vector(width-1 downto 0);
      in2    : in  std_logic_vector(width-1 downto 0);
      output : out std_logic_vector(width downto 0)
    );
  end component;

  component comp_lt
    generic (width : positive);
    port (
      in1 : in  std_logic_vector(width downto 0);
      in2 : in  std_logic_vector(width downto 0);
      lt  : out std_logic
    );
  end component;

  component mux_2_1
    generic (width : positive := 32);
    port (
    sel             : in  std_logic;
    input1, input2  : in  std_logic_vector(width-1 downto 0);
    output          : out std_logic_vector(width-1 downto 0)
    );
  end component;

  signal min_dist : std_logic_vector(C_MEM_IN_WIDTH-1 downto 0);
  signal min_addr : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);

  signal add_buf_out : data_bus_plus(2**C_MEM_ADDR_WIDTH-1 downto 0);
  signal lt   : std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
  --signal lt_in    : std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
  --signal lt_out   : std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
  signal done_arr : std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);

begin

  U_REG_MIN_ADDR : reg
    generic map (C_MEM_ADDR_WIDTH)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      input  => std_logic_vector(to_unsigned(1, C_MEM_ADDR_WIDTH)),
      output => min_addr
    );

  U_REG_MIN_DIST : reg
    generic map (C_MEM_IN_WIDTH)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      input  => std_logic_vector(to_unsigned(0, C_MEM_IN_WIDTH)),
      output => min_dist
    );

  process(rst, min_addr, en, valid_in)
  begin
    if(rst = '1') then
      done_arr <= (others => '0');
    else
      if(en = '1' and valid_in = '1') then
        done_arr(to_integer(unsigned(min_addr))) <= '1';
      end if;
    end if;
  end process;

  mem_in_rd_addr <= min_addr;
  --mem_out_wr_bus <= (others => (others => '0')) when rst = '1';

  U_ADD_BUF : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
    U_ADD_PIPE : add_pipe
    generic map (width)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      in1    => mem_in_rd_data(i),
      in2    => min_dist,
      output => add_buf_out(i)
    );
  end generate U_ADD_BUF;

  --U_REG : reg
  --  generic map (2**C_MEM_ADDR_WIDTH)
  --  port map (
  --    clk    => clk,
  --    rst    => rst,
  --    en     => en,
  --    input  => lt_in,
  --    output => lt_out
  --  );

  U_COMP : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
    U_COMP_LT : comp_lt
    generic map (width)
    port map (
      in1 => add_buf_out(i),
      in2(width) => '0',
      in2(width-1 downto 0) => mem_out_rd_bus(i)(C_MEM_IN_WIDTH-1 downto 0), --Remember to change to parallel dist vector
      --lt  => lt_in(i)
      lt => lt(i)
    );
  end generate U_COMP;

  U_MUX_OUT : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
    U_MUX_2_1 : mux_2_1
    generic map (C_MEM_OUT_WIDTH)
    port map (
      --sel    => lt_out(i),
      sel => lt(i),
      input1 => mem_out_rd_bus(i), --dist
      input2(C_MEM_OUT_WIDTH-1 downto C_MEM_IN_WIDTH) => min_addr,
      input2(C_MEM_IN_WIDTH-1 downto 0) => add_buf_out(i)(C_MEM_IN_WIDTH-1 downto 0),
      output => mem_out_wr_bus(i)
    );
  end generate U_MUX_OUT;

  --U_MUX_D : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
  --  U_MUX_2_1 : mux_2_1
  --  generic map (C_MEM_OUT_WIDTH)
  --  port map (
  --    sel    => lt_out(i),
  --    input1 => mem_out_rd_bus(i)(C_MEM_IN_WIDTH-1 downto 0), --dist
  --    input2 => add_buf_out(i)(width-1 downto 0),
  --    output => mem_out_wr_bus(i)(C_MEM_IN_WIDTH-1 downto 0)
  --  );
  --end generate U_MUX_D;

  --U_MUX_P : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
  --  U_MUX_2_1 : mux_2_1
  --  generic map (C_MEM_OUT_WIDTH)
  --  port map (
  --    sel    => lt_out(i),
  --    input1 => mem_out_rd_bus(i)(C_MEM_ADDR_WIDTH-1 downto 0), --prev(u)
  --    input2 => min_addr,
  --    output => mem_out_wr_bus(i)(C_MEM_ADDR_WIDTH-1 downto 0)
  --  );
  --end generate U_MUX_P;


end str;