library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity datapath is
    generic(PCSTART : integer := 128);
    port 
    (
        clk : in std_logic; -- input clock
        reset : in std_logic; -- reset switch
        IorD : in std_logic; -- determine if you are reading from instruction or data memory
        memWrite : in std_logic; -- signal to write to registers
        memRead : in std_logic; -- signal to read from registers
        memToReg : in std_logic;
        IRWrite : in std_logic;
        PCSource : in std_logic;
        regDst : in std_logic;
        regWrite : in std_logic;
        PCSel : in std_logic;
        ALUSrcA : in std_logic;
        ALUSrcB : in std_logic_vector(1 downto 0);
        ALUCtrl : in std_logic_vector(3 downto 0);

        op : out std_logic_vector(5 downto 0);
        zero : out std_logic;
        func : out std_logic_vector(5 downto 0)
    );
end datapath;

architecture behave of datapath is
    signal instruction : std_logic_vector(31 downto 0); -- instruction that is being executed
    signal PC : std_logic_vector(7 downto 0); -- program counter
    signal aluOut : std_logic_vector(31 downto 0);
    signal address : std_logic_vector(7 downto 0);

    type memory_block is array (0 to 255) of std_logic_vector(31 downto 0); -- define memory block type
    signal mem : memory_block; -- data and instruction memory 
    signal memData : std_logic_vector(31 downto 0); -- holds data read from memory

    signal A : std_logic_vector(31 downto 0);
    signal B : std_logic_vector(31 downto 0);

    signal ALUResult : std_logic_vector(31 downto 0);
begin
    func <= instruction(5 downto 0); -- assign func field
    op <= instruction(31 downto 26); -- assign op field

    address <= aluOut(7 downto 0) when (IorD = '1') else PC; -- needs verifying!!!

                -- memory logic
    write_to_mem : process(clk) begin -- handle writes to memory
        if rising_edge(clk) then 
            if(memWrite = '1') then 
                mem(to_integer(unsigned(address))) <= B;
            end if;
        end if;
    end process;

    memData <= mem(to_integer(unsigned(address))) when (memRead = '1') else "--------------------------------"; -- read from memory

        -- PC logic

    PC_logic : process(clk) begin
        if rising_edge(clk) then
            if(reset = '1') then
                PC <= std_logic_vector(to_unsigned(PCSTART, PC'length)); -- go back to the original instruction
            else
                if(PCsel = '1') then
                    case(PCSource) is
                        when '0' => PC <= ALUResult(7 downto 0); -- needs verifying!!!
                        when '1' => PC <= ALUOut(7 downto 0); -- needs verifying!!!
                        when others => PC <= "XXXXXXXX";
                    end case;
                end if;
            end if;
        end if;
    end process;
end architecture;