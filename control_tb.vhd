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
	signal ALUOp, ALUSrcB : std_logic_vector(1 downto 0);

begin
	alu : entity work.control(behave)
	      port map (op1, op2, aluOp, result, zeroFlag);

	process(clk)
	begin
		clk <= not clk after 1 ns;
	end process;

	process begin

	end process;
end TEST;
