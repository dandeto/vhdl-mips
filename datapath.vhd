library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

        op : out std_logic;
        zero : out std_logic;
        func : out std_logic_vector(5 downto 0)
    );
end datapath;