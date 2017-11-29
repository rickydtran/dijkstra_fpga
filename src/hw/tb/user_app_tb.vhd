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
  ((    0,   156,   147,   169,     4,    35,   173,   124,   242,   165,   237,     6,   171,     0,   237,   116),
   (  156,     0,    18,   196,   235,   146,   140,   231,   161,   100,   247,   225,   224,   130,     0,   127),
   (  147,    18,     0,    21,     0,   181,    35,    92,    14,   142,    12,    60,   234,    36,   191,    17),
   (  169,   196,    21,     0,   134,   170,   176,   114,    64,   144,   187,   131,   211,   133,   128,   250),
   (    4,   235,     0,   134,     0,   235,     9,     5,   160,     0,     9,    35,    91,   168,     0,   174),
   (   35,   146,   181,   170,   235,     0,    54,   178,    35,   120,   119,    95,   178,   182,   202,   207),
   (  173,   140,    35,   176,     9,    54,     0,   227,   169,   183,   224,   130,   229,   108,   132,   138),
   (  124,   231,    92,   114,     5,   178,   227,     0,   195,    24,    86,   155,   181,   226,   224,   227),
   (  242,   161,    14,    64,   160,    35,   169,   195,     0,   246,   243,    40,   241,   172,   169,     6),
   (  165,   100,   142,   144,     0,   120,   183,    24,   246,     0,    51,   246,    81,   246,    13,   113),
   (  237,   247,    12,   187,     9,   119,   224,    86,   243,    51,     0,   127,    71,    90,   206,   125),
   (    6,   225,    60,   131,    35,    95,   130,   155,    40,   246,   127,     0,   135,   244,   132,   245),
   (  171,   224,   234,   211,    91,   178,   229,   181,   241,    81,    71,   135,     0,   138,   233,   223),
   (    0,   130,    36,   133,   168,   182,   108,   226,   172,   246,    90,   244,   138,     0,    76,   160),
   (  237,     0,   191,   128,     0,   202,   132,   224,   169,    13,   206,   132,   233,    76,     0,   143),
   (  116,   127,    17,   250,   174,   207,   138,   227,     6,   113,   125,   245,   223,   160,   143,     0));
   
  type key is array(0 to 15) of integer;
  constant answer_key : key :=
  ( 0, 131115, 655385, 131118, 4, 35, 262157, 262153, 131111, 458785, 262157, 6, 655444, 131133, 589870, 131114 );

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
    for i in 0 to TEST_SIZE-1 loop
      mmap_wr_addr <= C_MEM_IN_SEL_ADDR;
      mmap_wr_en   <= '1';
      mmap_wr_data <= std_logic_vector(to_unsigned(i, C_MMAP_DATA_WIDTH));
      wait until clk'event and clk = '1';
      clearMMAP;
      for j in 0 to TEST_SIZE-1 loop
        mmap_wr_addr <= std_logic_vector(to_unsigned(j, C_MMAP_ADDR_WIDTH));
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(input_key(i, j), 32));
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

    for i in 0 to TEST_SIZE-1 loop
    ---- send go = 1 over memory map
      mmap_wr_addr <= C_MEM_IN_SEL_ADDR;
      mmap_wr_en   <= '1';
      mmap_wr_data <= std_logic_vector(to_unsigned(i, C_MMAP_DATA_WIDTH));
      wait until clk'event and clk = '1';
      clearMMAP;
      for j in 0 to TEST_SIZE-1 loop
        mmap_wr_addr <= std_logic_vector(to_unsigned(j, C_MMAP_ADDR_WIDTH));
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(input_key(i, j), 32));
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
