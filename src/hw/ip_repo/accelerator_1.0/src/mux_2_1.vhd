-- Ricky Tran
-- University of Florida
-- mux_2_1.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2_1 is
  generic (width : positive := 32);
  port (
  sel             : in  std_logic;
  input1, input2  : in  std_logic_vector(width-1 downto 0);
  output          : out std_logic_vector(width-1 downto 0)
  );
end mux_2_1;

architecture bhv of mux_2_1 is
begin
  process(sel, input1, input2)
  begin
  case sel is
    when '0' => output <= input1;
    when '1' => output <= input2;
    when others => null;
  end case;
  end process;
end bhv;