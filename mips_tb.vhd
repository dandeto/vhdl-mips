entity mips_tb is
end mips_tb;

architecture testbench of mips_tb is
    clk : std_logic;
	reset : std_logic;

    component mips
    port
        (
            clk : in std_logic;
            reset : in std_logic
        );
    end component;
begin
end testbench;