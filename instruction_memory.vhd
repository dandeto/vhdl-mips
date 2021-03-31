library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity instruction_memory is
    generic
    (
        size : integer := 32; -- size of each location
        length : integer := 256 -- total number of locations
    );
    port 
    (
        program_counter : in std_logic_vector(integer(log2(real(length))) downto 0);
        output_instruction : out std_logic_vector(size-1 downto 0)
    );
end instruction_memory;

architecture behav of instruction_memory is
    type memory_block is array (0 to length) of std_logic_vector(size downto 0);
    signal instr_mem : memory_block;
begin
    output_instruction <= instr_mem(to_integer(unsigned(program_counter)));

    -- add file reading to initialize the memory
end architecture;