-- Greg Stitt
-- University of Florida

-- Description:
-- The ram entity implements a ram with a standard 1-read port, 1-write port
-- interface. The ram is configurable in terms of data width (width of each
-- word), the address width, and the number of words. The ram has a write
-- enable for writes, but does not contain a read enable. Instead, the ram
-- reads from the read address every cycle.
--
-- The entity contains several different architectures that implement different
-- ram behaviors. e.g. synchronous reads, asynchronous reads, synchronoous
-- reads during writes.
--

-- Notes:
-- Asychronous reads are not supported by all FPGAs.
--

-------------------------------------------------------------------------------
-- Generics Description
-- word_width        : The width in bits of a single word (required)
-- addr_width        : The width in bits of an address, which also defines the
--                     number of words (required)
-- num_words         : The number of words in the memory. This generic will
--                     usually be 2**addr_width, but the entity supports
--                     non-powers of 2 (required)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Port Description:
-- clk    : clock input
-- wen    : write enable (active high)
-- waddr  : write address
-- wdata  : write data
-- raddr  : read address
-- rdata  : read data
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity ram_conc is
  generic (
    num_words  : positive;
    word_width : positive;
    addr_width : positive
    );
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    -- write port
    wen     : in  std_logic;
    waddr   : in  std_logic_vector(addr_width-1 downto 0);
    wdata   : in  std_logic_vector(word_width-1 downto 0);
    dat_val : in  std_logic;
    data_in : in  data_bus_mem_out(num_words-1 downto 0);

    -- read port
    raddr    : in  std_logic_vector(addr_width-1 downto 0);
    rdata    : out std_logic_vector(word_width-1 downto 0);
    data_out : out data_bus_mem_out(num_words-1 downto 0)
    );
end entity;


-- This architecture uses asynchronous reads that return the read data in the
-- same cycle.
architecture ASYNC_READ of ram_conc is

  --type memory_type is array (natural range <>) of std_logic_vector(word_width-1 downto 0);
  constant dijk_mem_init : std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0) := std_logic_vector((to_unsigned(0, C_MEM_ADDR_WIDTH)) & (to_unsigned(2**C_DATA_WIDTH-1, C_DATA_WIDTH)));
  signal memory : data_bus_mem_out(num_words-1 downto 0);
  
begin

  process(clk, rst)
  begin
    if(rst = '1') then
      memory <= (others => (others => '0'));
    elsif clk'event and clk = '1' then
      if wen = '1' then
        memory <= (others => (dijk_mem_init));
        memory(to_integer(unsigned(waddr))) <= wdata;
      elsif (dat_val = '1') then
        memory <= data_in;
      end if;
    end if;
  end process;

  rdata <= memory(to_integer(unsigned(raddr)));
  data_out <= memory;

end ASYNC_READ;