library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mux is
generic(WIDTH : integer := 16);
port (
    sel  : in  std_logic;
    x, y : in  std_logic_vector(WIDTH-1 downto 0);
    z    : out std_logic_vector(WIDTH-1 downto 0)
);
end entity mux;

architecture behave of mux is begin
	z <= x when sel = '0' else y when sel = '1';	
end behave;
