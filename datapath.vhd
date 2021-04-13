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

    type register_block is array (0 to 31) of std_logic_vector(31 downto 0); -- define register block type
    signal reg : register_block;
    signal mdr : std_logic_vector(31 downto 0); -- used for transfering data to instruction opcodes
    signal da : std_logic_vector(31 downto 0); -- data read a
    signal db : std_logic_vector(31 downto 0); -- data read b

    signal opA : std_logic_vector(31 downto 0);
    signal opB : std_logic_vector(31 downto 0);

    signal sign_extended : std_logic_vector(31 downto 0);
    component sign_extend
        port
        (
            in_bits : in std_logic_vector(15 downto 0);
            out_bits : out std_logic_vector(31 downto 0)
        );
    end component;

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


    instruction_register_write : process(clk) begin -- get instruction
        if rising_edge(clk) then
            if(IRWrite = '1') then
                instruction <= memData;
            end if;
        end if;
    end process;

    memory_data_to_reg : process(clk) begin
        if rising_edge(clk) then
            mdr <= memData;
        end if;
    end process;

    da <= reg(to_integer(unsigned(instruction(25 downto 21)))) when (to_integer(unsigned(instruction(25 downto 21))) /= 0) 
    else x"00000000";

    db <= reg(to_integer(unsigned(instruction(20 downto 16)))) when (to_integer(unsigned(instruction(20 downto 16))) /= 0) 
    else x"00000000";

    reg_dst : process(clk) begin
        if rising_edge(clk) then
            if(regWrite = '1') then
                if(regDst = '1') then
                    if(memToReg = '1') then
                        reg(to_integer(unsigned(instruction(15 downto 11)))) <= mdr; 
                    else
                        reg(to_integer(unsigned(instruction(15 downto 11)))) <= ALUOut;
                    end if;
                else
                    if(memToReg = '1') then
                        reg(to_integer(unsigned(instruction(20 downto 16)))) <= mdr; 
                    else
                        reg(to_integer(unsigned(instruction(20 downto 16)))) <= ALUOut;
                    end if;
                end if;
            end if;
        end if;
    end process;

    a_reg : process(clk) begin
        if rising_edge(clk) then
            A <= da;    
        end if;
    end process;

    b_reg : process(clk) begin
        if rising_edge(clk) then
            B <= db;    
        end if;
    end process;

    opA <= A when (ALUSrcA = '1') else PC; -- fix this!!!

    -- sign extension
    se : sign_extend
    port map
    (
        instruction(15 downto 0),
        sign_extended
    );

    opB_process : process(ALUSrcB, B, instruction(15 downto 0))
    begin
        case(ALUSrcB) is
            when "00" => opB <= B;
            when "01" => opB <= x"00000001";
            when "1X" => opB <= x"00000000";
            when others => opB <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end case;
    end process;

    zero <= '1' when (ALUResult = x"00000000") else '0';

    
end architecture;
