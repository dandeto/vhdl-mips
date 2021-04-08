use WORK.all;
library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_TEST_BENCH is
end MUX_TEST_BENCH;

architecture  TEST of MUX_TEST_BENCH is
  signal sel  : std_logic;
  signal x, y : std_logic_vector(16-1 downto 0);
  signal z    : std_logic_vector(16-1 downto 0);

begin
  mux : entity work.mux(behave)
        generic map (16)
        port map (sel, x, y, z);

    -- test
    process begin
      sel <= '0';
      x <= "0000000000000011"; -- I know width is 16 bits
      y <= "0000000000001111";
      wait for 1 ns;
      x <= "0000000100010011";
      wait for 1 ns;
      y <= "0000000000001010";
      wait for 1 ns;
      sel <= '1';
      wait for 1 ns;
      x <= "0000000000010000";
      wait for 1 ns;
      y <= "0000000000000100";
    end process;
end TEST;
