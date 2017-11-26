-- Ricky Tran
-- University of Florida
-- add_pipe.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_pipe is
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
end add_pipe;

architecture bhv of add_pipe is
begin
  process(clk, rst)
  begin
    if(rst = '1') then
      output <= (others => '0');
    elsif(rising_edge(clk)) then
      if(en = '1') then
        output <= std_logic_vector(resize(unsigned(in1), width+1) + resize(unsigned(in2), width+1));
      end if;
    end if;
  end process;
end bhv;