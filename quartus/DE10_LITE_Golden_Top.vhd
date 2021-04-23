-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

library ieee;
use ieee.std_logic_1164.all;
library altera;
use altera.altera_syn_attributes.all;

entity DE10_LITE_Golden_Top is
	port
	(
-- {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!

		ADC_CLK_10 : in std_logic;
		MAX10_CLK1_50 : in std_logic; -- use clk
		MAX10_CLK2_50 : in std_logic;
		DRAM_CAS_N : in std_logic;
		DRAM_CKE : in std_logic;
		DRAM_CLK : in std_logic;
		DRAM_CS_N : in std_logic;
		DRAM_LDQM : in std_logic;
		DRAM_RAS_N : in std_logic;
		DRAM_UDQM : in std_logic;
		DRAM_WE_N : in std_logic;
		VGA_HS : in std_logic;
		VGA_VS : in std_logic;
		GSENSOR_CS_N : in std_logic;
		GSENSOR_SCLK : in std_logic;
		GSENSOR_SDI : in std_logic;
		GSENSOR_SDO : in std_logic;
		ARDUINO_RESET_N : in std_logic;
		DRAM_ADDR : in std_logic_vector(0 to 12);
		DRAM_BA : in std_logic_vector(0 to 1);
		DRAM_DQ : in std_logic_vector(0 to 15);
		HEX0 : out std_logic_vector(7 downto 0);
		HEX1 : in std_logic_vector(0 to 7);
		HEX2 : in std_logic_vector(0 to 7);
		HEX3 : in std_logic_vector(0 to 7);
		HEX4 : in std_logic_vector(0 to 7);
		HEX5 : in std_logic_vector(0 to 7);
		KEY : in std_logic_vector(0 to 1);
		LEDR : inout std_logic_vector(0 to 9);
		SW : in std_logic_vector(0 to 9); -- use sw 0 as reset
		VGA_B : in std_logic_vector(0 to 3);
		VGA_G : in std_logic_vector(0 to 3);
		VGA_R : in std_logic_vector(0 to 3);
		GSENSOR_INT : in std_logic_vector(1 to 2);
		ARDUINO_IO : in std_logic_vector(0 to 15);
		GPIO : in std_logic_vector(0 to 35)
-- {ALTERA_IO_END} DO NOT REMOVE THIS LINE!

	);

-- {ALTERA_ATTRIBUTE_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_ATTRIBUTE_END} DO NOT REMOVE THIS LINE!
end DE10_LITE_Golden_Top;

architecture ppl_type of DE10_LITE_Golden_Top is

-- {ALTERA_COMPONENTS_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_COMPONENTS_END} DO NOT REMOVE THIS LINE!
signal outputtest : std_logic_vector(3 downto 0);
signal DEBUG_STATE : std_logic_vector(3 downto 0);
begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!

--LEDR(0) <= outputtest(0);
--LEDR(1) <= outputtest(1);
--LEDR(2) <= outputtest(2);
--LEDR(3) <= outputtest(3);

LEDR(0) <= DEBUG_STATE(0);
LEDR(1) <= DEBUG_STATE(1);
LEDR(2) <= DEBUG_STATE(2);
LEDR(3) <= DEBUG_STATE(3);


mips: entity work.mips(behave)
		port map (SW(1), SW(0), outputtest, LEDR(9), DEBUG_STATE);

display: entity work.display_driver(behave)
		port map (DEBUG_STATE, HEX0);

end;
