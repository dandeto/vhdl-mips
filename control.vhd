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
		ALUOp, ALUSrcB : out std_logic_vector(1 downto 0);
		DEBUG_STATE    : out std_logic_vector(3 downto 0)
	);
end control;

architecture behave of control is 
	-- Local Variables
	signal PCWrite, PCWriteCond : std_logic;
	signal state, next_state    : std_logic_vector(3 downto 0);

	-- Control Constants
	constant FETCH      : std_logic_vector(3 downto 0) := "0000"; -- instruction fetch
	constant DECODE     : std_logic_vector(3 downto 0) := "0001"; -- instruction decode / register fetch
	constant MEMADRCOMP : std_logic_vector(3 downto 0) := "0010"; -- memory address computation
	constant MEMLOAD    : std_logic_vector(3 downto 0) := "0011"; -- Memory Access 'load word'
	constant MEMREADEND : std_logic_vector(3 downto 0) := "0100"; -- Memory Access finished
	constant MEMSTORE   : std_logic_vector(3 downto 0) := "0101"; -- Memory Access 'store word'
	constant EXECUTION  : std_logic_vector(3 downto 0) := "0110";
	constant RCOMPLETE  : std_logic_vector(3 downto 0) := "0111"; -- R-type completion
	constant BEQ        : std_logic_vector(3 downto 0) := "1000"; -- Branch completion
begin

	-- advance PC
	PCSel <= (PCWrite or (PCWriteCond and Z));

	DEBUG_STATE <= state; -- output to hex display

	-- get next state
	process (clk) begin
		if rising_edge(clk) then
			if(rst = '1') then
				state <= FETCH;
			else
				state <= next_state;
			end if;
		end if;
	end process;

	-- FSM next state
	process(state, Op) begin
		case(state) is
			when FETCH => next_state <= DECODE;
			when DECODE =>
				case(Op) is
					when "100011" => next_state <= MEMADRCOMP; --lw
					when "101011" => next_state <= MEMADRCOMP; --sw
					when "000000" => next_state <= EXECUTION; --r
					when "000100" => next_state <= BEQ; --beq
					when others   => next_state <= FETCH;
				end case;
			when MEMADRCOMP =>
				case(Op) is
					when "100011" => next_state <= MEMLOAD; --lw
					when "101011" => next_state <= MEMSTORE; --sw
					when others   => next_state <= FETCH;
				end case;
			when MEMLOAD    => next_state <= MEMREADEND;
			when MEMREADEND => next_state <= FETCH;
			when MEMSTORE   => next_state <= FETCH;
			when EXECUTION  => next_state <= RCOMPLETE;
			when RCOMPLETE  => next_state <= FETCH;
			when BEQ        => next_state <= FETCH;
			when others     => next_state <= FETCH; -- when in doubt: fetch
		end case;
	end process;

	process(state) begin
		-- init to zero - eliminate carry-over errors
		IorD        <= '0'; -- instruction mode by default
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

		-- FSM output
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
			when MEMLOAD =>
				MemRead <= '1';
				IorD    <= '1'; -- switch to data
			when MEMREADEND =>
				RegWrite <= '1';
				MemtoReg <= '1';
				RegDst   <= '0';
			when MEMSTORE =>
				MemWrite <= '1';
				IorD     <= '1'; -- switch to data
			when EXECUTION =>
				ALUSrcA <= '1';
				ALUOp   <= "10";
			when RCOMPLETE =>
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
