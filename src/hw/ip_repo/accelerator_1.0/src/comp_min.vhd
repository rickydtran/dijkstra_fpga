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
    input1 : in  std_logic_vector(width-1 downto 0);
    input2 : in  std_logic_vector(width-1 downto 0);
    output : out std_logic_vector(width-1 downto 0)
  );
end comp_min;

architecture bhv of comp_min is
begin
  process(input1, input2)
  begin
    if(unsigned(input1(C_DATA_WIDTH-1 downto 0)) < unsigned(input2(C_DATA_WIDTH-1 downto 0))) then
      output <= input1;
    else
      output <= input2;
    end if;    
  end process;
end bhv;