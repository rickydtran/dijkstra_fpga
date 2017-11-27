-- Ricky Tran
-- University of Florida
-- comp_min.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity comp_min is
  generic (width : positive);
  port (
    bool1  : in  std_logic;
    bool2  : in  std_logic;
    input1 : in  std_logic_vector(width-1 downto 0);
    input2 : in  std_logic_vector(width-1 downto 0);
    output : out std_logic_vector(width-1 downto 0)
  );
end comp_min;

architecture bhv of comp_min is
begin
  process(bool1, bool2, input1, input2)
  begin
    if(bool1 = '0' and bool2 = '0') then
      if(unsigned(input1(C_MEM_IN_WIDTH-1 downto 0)) < unsigned(input2(C_MEM_IN_WIDTH-1 downto 0))) then
        output <= input1;
      else
        output <= input2;
      end if;
    elsif(bool1 = '1' and bool2 = '1') then
      output <= std_logic_vector(to_unsigned(2**C_MEM_IN_WIDTH-1 ,width));
    elsif(bool1 = '0') then
      output <= input1;
    elsif(bool2 = '0') then
      output <= input2;
    end if;
  end process;
end bhv;