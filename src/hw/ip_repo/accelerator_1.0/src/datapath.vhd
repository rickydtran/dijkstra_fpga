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
    clk            : in  std_logic;
    rst            : in  std_logic;
    en             : in  std_logic;
    m_en           : in  std_logic;

    rst_d          : in  std_logic;
    lt_en          : in  std_logic;
    valid_in       : in  std_logic;

    mem_in_rd_data : in  data_bus_type(2**C_MEM_ADDR_WIDTH-1 downto 0);
    mem_out_rd_bus : in  data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
    mem_in_rd_addr : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    mem_out_wr_bus : out data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0)
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

  component comp_bin
    port (
      mem_out_rd_bus : in  data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
      done_arr       : in  std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
      min_addr       : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
      min_dist       : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
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
      d   : in  std_logic_vector(width downto 0);
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

  signal min_dist_in : std_logic_vector(C_DATA_WIDTH-1 downto 0);
  signal min_addr_in : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);

  signal min_dist    : std_logic_vector(C_DATA_WIDTH-1 downto 0);
  signal min_addr    : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);

  signal add_buf_out : data_bus_plus(2**C_MEM_ADDR_WIDTH-1 downto 0);

  signal lt_in       : std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
  signal lt_out      : std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);

  signal done_in     : std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
  signal done_out    : std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);

  signal prev        : data_bus_addr(2**C_MEM_ADDR_WIDTH-1 downto 0);
  signal dist        : data_bus_type(2**C_MEM_ADDR_WIDTH-1 downto 0);

begin

  U_TEST_SIG : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
    prev(i) <= mem_out_rd_bus(i)(C_MEM_OUT_WIDTH-1 downto C_DATA_WIDTH);
    dist(i) <= mem_out_rd_bus(i)(C_DATA_WIDTH-1 downto 0);
  end generate U_TEST_SIG;

  U_COMP_BIN : comp_bin
    port map (
      mem_out_rd_bus => mem_out_rd_bus,
      done_arr       => done_out,
      min_addr       => min_addr_in,
      min_dist       => min_dist_in
    );

  U_REG_MIN_ADDR : reg
    generic map (C_MEM_ADDR_WIDTH)
    port map (
      clk    => clk,
      rst    => rst,
      en     => m_en,
      input  => min_addr_in,
      output => min_addr
    );

  U_REG_MIN_DIST : reg
    generic map (C_DATA_WIDTH)
    port map (
      clk    => clk,
      rst    => rst,
      en     => m_en,
      input  => min_dist_in,
      output => min_dist
    );


  done_in <= (done_out or std_logic_vector(shift_left(to_unsigned(1, done_out'length), 
              to_integer(unsigned(min_addr_in))))) when rst_d = '0' else (others => '0');

  U_REG_DONE_BUF : reg
    generic map (2**C_MEM_ADDR_WIDTH)
    port map (
      clk    => clk,
      rst    => rst_d,
      en     => m_en,
      input  => done_in,
      output => done_out
    );

  mem_in_rd_addr <= min_addr;

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

  U_REG_LT_BUF : reg
    generic map (2**C_MEM_ADDR_WIDTH)
    port map (
      clk    => clk,
      rst    => rst,
      en     => lt_en,
      input  => lt_in,
      output => lt_out
    );

  U_COMP : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
    U_COMP_LT : comp_lt
    generic map (width)
    port map (
      in1 => add_buf_out(i),
      in2(width) => '0',
      in2(width-1 downto 0) => mem_out_rd_bus(i)(C_DATA_WIDTH-1 downto 0), --Remember to change to parallel dist vector
      d(width) => '0',
      d(width-1 downto 0)  => min_dist,
      lt  => lt_in(i)
    );
  end generate U_COMP;

  U_MUX_OUT : for i in 0 to 2**C_MEM_ADDR_WIDTH-1 generate
    U_MUX_2_1 : mux_2_1
    generic map (C_MEM_OUT_WIDTH)
    port map (
      sel => lt_out(i),
      input1 => mem_out_rd_bus(i), --dist
      input2(C_MEM_OUT_WIDTH-1 downto C_DATA_WIDTH) => min_addr,
      input2(C_DATA_WIDTH-1 downto 0) => add_buf_out(i)(C_DATA_WIDTH-1 downto 0),
      output => mem_out_wr_bus(i)
    );
  end generate U_MUX_OUT;

end str;