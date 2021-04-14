library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity memory is
    port
    (
        clk : in std_logic;
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
begin
    write_to_mem : process(clk) begin -- handle writes to memory
        if rising_edge(clk) then 
            if(memWrite = '1') then 
                mem(to_integer(unsigned(address))) <= B;
            end if;
        end if;
    end process;

   memData <= mem(to_integer(unsigned(address))) when (memRead = '1') else "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"; -- read from memory

end architecture;