library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity memory is
    port
    (
        clk : in std_logic;
        reset : in std_logic;
        memWrite : in std_logic;
        memRead : in std_logic;
        address : in std_logic_vector(7 downto 0);
        B : in std_logic_vector(31 downto 0);
        memData : out std_logic_vector(31 downto 0)
    );
end memory;

architecture behave of memory is
    type memory_block is array (0 to 255) of std_logic_vector(31 downto 0); -- define memory block type
    signal mem : memory_block; -- data and instruction memory
    signal DEBUG : std_logic_vector(31 downto 0); 
begin
    -- could send debug to display.
    DEBUG <= mem(72);

    write_to_mem : process(clk, reset) begin -- handle writes to memory
        if rising_edge(clk) then 
            if reset = '1' then -- power on reset
                mem(0) <= x"00000001"; -- data memory
                mem(1) <= x"00000000";
                mem(2) <= x"00000000";
                mem(3) <= x"00000000";
                mem(4) <= x"00000001";
                mem(5) <= x"00000000";
                mem(6) <= x"00000000";
                mem(7) <= x"00000000";
                mem(8) <= x"00000001";
                mem(9) <= x"00000000";
                mem(10) <= x"00000000";
                mem(11) <= x"00000000";
                mem(12) <= x"00000001";
                mem(13) <= x"00000000";
                mem(14) <= x"00000000";
                mem(15) <= x"00000000";

                mem(64) <= x"00000010";
                mem(68) <= x"00000001";
                mem(72) <= x"00000001";

                mem(128) <= x"00004020"; -- instruction memory
                mem(129) <= x"00007020";
                mem(130) <= x"8D090040";
                mem(131) <= x"8D0A0044";
                mem(132) <= x"8D0B0048";
                mem(133) <= x"AD00004C";
                mem(134) <= x"8D0C0000";
                mem(135) <= x"8DCD004C";
                mem(136) <= x"01AC6820";
                mem(137) <= x"ADCD004C";
                mem(138) <= x"012A4822";
                mem(139) <= x"010B4020";
                mem(140) <= x"11200001";
                mem(141) <= x"1129FFF8";
            
            elsif(memWrite = '1') then 
                mem(to_integer(unsigned(address))) <= B;
            end if;
        end if;
    end process;

   memData <= mem(to_integer(unsigned(address))) when (memRead = '1') else "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"; -- read from memory

end architecture;