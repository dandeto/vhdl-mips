library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_driver is
	port 
	(
		Input  : in integer;
		Output : out std_logic_vector(7 downto 0));
end display_driver;

-- convert decimal (integer) to display on the 7 segment LEDs

architecture behave of display_driver is
begin
	process (Input) begin
		case Input is
			when 0  => Output <= "11000000"; --C0;
			when 1  => Output <= "11111001"; --F9;
			when 2  => Output <= "10100100"; --A4;
			when 3  => Output <= "10110000"; --B0;
			when 4  => Output <= "10011001"; --99;
			when 5  => Output <= "10010010"; --92;
			when 6  => Output <= "10000010"; --82;
			when 7  => Output <= "11111000"; --F8;
			when 8  => Output <= "10000000"; --80;
			when 9	=> Output <= "10010000"; --90;
			when 10 => Output <= "10001000"; --88;
			when 11 => Output <= "10000011"; --83;
			when 12 => Output <= "11000110"; --C6;
			when 13 => Output <= "10100001"; --A1;
			when 14 => Output <= "10000110"; --86;
			when 15 => Output <= "10001110"; --8E;
			when others => Output <= "11111111"; --FF; -- all high means all off
		end case;
	end process;
end behave;
