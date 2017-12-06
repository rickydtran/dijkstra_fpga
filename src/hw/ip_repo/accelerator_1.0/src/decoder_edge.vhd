-- Ricky Tran
-- University of Florida
-- decode_edge.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity decoder_edge is
  port (
    rst                : in  std_logic;  
    mem_in_wr_en       : in  std_logic;
    edge_in            : in  std_logic_vector(MMAP_DATA_RANGE);
    mem_in_wr_en_arr   : out std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
    mem_in_wr_addr_sel : out std_logic_vector(2**C_MEM_ADDR_WIDTH-1 downto 0);
    wr_addr0           : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    wr_addr1           : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0));
end decoder_edge;

architecture bhv of decoder_edge is
begin

wr_addr0 <= edge_in((2*C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH)-1 downto (C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH)); --19 downto 14
wr_addr1 <= edge_in((C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH)-1 downto C_MEM_IN_WIDTH); -- 13 downto 8
--data <= edge_in(C_MEM_IN_WIDTH-1 downto 0); -- 7 downto 0

process(rst, mem_in_wr_en, edge_in)
begin
  if (rst = '1') then
    mem_in_wr_en_arr <= (others => '0');
    mem_in_wr_addr_sel <= (others => '0');
  elsif (mem_in_wr_en = '1') then
    mem_in_wr_en_arr <= (others => '0');
    mem_in_wr_addr_sel <= (others => '0');
    mem_in_wr_en_arr(to_integer(unsigned(edge_in((2*C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH)-1 downto (C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH))))) <= '1';
    mem_in_wr_en_arr(to_integer(unsigned(edge_in((C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH)-1 downto C_MEM_IN_WIDTH)))) <= '1';
    mem_in_wr_addr_sel(to_integer(unsigned(edge_in((2*C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH)-1 downto (C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH))))) <= '1';
    mem_in_wr_addr_sel(to_integer(unsigned(edge_in((C_MEM_ADDR_WIDTH + C_MEM_IN_WIDTH)-1 downto C_MEM_IN_WIDTH)))) <= '0';
  else
    mem_in_wr_en_arr <= (others => '0');
    mem_in_wr_addr_sel <= (others => '0');
  end if;
end process;

end bhv;

