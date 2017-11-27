-- Greg Stitt
-- University of Florida
-- EEL 5721/4720 Reconfigurable Computing
--
-- File: user_app_tb.vhd
--
-- Description: This file implements a testbench for the simple pipeline
-- when running on the ZedBoard. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity user_app_tb is
end user_app_tb;

architecture behavior of user_app_tb is

  type t_2d_a is array(15 downto 0, 15 downto 0) of integer range 0 to 255;
  constant input_key : t_2d_a := 
  --((    0,   129,   160,   218,   220,    73,    38,    55,    28,   120,   148,   193,   112,     0,   217,    35),
  --(  129,     0,   150,     0,   134,    13,   179,     0,    94,   238,    41,   165,    77,   247,     0,    86),
  --(  160,   150,     0,   175,     0,   154,   106,   253,   251,     0,     0,   178,     9,    86,   188,    70),
  --(  218,     0,   175,     0,   196,    56,   231,   127,    66,   240,     6,   248,   198,   244,   255,   244),
  --(  220,   134,     0,   196,     0,    23,     0,   127,     0,     0,   245,   101,   255,   126,     0,   241),
  --(   73,    13,   154,    56,    23,     0,   116,   127,     0,    48,   197,    72,    51,     0,   205,   102),
  --(   38,   179,   106,   231,     0,   116,     0,    58,   182,     0,   193,    35,   158,   131,   249,    90),
  --(   55,     0,   253,   127,   127,   127,    58,     0,   166,   139,   239,    16,   239,   227,   132,   129),
  --(   28,    94,   251,    66,     0,     0,   182,   166,     0,     0,   152,   227,   226,   245,   201,   165),
  --(  120,   238,     0,   240,     0,    48,     0,   139,     0,     0,   185,   236,   119,   144,     0,     0),
  --(  148,    41,     0,     6,   245,   197,   193,   239,   152,   185,     0,   125,   190,    57,   214,   229),
  --(  193,   165,   178,   248,   101,    72,    35,    16,   227,   236,   125,     0,    55,   210,    31,     0),
  --(  112,    77,     9,   198,   255,    51,   158,   239,   226,   119,   190,    55,     0,    71,   169,   147),
  --(    0,   247,    86,   244,   126,     0,   131,   227,   245,   144,    57,   210,    71,     0,    11,    64),
  --(  217,     0,   188,   255,     0,   205,   249,   132,   201,     0,   214,    31,   169,    11,     0,   232),
  --(   35,    86,    70,   244,   241,   102,    90,   129,   165,     0,   229,     0,   147,    64,   232,     0));

  --((   35,    86,    70,   244,   241,   102,    90,   129,   165,     0,   229,     0,   147,    64,   232,     0),
  --(  217,     0,   188,   255,     0,   205,   249,   132,   201,     0,   214,    31,   169,    11,     0,   232),
  --(    0,   247,    86,   244,   126,     0,   131,   227,   245,   144,    57,   210,    71,     0,    11,    64),
  --(  112,    77,     9,   198,   255,    51,   158,   239,   226,   119,   190,    55,     0,    71,   169,   147),
  --(  193,   165,   178,   248,   101,    72,    35,    16,   227,   236,   125,     0,    55,   210,    31,     0),
  --(  148,    41,     0,     6,   245,   197,   193,   239,   152,   185,     0,   125,   190,    57,   214,   229),
  --(  120,   238,     0,   240,     0,    48,     0,   139,     0,     0,   185,   236,   119,   144,     0,     0),
  --(   28,    94,   251,    66,     0,     0,   182,   166,     0,     0,   152,   227,   226,   245,   201,   165),
  --(   55,     0,   253,   127,   127,   127,    58,     0,   166,   139,   239,    16,   239,   227,   132,   129),
  --(   38,   179,   106,   231,     0,   116,     0,    58,   182,     0,   193,    35,   158,   131,   249,    90),
  --(   73,    13,   154,    56,    23,     0,   116,   127,     0,    48,   197,    72,    51,     0,   205,   102),
  --(  220,   134,     0,   196,     0,    23,     0,   127,     0,     0,   245,   101,   255,   126,     0,   241),
  --(  218,     0,   175,     0,   196,    56,   231,   127,    66,   240,     6,   248,   198,   244,   255,   244),
  --(  160,   150,     0,   175,     0,   154,   106,   253,   251,     0,     0,   178,     9,    86,   188,    70),
  --(  129,     0,   150,     0,   134,    13,   179,     0,    94,   238,    41,   165,    77,   247,     0,    86),
  --(    0,   129,   160,   218,   220,    73,    38,    55,    28,   120,   148,   193,   112,     0,   217,    35));

--((    0,   232,    64,   147,     0,   229,     0,   165,   129,    90,   102,   241,   244,    70,    86,    35),
--(  232,     0,    11,   169,    31,   214,     0,   201,   132,   249,   205,     0,   255,   188,     0,   217),
--(   64,    11,     0,    71,   210,    57,   144,   245,   227,   131,     0,   126,   244,    86,   247,     0),
--(  147,   169,    71,     0,    55,   190,   119,   226,   239,   158,    51,   255,   198,     9,    77,   112),
--(    0,    31,   210,    55,     0,   125,   236,   227,    16,    35,    72,   101,   248,   178,   165,   193),
--(  229,   214,    57,   190,   125,     0,   185,   152,   239,   193,   197,   245,     6,     0,    41,   148),
--(    0,     0,   144,   119,   236,   185,     0,     0,   139,     0,    48,     0,   240,     0,   238,   120),
--(  165,   201,   245,   226,   227,   152,     0,     0,   166,   182,     0,     0,    66,   251,    94,    28),
--(  129,   132,   227,   239,    16,   239,   139,   166,     0,    58,   127,   127,   127,   253,     0,    55),
--(   90,   249,   131,   158,    35,   193,     0,   182,    58,     0,   116,     0,   231,   106,   179,    38),
--(  102,   205,     0,    51,    72,   197,    48,     0,   127,   116,     0,    23,    56,   154,    13,    73),
--(  241,     0,   126,   255,   101,   245,     0,     0,   127,     0,    23,     0,   196,     0,   134,   220),
--(  244,   255,   244,   198,   248,     6,   240,    66,   127,   231,    56,   196,     0,   175,     0,   218),
--(   70,   188,    86,     9,   178,     0,     0,   251,   253,   106,   154,     0,   175,     0,   150,   160),
--(   86,     0,   247,    77,   165,    41,   238,    94,     0,   179,    13,   134,     0,   150,     0,   129),
--(   35,   217,     0,   112,   193,   148,   120,    28,    55,    38,    73,   220,   218,   160,   129,     0));

((    0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,    63,     0,     0,     0),
(    0,     0,   119,    99,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0),
(    0,   119,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0),
(    0,    99,     0,     0,     0,     0,     0,     0,    98,     0,     0,     0,     0,     0,    41,     0),
(    0,     0,     0,     0,     0,     0,     0,     0,     0,    35,     0,     0,     0,     0,     0,     0),
(    0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     4,   167,     0,     0,     0),
(    0,     0,     0,     0,     0,     0,     0,     0,   177,     0,     0,     0,   109,     0,     0,     0),
(    0,     0,     0,     0,     0,     0,     0,     0,     0,   128,     0,     0,     0,     0,     0,     0),
(    0,     0,     0,    98,     0,     0,   177,     0,     0,     2,     0,     0,     0,     0,     0,   151),
(    0,     0,     0,     0,    35,     0,     0,   128,     2,     0,     0,     0,     0,   124,     0,     0),
(    0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,    50,     0,     0,     0),
(    0,     0,     0,     0,     0,     4,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0),
(   63,     0,     0,     0,     0,   167,   109,     0,     0,     0,    50,     0,     0,     0,     0,     0),
(    0,     0,     0,     0,     0,     0,     0,     0,     0,   124,     0,     0,     0,     0,     0,     0),
(    0,     0,     0,    41,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,     0),
(    0,     0,     0,     0,     0,     0,     0,     0,   151,     0,     0,     0,     0,     0,     0,     0));


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

    -- function to check if the outputs is correct
    --function checkOutput (
    --  i : integer)
    --  return integer is

    --begin
    --  return ((i*4) mod 256)*((i*4+1) mod 256) + ((i*4+2) mod 256)*((i*4+3) mod 256);
    --end checkOutput;

    procedure clearMMAP is
    begin
      mmap_rd_en <= '0';
      mmap_wr_en <= '0';
    end clearMMAP;

    variable errors       : integer := 0;
    --variable total_points : real    := 50.0;
    --variable min_grade    : real    := total_points*0.25;
    --variable grade        : real;

    variable result : std_logic_vector(C_MMAP_DATA_WIDTH-1 downto 0);
    variable done   : std_logic;
    variable count  : integer;

  begin

    -- reset circuit  
    rst <= '1';
    clearMMAP;
    wait for 200 ns;

    rst <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';

    -- write contents to input ram, which starts at addr 0
    --for i in 0 to TEST_SIZE-1 loop
      --mmap_wr_addr <= std_logic_vector(to_unsigned(i, C_MMAP_ADDR_WIDTH));
      --mmap_wr_en   <= '1';
      --mmap_wr_data <= std_logic_vector(to_unsigned((i*4) mod 256, 8) &
      --                 to_unsigned((i*4+1) mod 256, 8) &
      --                 to_unsigned((i*4+2) mod 256, 8) &
      --                 to_unsigned((i*4+3) mod 256, 8));
      --wait until clk'event and clk = '1';
      --clearMMAP;
    --end loop;

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

      --if (unsigned(result) /= checkOutput(i)) then
      --  errors := errors + 1;
      --  report "Result for " & integer'image(i) &
      --    " is incorrect. The output is " &
      --    integer'image(to_integer(unsigned(result))) &
      --    " but should be " & integer'image(checkOutput(i));
      --end if;
    end loop;  -- i

    report "SIMULATION FINISHED!!!";

    --grade := total_points-(real(errors)*total_points*0.05);
    --if grade < min_grade then
    --  grade := min_grade;
    --end if;

    --report "TOTAL ERRORS : " & integer'image(errors);
    --report "GRADE = " & integer'image(integer(grade)) & " out of " &
    --  integer'image(integer(total_points));
    sim_done <= '1';
    wait;

  end process;
end behavior;
