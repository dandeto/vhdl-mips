library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity alu is
	port (
		op1, op2 : in  std_logic_vector(31 downto 0);
		aluOp              : in  std_logic_vector(3  downto 0);
		result             : inout std_logic_vector(31 downto 0);
		zeroFlag           : out std_logic
	);
end entity alu;

architecture behave of alu is begin
	process(aluOp, op1, op2) begin
		case aluOp is
			when "0010" => result <= std_logic_vector(to_signed(to_integer(signed(op1)) + to_integer(signed(op2)), 32)); -- add
			when "0110" => result <= std_logic_vector(to_signed(to_integer(signed(op1)) - to_integer(signed(op2)), 32)); -- subtract
			when "0000" => result <= op1 and op2; -- and
			when "0001" => result <= op1 or op2; -- or
			when "0111" =>
				if(op1 < op2) then result <= "11111111111111111111111111111111";
				else result <= "00000000000000000000000000000000"; -- set on less than
				end if;
			when "1000" => result <= not (op1 or op2); -- branch if equal
			when others => result <= "--------------------------------";
		end case;
	end process;

	process(result) begin
		if(result = "0") then zeroFlag <= '1';
		else zeroFlag <= '0';
		end if;
	end process;
end behave;
