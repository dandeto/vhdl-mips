use WORK.all;
library ieee;
use IEEE.std_logic_1164.all;

entity CONTROL_TEST_BENCH is
end CONTROL_TEST_BENCH;

architecture TEST of CONTROL_TEST_BENCH is
		signal IorD, MemWrite, MemRead,
		MemtoReg, IRWrite, PCSource,
		RegDst, RegWrite, ALUSrcA,
		PCSel          : std_logic;

		signal clk, rst, Z    : std_logic;
		signal Op             : std_logic_vector(5 downto 0);
		signal ALUOp, ALUSrcB : std_logic_vector(1 downto 0)

begin
	alu : entity work.control(behave)
				port map (op1, op2, aluOp, result, zeroFlag);

		process begin
			-- initialize alu operations
			op1 <= "00000000000000000000000000000011";
			op2 <= "00000000000000000000000000001010";

			-- test alu control ( run for 11 ns )

			wait for 1 ns;
			Op <= "10";
			functField <= "000000";
			wait for 1 ns;
			Op <= "11";
			functField <= "000010";
			wait for 1 ns;

			Op <= "10";
			functField <= "000100";
			wait for 1 ns;
			Op <= "11";
			functField <= "000101";
			wait for 1 ns;
			Op <= "10";
			functField <= "001010";
			wait for 1 ns;
			Op <= "00";
			functField <= "000000";
			wait for 1 ns;
			Op <= "01";
			functField <= "000000";
			wait for 1 ns;
			-- when others
			Op <= "11";
			functField <= "111111";
			wait for 1 ns;
			Op <= "10";
			functField <= "111100";
			wait for 1 ns;
		end process;
end TEST;
