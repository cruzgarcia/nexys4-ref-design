library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;

entity top is
  generic(
    g_reset_width     : integer := 16
  );
  port(
    -- System clock
    i_clock           : in  std_logic;
    -- Debug LED
    o_debug_led       : out std_logic
  );
end top;

architecture rtl of top is

  -- Constants
  constant c_debug_counter_width    : integer := 32;
  constant c_debug_counter_div_bit  : integer := 24;

  -- Clocking and reset
  signal r_reset_vector     : std_logic_vector(g_reset_width-1 downto 0) := (others => '1');
  signal r_reset            : std_logic;
  -- Debug
  signal r_debug_counter    : std_logic_vector(c_debug_counter_width-1 downto 0);

begin

  -- Reset logic
  proc_reset : process(i_clock)
  begin
    if rising_edge(i_clock)then
      r_reset_vector  <= r_reset_vector(r_reset_vector'high-1 downto 0) & '0';
      r_reset         <= r_reset_vector(r_reset_vector'high);
    end if;
  end process;
  
  -- Debug led
  proc_debug : process(i_clock, r_reset)
  begin
    if(r_reset = '1')then
      r_debug_counter     <= (others => '0');
      o_debug_led         <= '0';
    elsif rising_edge(i_clock)then
      if(r_debug_counter(c_debug_counter_div_bit) = '1')then
        r_debug_counter   <= (others => '0');
        o_debug_led       <= not o_debug_led;
      else
        r_debug_counter   <= r_debug_counter + '1';
      end if;
    end if;
  end process;

END rtl;