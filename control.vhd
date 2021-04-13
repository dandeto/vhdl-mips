library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity control is
	-- Control Constants
	generic
	(
		FETCH      : std_logic_vector(4 downto 0) := "0000";
		DECODE     : std_logic_vector(4 downto 0) := "0001";
		MEMADRCOMP : std_logic_vector(4 downto 0) := "0010";
		MEMACCESSL : std_logic_vector(4 downto 0) := "0011";
		MEMREADEND : std_logic_vector(4 downto 0) := "0100";
		MEMACCESSS : std_logic_vector(4 downto 0) := "0101";
		EXECUTION  : std_logic_vector(4 downto 0) := "0110";
		RTYPEEND   : std_logic_vector(4 downto 0) := "0111";
		BEQ        : std_logic_vector(4 downto 0) := "1000"
	);
	port
	(
		IorD, MemWrite, MemRead,
		MemtoReg, IRWrite, PCSource,
		RegDst, RegWrite, ALUSrcA,
		PCSel          : out std_logic;

		clk, rst, Z    : in std_logic;
		Op             : in std_logic_vector(5 downto 0);
		ALUOp, ALUSrcB : out std_logic_vector(1 downto 0)
	);
end control;

architecture behave of control is 
	variable PCWrite, PCWriteCond : std_logic;
	variable state, nextstate     : std_logic_vector(3 downto 0);
begin

	PCSel <= (PCWrite or (PCWriteCond and Z));

	process (clk) begin
		if rising_edge(clk) then
			if(rst = '1') then
				state <= FETCH;
			else
				state <= nextstate;
			end if;

			process(state or Op) begin
				case(state) is
					when FETCH => nextstate <= DECODE;
					when DECODE =>
						case(Op) is
						end case;
					when MEMADRCOMP =>
						case(Op) is
						end case;
					when MEMACCESSL => nextstate <= MEMREADEND;
					when MEMREADEND => nextstate <= FETCH;
					when MEMACCESSS => nextstate <= FETCH;
					when EXECUTION => nextstate <= RTYPEEND;
					when RTYPEEND => nextstate <= FETCH;
					when BEQ => nextstate <= FETCH;
					when others => nextstate <= FETCH; -- when in doubt: fetch
				end case;
			end process;

			process(state) begin
				IorD        <= '0';
				MemRead     <= '0';
				MemWrite    <= '0';
				MemtoReg    <= '0';
				IRWrite     <= '0';
				PCSource    <= '0';
				ALUSrcB     <= "00";
				ALUSrcA     <= '0';
				RegWrite    <= '0';
				RegDst      <= '0';
				PCWrite     <= '0';
				PCWriteCond <= '0';
				ALUOp       <= "00";

				case (state) is
					when FETCH =>
						MemRead <= '1';
						IRWrite <= '1';
						ALUSrcB <= "01";
						PCWrite <= '1';
					when DECODE => ALUSrcB <= "11";
					when MEMADRCOMP =>
						ALUSrcA <= '1';
						ALUSrcB <= "10";
					when MEMACCESSL =>
						MemRead <= '1';
						IorD    <= '1';
					when MEMREADEND =>
						RegWrite <= '1';
						MemtoReg <= '1';
						RegDst   <= '1';
					when MEMACCESSS =>
						MemWrite <= '1';
						IorD     <= '1';
					when EXECUTION =>
						ALUSrcA <= '1';
						ALUOp   <= "10";
					when RTYPEEND =>
						RegDst   <= '1';
						RegWrite <= '1';
					when BEQ =>
						ALUSrcA     <= '1';
						ALUOp       <= "01";
						PCWriteCond <= '1';
						PCSource    <= "01";
				end case;
			end process;
		end if;

	end process;

end behave;
