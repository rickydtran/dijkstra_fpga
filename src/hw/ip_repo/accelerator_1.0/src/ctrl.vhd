-- Ricky Tran
-- University of Florida
-- ctrl.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity ctrl is
  port(
    clk          : in  std_logic;
    rst          : in  std_logic;
    go           : in  std_logic;
    size         : in  std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
    done         : out std_logic;
    ----Control Signals 
    dp_en        : out std_logic;
    m_en         : out std_logic;
    mem_out_en   : out std_logic;
    valid_out    : out std_logic;
    lt_en        : out std_logic;
    rst_d        : out std_logic
  );
end ctrl;

architecture bhv of ctrl is
  type STATE_TYPE is (S_WAIT_GO_1, S_INIT, S_LOOP_COND, S_POP_MIN, S_UPDATE_DIST, S_STALL_ONE, S_WAIT_DONE, S_WAIT_GO_0);
  signal state, next_state   : STATE_TYPE;
  signal done_s, next_done_s : std_logic;
  signal val, next_val       : std_logic;
  signal count, next_count   : unsigned(C_MEM_ADDR_WIDTH downto 0);
  signal s_rst_d, next_rst_d : std_logic;
begin

  process(clk, rst)
  begin
    if(rst = '1') then
      state  <= S_WAIT_GO_1;
      done_s <= '0';
      val    <= '0';
      s_rst_d <= '1';
      count  <= (others => '0');
    elsif(rising_edge(clk)) then
      state  <= next_state;
      done_s <= next_done_s;
      count  <= next_count;
      val    <= next_val;
      s_rst_d <= next_rst_d;
    end if;
  end process;

  process(go, state, size, count, done_s, val)
  begin
    next_state   <= state;
    next_done_s  <= done_s;
    next_count   <= count;
    next_val     <= val;
    dp_en        <= '0';
    m_en         <= '0';
    next_val     <= '0';
    mem_out_en   <= '0';
    lt_en        <= '0';
    next_rst_d   <= '0';
    case state is
      when S_WAIT_GO_1 =>
        if (go = '1') then
          next_state <= S_INIT;
        end if;
      when S_INIT =>
        mem_out_en   <= '1';
        next_done_s  <= '0';
        next_rst_d   <= '1';
        next_count   <= (others => '0');
        next_state   <= S_LOOP_COND;
      when S_LOOP_COND =>
        if (unsigned(count) = unsigned(size)) then
          next_done_s <= '1';
          dp_en       <= '0';
          next_val    <= '0';
          next_state  <= S_WAIT_GO_0;
        else
          next_state <= S_POP_MIN;
        end if;
      when S_POP_MIN =>
        m_en       <= '1';
        next_state <= S_UPDATE_DIST;
      when S_UPDATE_DIST =>
        dp_en      <= '1';
        next_state <= S_STALL_ONE;
      when S_STALL_ONE =>
        lt_en      <= '1';
        next_val   <= '1';
        next_count <= count + 1;
        next_state <= S_LOOP_COND;
      when S_WAIT_GO_0 =>
        if(go = '0') then
          next_state <= S_WAIT_GO_1;
        end if;
      when others => null;
    end case;
  end process;

  done      <= done_s;
  valid_out <= val;
  rst_d     <= s_rst_d;

end bhv;