-- Ricky Tran
-- University of Florida
-- lt.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp_lt is
  generic (width : positive);
  port (
    in1 : in  std_logic_vector(width downto 0);
    in2 : in  std_logic_vector(width downto 0);
    d   : in  std_logic_vector(width downto 0);
    lt  : out std_logic
  );
end comp_lt;

architecture bhv of comp_lt is
begin
  process(in1, in2)
  begin
    if(unsigned(in1) = unsigned(d)) then
      lt <= '0';
    elsif(unsigned(in1) < unsigned(in2)) then
      lt <= '1';
    else
      lt <= '0';
    end if;
  end process;
end bhv;