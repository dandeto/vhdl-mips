default:
	make sign_extend.vcd 
	make alu.vcd
	make mips.vcd

sign_extend.vcd: sign_extend.vhd sign_extend_tb.vhd
	ghdl -a sign_extend.vhd
	ghdl -a sign_extend_tb.vhd
	ghdl -e sign_extend_tb
	ghdl -r sign_extend_tb --vcd=sign_extend.vcd

alu.vcd: alu.vhd alu_tb.vhd
	ghdl -a alu.vhd
	ghdl -a alu_tb.vhd
	ghdl -e alu_tb
	ghdl -r alu_tb --vcd=alu.vcd

mips.vcd: mips_tb.vhd mips.vhd 
	ghdl -a alu.vhd
	ghdl -a alu_control.vhd
	ghdl -a memory.vhd
	ghdl -a sign_extend.vhd
	ghdl -a datapath.vhd
	ghdl -e datapath

clean:
	rm alu.vcd sign_extend.vcd work-*