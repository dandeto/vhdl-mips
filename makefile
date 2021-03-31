default:
	make sign_extend.vcd

sign_extend.vcd: sign_extend.vhd sign_extend_tb.vhd
	ghdl -a sign_extend.vhd
	ghdl -a sign_extend_tb.vhd
	ghdl -e sign_extend_tb
	ghdl -r sign_extend_tb --vcd=sign_extend.vcd

clean:
	rm sign_extend.vcd work-*