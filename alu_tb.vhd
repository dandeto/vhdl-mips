<<<<<<< HEAD
use WORK.all;
library ieee;
use IEEE.std_logic_1164.all;

entity ALU_TEST_BENCH is
end ALU_TEST_BENCH;

architecture  TEST of ALU_TEST_BENCH is
  signal op1, op2 : std_logic_vector(31 downto 0);
  signal aluOp    : std_logic_vector(3  downto 0);
  signal result   : std_logic_vector(31 downto 0);
  signal zeroFlag : std_logic;

  signal Op         : std_logic_vector(1 downto 0);
  signal functField : std_logic_vector(5 downto 0);
  signal aluCtrl    : std_logic_vector(3 downto 0);

  signal CLK : std_logic := '0';

begin
  alu : entity work.alu(behave)
        port map (op1, op2, aluOp, result, zeroFlag);
  control: entity work.alu_control(behave)
           port map (Op, functField, aluCtrl);


    -- initialize alu operations
    op1 <= "00000000000000000000000000000011";
    op2 <= "00000000000000000000000000001010";


    process begin
      -- directly test alu
      wait for 1 ns;
      aluOp <= "0000";
      wait for 1 ns;
      aluOp <= "0001";
      wait for 1 ns;
      aluOp <= "0010";
      wait for 1 ns;
      aluOp <= "0110";
      wait for 1 ns;
      aluOp <= "0111";
      wait for 1 ns;
      aluOp <= "1000";
      wait for 1 ns;
      aluOp <= "1111";

      -- test alu control

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
=======
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_tb is
end alu_tb;

architecture test of alu_tb is
    component alu
    port 
    (
        opA, opB : in  std_logic_vector(31 downto 0); 
        aluOp : in  std_logic_vector(3  downto 0); 
        result : out std_logic_vector(31 downto 0) 
    );
    end component;

    signal opA, opB : std_logic_vector(31 downto 0); 
    signal aluOp : std_logic_vector(3  downto 0); 
    signal result : std_logic_vector(31 downto 0); 

begin
    uut : alu
    port map
    (
        opA => opA,
        opB => opB,
        aluOp => aluOp,
        result => result
    );

    process begin
        wait for 1 ns;

        opA <= x"00000005";
        opB <= x"00000002";
        aluOp <= "0000";
        wait for 1 ns;

        aluOp <= "0001";
        wait for 1 ns;

        aluOp <= "0010";
        wait for 1 ns;

        aluOp <= "0011";
        wait for 1 ns;

        aluOp <= "0111";
        wait for 1 ns;

        aluOp <= "1100";
        wait for 1 ns;

        aluOp <= "1111";
        wait for 1 ns;
        wait;
    end process;

end test;
>>>>>>> stay_off_my_branch
