library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_tb is
end alu_tb;

architecture test of alu_tb is
    component alu
    port 
    (
        opA, opB : in  std_logic_vector(31 downto 0); 
        aluOp : in  std_logic_vector(3  downto 0); 
        result : out std_logic_vector(31 downto 0) 
    );
    end component;

    signal opA, opB : std_logic_vector(31 downto 0); 
    signal aluOp : std_logic_vector(3  downto 0); 
    signal result : std_logic_vector(31 downto 0); 

begin
    uut : alu
    port map
    (
        opA => opA,
        opB => opB,
        aluOp => aluOp,
        result => result
    );

    process begin
        wait for 1 ns;

        opA <= x"00000005";
        opB <= x"00000002";
        aluOp <= "0000";
        wait for 1 ns;

        aluOp <= "0001";
        wait for 1 ns;

        aluOp <= "0010";
        wait for 1 ns;

        aluOp <= "0011";
        wait for 1 ns;

        aluOp <= "0111";
        wait for 1 ns;

        aluOp <= "1100";
        wait for 1 ns;

        aluOp <= "1111";
        wait for 1 ns;
        wait;
    end process;

end test;