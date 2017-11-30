-- Ricky Tran
-- University of Florida
-- user_app_tb.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity user_app_tb is
end user_app_tb;

architecture tb of user_app_tb is
  type t_2d_a is array(0 to 15, 0 to 15) of integer range 0 to 255;
  constant input_key : t_2d_a :=
  ((    0,     0,     0,     0,     0,     0,     0,   151,     0,     0,     0,     0,     0,     0,     0,     0),
   (    0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,    41,     0,     0,     0),
   (    0,     0,     0,     0,     0,     0,   124,     0,     0,     0,     0,     0,     0,     0,     0,     0),
   (    0,     0,     0,     0,     0,    50,     0,     0,     0,   109,   167,     0,     0,     0,     0,    63),
   (    0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     4,     0,     0,     0,     0,     0),
   (    0,     0,     0,    50,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0),
   (    0,     0,   124,     0,     0,     0,     0,     2,   128,     0,     0,    35,     0,     0,     0,     0),
   (  151,     0,     0,     0,     0,     0,     2,     0,     0,   177,     0,     0,    98,     0,     0,     0),
   (    0,     0,     0,     0,     0,     0,   128,     0,     0,     0,     0,     0,     0,     0,     0,     0),
   (    0,     0,     0,   109,     0,     0,     0,   177,     0,     0,     0,     0,     0,     0,     0,     0),
   (    0,     0,     0,   167,     4,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0),
   (    0,     0,     0,     0,     0,     0,    35,     0,     0,     0,     0,     0,     0,     0,     0,     0),
   (    0,    41,     0,     0,     0,     0,     0,    98,     0,     0,     0,     0,     0,     0,    99,     0),
   (    0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,   119,     0),
   (    0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,    99,   119,     0,     0),
   (    0,     0,     0,    63,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0));
   
  type key is array(0 to 15) of integer;
  constant answer_key : key :=
  ( 0, 786722, 393493, 590261, 655968, 197095, 458905, 151, 393497, 459080, 197212, 393404, 459001, 917971, 786780, 197108 );

  constant TEST_SIZE : integer := 16;
  constant MAX_CYCLES : integer  := TEST_SIZE*4;

  signal clk : std_logic := '0';
  signal rst : std_logic := '1';

  signal mmap_wr_en   : std_logic                         := '0';
  signal mmap_wr_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
  signal mmap_wr_data : std_logic_vector(MMAP_DATA_RANGE) := (others => '0');

  signal mmap_rd_en   : std_logic                         := '0';
  signal mmap_rd_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
  signal mmap_rd_data : std_logic_vector(MMAP_DATA_RANGE);

  signal sim_done : std_logic := '0';

begin

  UUT : entity work.user_app
    port map (
      clk          => clk,
      rst          => rst,
      mmap_wr_en   => mmap_wr_en,
      mmap_wr_addr => mmap_wr_addr,
      mmap_wr_data => mmap_wr_data,
      mmap_rd_en   => mmap_rd_en,
      mmap_rd_addr => mmap_rd_addr,
      mmap_rd_data => mmap_rd_data);

  -- toggle clock
  clk <= not clk after 5 ns when sim_done = '0' else clk;

  -- process to test different inputs
  process

    procedure clearMMAP is
    begin
      mmap_rd_en <= '0';
      mmap_wr_en <= '0';
    end clearMMAP;

    variable errors : integer := 0;

    variable result : std_logic_vector(C_MMAP_DATA_WIDTH-1 downto 0);
    variable done   : std_logic;
    variable count  : integer;

  begin
    report "============================SIMULATION START============================" severity note;
    -- reset circuit  
    rst <= '1';
    clearMMAP;
    wait for 200 ns;

    rst <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    -- write contents to input ram, which starts at addr 0
    for i in 0 to (TEST_SIZE / 4) - 1 loop
      mmap_wr_addr <= C_MEM_IN_SEL_ADDR;
      mmap_wr_en   <= '1';
      mmap_wr_data <= std_logic_vector(to_unsigned(i, C_MMAP_DATA_WIDTH));
      wait until clk'event and clk = '1';
      clearMMAP;
      for j in 0 to TEST_SIZE - 1 loop
        mmap_wr_addr <= std_logic_vector(to_unsigned(j, C_MMAP_ADDR_WIDTH));
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(input_key(4*i, j), 8) &
                                         to_unsigned(input_key(4*i+1, j), 8) &
                                         to_unsigned(input_key(4*i+2, j), 8) &
                                         to_unsigned(input_key(4*i+3, j), 8));
        wait until clk'event and clk = '1';
        clearMMAP;
      end loop;      
    end loop;

    -- send size
    mmap_wr_addr <= C_SIZE_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(TEST_SIZE, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;

    -- send src
    mmap_wr_addr <= C_SRC_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(0, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;

    ---- send go = 1 over memory map
    mmap_wr_addr <= C_GO_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(1, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;
    
    done  := '0';
    count := 0;

    -- read the done signal every cycle to see if the circuit has
    -- completed.
    --
    -- equivalent to wait until (done = '1') for TIMEOUT;      
    while done = '0' and count < MAX_CYCLES loop

      mmap_rd_addr <= C_DONE_ADDR;
      mmap_rd_en   <= '1';
      wait until clk'event and clk = '1';
      clearMMAP;
      -- give entity one cycle to respond
      wait until clk'event and clk = '1';
      done         := mmap_rd_data(0);
      count        := count + 1;
    end loop;

    if (done /= '1') then
      errors := errors + 1;
      report "Done signal not asserted before timeout.";
    end if;

    -- read outputs from output memory
    for i in 0 to TEST_SIZE-1 loop
      mmap_rd_addr   <= std_logic_vector(to_unsigned(i, C_MMAP_ADDR_WIDTH));
      mmap_rd_en     <= '1';            
      wait until clk'event and clk = '1';
      clearMMAP;
      -- give entity one cycle to respond
      wait until clk'event and clk = '1';
      result := mmap_rd_data;

      if (unsigned(result) /= answer_key(i)) then
        errors := errors + 1;
        report "Result for " & integer'image(i) &
          " is incorrect. The output is " &
          integer'image(to_integer(unsigned(result))) &
          " but should be " & integer'image(answer_key(i));
      end if;
    end loop;  -- i

    for i in 0 to 255 loop
      wait until rising_edge(clk);
    end loop;

    -- write contents to input ram, which starts at addr 0
    for i in 0 to (TEST_SIZE / 4) - 1 loop
      mmap_wr_addr <= C_MEM_IN_SEL_ADDR;
      mmap_wr_en   <= '1';
      mmap_wr_data <= std_logic_vector(to_unsigned(i, C_MMAP_DATA_WIDTH));
      wait until clk'event and clk = '1';
      clearMMAP;
      for j in 0 to TEST_SIZE - 1 loop
        mmap_wr_addr <= std_logic_vector(to_unsigned(j, C_MMAP_ADDR_WIDTH));
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(input_key(j, 4*i), 8) &
                                         to_unsigned(input_key(j, 4*i+1), 8) &
                                         to_unsigned(input_key(j, 4*i+2), 8) &
                                         to_unsigned(input_key(j, 4*i+3), 8));
        wait until clk'event and clk = '1';
        clearMMAP;
      end loop;      
    end loop;

    -- send size
    mmap_wr_addr <= C_SIZE_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(TEST_SIZE, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;

    -- send src
    mmap_wr_addr <= C_SRC_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(0, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;

    ---- send go = 1 over memory map
    mmap_wr_addr <= C_GO_ADDR;
    mmap_wr_en   <= '1';
    mmap_wr_data <= std_logic_vector(to_unsigned(1, C_MMAP_DATA_WIDTH));
    wait until clk'event and clk = '1';
    clearMMAP;

    for i in 0 to 255 loop
      wait until rising_edge(clk);
    end loop;
    
    done  := '0';
    count := 0;

    -- read the done signal every cycle to see if the circuit has
    -- completed.
    --
    -- equivalent to wait until (done = '1') for TIMEOUT;      
    while done = '0' and count < MAX_CYCLES loop

      mmap_rd_addr <= C_DONE_ADDR;
      mmap_rd_en   <= '1';
      wait until clk'event and clk = '1';
      clearMMAP;
      -- give entity one cycle to respond
      wait until clk'event and clk = '1';
      done         := mmap_rd_data(0);
      count        := count + 1;
    end loop;

    if (done /= '1') then
      errors := errors + 1;
      report "Done signal not asserted before timeout.";
    end if;

    -- read outputs from output memory
    for i in 0 to TEST_SIZE-1 loop
      mmap_rd_addr   <= std_logic_vector(to_unsigned(i, C_MMAP_ADDR_WIDTH));
      mmap_rd_en     <= '1';            
      wait until clk'event and clk = '1';
      clearMMAP;
      -- give entity one cycle to respond
      wait until clk'event and clk = '1';
      result := mmap_rd_data;

      if (unsigned(result) /= answer_key(i)) then
        errors := errors + 1;
        report "Result for " & integer'image(i) &
          " is incorrect. The output is " &
          integer'image(to_integer(unsigned(result))) &
          " but should be " & integer'image(answer_key(i));
      end if;
    end loop;  -- i

    report "SIMULATION FINISHED!!!";
    report "TOTAL ERRORS : " & integer'image(errors);
    report "=============================SIMULATION END=============================" severity note;
    sim_done <= '1';
    wait;

  end process;
end tb;
