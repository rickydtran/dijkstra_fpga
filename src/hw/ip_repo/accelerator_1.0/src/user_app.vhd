-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity user_app is
  port (
    clk : in std_logic;
    rst : in std_logic;

    -- memory-map interface
    mmap_wr_en   : in  std_logic;
    mmap_wr_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
    mmap_wr_data : in  std_logic_vector(MMAP_DATA_RANGE);
    mmap_rd_en   : in  std_logic;
    mmap_rd_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
    mmap_rd_data : out std_logic_vector(MMAP_DATA_RANGE)
    );
end user_app;

architecture default of user_app is

  component memory_map
    port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    wr_en   : in  std_logic;
    wr_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
    wr_data : in  std_logic_vector(MMAP_DATA_RANGE);
    rd_en   : in  std_logic;
    rd_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
    rd_data : out std_logic_vector(MMAP_DATA_RANGE);

    -- app-specific signals
    go              : out std_logic;
    size            : out std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
    src             : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    done            : in  std_logic;
    mem_in_wr_data  : out std_logic_vector(31 downto 0);
    mem_in_wr_addr  : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    mem_in_wr_en    : out std_logic;
    mem_in_sel      : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    mem_out_rd_data : in  std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0);
    mem_out_rd_addr : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0)
    );
  end component;

  component ram
    generic (
      num_words  : positive;
      word_width : positive;
      addr_width : positive
      );
    port (
      clk   : in  std_logic;
      -- write port
      wen   : in  std_logic;
      waddr : in  std_logic_vector(addr_width-1 downto 0);
      wdata : in  std_logic_vector(word_width-1 downto 0);
      -- read port
      raddr : in  std_logic_vector(addr_width-1 downto 0);
      rdata : out std_logic_vector(word_width-1 downto 0)
      );
  end component;

  component ram_conc
    generic (
      num_words  : positive;
      word_width : positive;
      addr_width : positive
      );
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      -- write port
      wen      : in  std_logic;
      waddr    : in  std_logic_vector(addr_width-1 downto 0);
      wdata    : in  std_logic_vector(word_width-1 downto 0);
      dat_val  : in  std_logic;
      data_in  : in  data_bus_mem_out(num_words-1 downto 0);
      -- read port
      raddr    : in  std_logic_vector(addr_width-1 downto 0);
      rdata    : out std_logic_vector(word_width-1 downto 0);
      data_out : out data_bus_mem_out(num_words-1 downto 0)
      );
  end component;

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

  component datapath
    generic (width : positive);
      port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        en             : in  std_logic;
        m_en           : in  std_logic;

        rst_d          : in  std_logic;
        valid_in       : in  std_logic;

        mem_in_rd_data : in  data_bus_type(2**C_MEM_ADDR_WIDTH-1 downto 0);
        mem_out_rd_bus : in  data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
        mem_in_rd_addr : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
        mem_out_wr_bus : out data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0)
      );
  end component;

  component ctrl
    port(
      clk          : in  std_logic;
      rst          : in  std_logic;
      go           : in  std_logic;
      size         : in  std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
      done         : out std_logic;
      ----Control Signals
      dp_en        : out std_logic;
      m_en         : out std_logic;
      mem_out_en   : out std_logic;
      valid_out    : out std_logic;
      rst_d        : out std_logic
    );
  end component;

  constant ZERO : std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(0, C_MEM_OUT_WIDTH));

  signal go                    : std_logic;
  signal size                  : std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
  signal done                  : std_logic;
  signal src                   : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);

  signal mem_in_wr_data        : std_logic_vector(31 downto 0);
  signal mem_in_wr_addr        : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
  --signal mem_in_rd_data       : std_logic_vector(C_MEM_IN_WIDTH-1 downto 0);
  signal mem_in_rd_data        : data_bus_type(2**C_MEM_ADDR_WIDTH-1 downto 0) := (others => (others => '0'));

  signal mem_in_rd_addr        : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
  signal mem_in_wr_en          : std_logic;
  signal mem_in_wr_en_arr      : std_logic_vector((2**C_MEM_ADDR_WIDTH / 4) - 1 downto 0);
  --signal mem_in_rd_addr_valid : std_logic;

  --signal mem_out_wr_data       : std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0);
  signal mem_out_wr_addr       : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
  signal mem_out_rd_data       : std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0);
  signal mem_out_rd_addr       : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
  signal mem_out_wr_en         : std_logic;
  signal mem_out_wr_data_valid : std_logic;

  signal s_mem_out_wr_bus      : data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);
  signal s_mem_out_rd_bus      : data_bus_mem_out(2**C_MEM_ADDR_WIDTH-1 downto 0);

  signal mem_in_sel            : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
  signal dp_en, m_en           : std_logic;
  signal valid_out             : std_logic;
  signal rst_d                 : std_logic;

begin

  U_MEM_IN_SEL : process(mem_in_sel, mem_in_wr_en)
  begin
    if(mem_in_wr_en = '1') then
      mem_in_wr_en_arr <= (others => '0');
      mem_in_wr_en_arr(to_integer(unsigned(mem_in_sel))) <= '1';
    else
      mem_in_wr_en_arr <= (others => '0');
    end if;
  end process;

  U_MMAP : memory_map
    port map (
      clk     => clk,
      rst     => rst,
      wr_en   => mmap_wr_en,
      wr_addr => mmap_wr_addr,
      wr_data => mmap_wr_data,
      rd_en   => mmap_rd_en,
      rd_addr => mmap_rd_addr,
      rd_data => mmap_rd_data,
    -- TODO: connect to appropriate logic
      go              => go,         
      size            => size,
      src             => src,      
      done            => done,       
    -- already connected to block RAMs
    -- the memory` map functionality writes to the input ram
    -- and reads from the output ram
      mem_in_wr_data  => mem_in_wr_data,
      mem_in_wr_addr  => mem_in_wr_addr,
      mem_in_wr_en    => mem_in_wr_en,
      mem_in_sel      => mem_in_sel,
      mem_out_rd_data => mem_out_rd_data,
      mem_out_rd_addr => mem_out_rd_addr
      );

  U_MEM_IN : for i in 0 to ((2**C_MEM_ADDR_WIDTH / 4) - 1) generate
    U_RAM : entity work.ram(ASYNC_READ)
      generic map (
        num_words  => 2**C_MEM_ADDR_WIDTH,
        word_width => 32,
        addr_width => C_MEM_ADDR_WIDTH)
      port map (
        clk   => clk,
        wen   => mem_in_wr_en_arr(i),
        waddr => mem_in_wr_addr,
        wdata => mem_in_wr_data,
        raddr => mem_in_rd_addr,  -- TODO: connect to input address generator
        rdata(31 downto 24) => mem_in_rd_data(4*i)(C_MEM_IN_WIDTH-1 downto 0), 
        rdata(23 downto 16) => mem_in_rd_data(4*i+1)(C_MEM_IN_WIDTH-1 downto 0),
        rdata(15 downto 8)  => mem_in_rd_data(4*i+2)(C_MEM_IN_WIDTH-1 downto 0),
        rdata(7 downto 0)   => mem_in_rd_data(4*i+3)(C_MEM_IN_WIDTH-1 downto 0)); -- TODO: connect to pipeline input
  end generate U_MEM_IN;

  U_MEM_OUT : ram_conc
    generic map (
      num_words  => 2**C_MEM_ADDR_WIDTH,
      word_width => C_MEM_OUT_WIDTH,
      addr_width => C_MEM_ADDR_WIDTH)
    port map (
      clk      => clk,
      rst      => rst,
      wen      => mem_out_wr_en,
      waddr    => mem_out_wr_addr,  -- TODO: connect to output address generator
      wdata    => ZERO,  -- TODO: connect to pipeline output
      dat_val  => mem_out_wr_data_valid,
      data_in  => s_mem_out_wr_bus,
      raddr    => mem_out_rd_addr,
      rdata    => mem_out_rd_data,
      data_out => s_mem_out_rd_bus);

  U_DATAPATH : datapath
    generic map (C_DATA_WIDTH)
    port map (
      clk             => clk,
      rst             => rst,
      en              => dp_en,
      m_en            => m_en,
      mem_in_rd_addr  => mem_in_rd_addr,
      mem_in_rd_data  => mem_in_rd_data,
      mem_out_wr_bus  => s_mem_out_wr_bus,
      mem_out_rd_bus  => s_mem_out_rd_bus,
      valid_in        => valid_out,
      rst_d           => rst_d);
  ------------------------------------------------------------------------------

  U_CTRL : ctrl
    port map (
      clk          => clk,
      rst          => rst,
      go           => go,
      size         => size,
      done         => done,
      dp_en        => dp_en,
      m_en         => m_en,
      mem_out_en   => mem_out_wr_en,
      valid_out    => valid_out,
      rst_d        => rst_d);

  mem_out_wr_addr       <= src;
  mem_out_wr_data_valid <= valid_out;
    
end default;
