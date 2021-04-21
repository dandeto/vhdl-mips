default:
	make mips.vcd 
	make sign_extend.vcd
	make memory.vcd

sign_extend.vcd: sign_extend.vhd sign_extend_tb.vhd
	ghdl -a sign_extend.vhd
	ghdl -a sign_extend_tb.vhd
	ghdl -e sign_extend_tb
	ghdl -r sign_extend_tb --vcd=sign_extend.vcd

memory.vcd: memory.vhd memory_tb.vhd
	ghdl -a memory.vhd
	ghdl -a memory_tb.vhd
	ghdl -e memory_tb
	ghdl -r memory_tb --vcd=sign_extend.vcd --stop-time=30ns

mips.vcd: mips_tb.vhd mips.vhd datapath.vhd sign_extend.vhd memory.vhd alu_control.vhd control.vhd alu.vhd program_counter.vhd

	ghdl -a alu.vhd
	ghdl -a control.vhd
	ghdl -a alu_control.vhd
	ghdl -a memory.vhd
	ghdl -a sign_extend.vhd
	ghdl -a program_counter.vhd
	ghdl -a datapath.vhd
	ghdl -a mips.vhd
	ghdl -a mips_tb.vhd
	ghdl -e mips_tb
	ghdl -r mips_tb --vcd=mips.vcd --stop-time=100ns

clean:
	rm mips.vcd work-*