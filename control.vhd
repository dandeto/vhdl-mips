library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity control is
	port
	(
		clk, rst, Z    : in std_logic;
		Op             : in std_logic_vector(5 downto 0);
		IorD, MemWrite, MemRead,
		MemtoReg, IRWrite, PCSource,
		RegDst, RegWrite, ALUSrcA,
		PCSel          : out std_logic;
		ALUOp, ALUSrcB : out std_logic_vector(1 downto 0)
	);
end control;

architecture behave of control is 
	-- Local Variables
	signal PCWrite, PCWriteCond : std_logic;
	signal state, nextstate     : std_logic_vector(3 downto 0);

	-- Control Constants
	constant FETCH      : std_logic_vector(3 downto 0) := "0000";
	constant DECODE     : std_logic_vector(3 downto 0) := "0001";
	constant MEMADRCOMP : std_logic_vector(3 downto 0) := "0010";
	constant MEMACCESSL : std_logic_vector(3 downto 0) := "0011";
	constant MEMREADEND : std_logic_vector(3 downto 0) := "0100";
	constant MEMACCESSS : std_logic_vector(3 downto 0) := "0101";
	constant EXECUTION  : std_logic_vector(3 downto 0) := "0110";
	constant RTYPEEND   : std_logic_vector(3 downto 0) := "0111";
	constant BEQ        : std_logic_vector(3 downto 0) := "1000";
begin

	PCSel <= (PCWrite or (PCWriteCond and Z));

	process (clk) begin
		if rising_edge(clk) then
			if(rst = '1') then
				state <= FETCH;
			else
				state <= nextstate;
			end if;
		end if;
	end process;

			process(state, Op) begin
				case(state) is
					when FETCH => nextstate <= DECODE;
					when DECODE =>
						case(Op) is
							when "100011" => nextstate <= MEMADRCOMP; --lw
							when "101011" => nextstate <= MEMADRCOMP; --sw
							when "000000" => nextstate <= EXECUTION; --r
							when "000100" => nextstate <= BEQ; --beq
							when others   => nextstate <= FETCH;
						end case;
					when MEMADRCOMP =>
						case(Op) is
							when "100011" => nextstate <= MEMACCESSL; --lw
							when "101011" => nextstate <= MEMACCESSS; --sw
							when others   => nextstate <= FETCH;
						end case;
					when MEMACCESSL => nextstate <= MEMREADEND;
					when MEMREADEND => nextstate <= FETCH;
					when MEMACCESSS => nextstate <= FETCH;
					when EXECUTION  => nextstate <= RTYPEEND;
					when RTYPEEND   => nextstate <= FETCH;
					when BEQ        => nextstate <= FETCH;
					when others     => nextstate <= FETCH; -- when in doubt: fetch
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
						PCSource    <= '1';
					when others => null;
				end case;
			end process;
end behave;
