library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
entity alu_control is
port (
    Op         : in std_logic_vector(1 downto 0);
    functField : in std_logic_vector(5 downto 0);
    aluCtrl    : out std_logic_vector(3 downto 0)
);
end alu_control;

architecture behave of alu_control is begin
    process(Op, functField)
        variable Op_Field : std_logic_vector(7 downto 0);
    begin
        Op_Field := Op & functField;

        if    Op_Field = "1---0000" then aluCtrl <= "0010"; -- add
        elsif Op_Field = "1---0010" then aluCtrl <= "0110"; -- sub
        elsif Op_Field = "1---0100" then aluCtrl <= "0000"; -- AND
        elsif Op_Field = "1---0101" then aluCtrl <= "0001"; -- OR
        elsif Op_Field = "1---1010" then aluCtrl <= "0111"; -- SLT
        elsif Op_Field = "00------" then aluCtrl <= "0010"; -- lw sw
        elsif Op_Field = "01------" then aluCtrl <= "0110"; -- beq
        else aluCtrl <= "XXXX";
        end if;
    end process;
end behave; 