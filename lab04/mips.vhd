-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Sat Nov 20 19:07:47 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY mips IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC
	);
END mips;

ARCHITECTURE bdf_type OF mips IS 

COMPONENT alu
	PORT(a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 alucont : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 zero : OUT STD_LOGIC;
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT aludec
	PORT(aluop : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 funct : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 alucontrol : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux4_32
	PORT(d0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 d1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 d2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 d3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 s : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT adder
	PORT(a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2_32
	PORT(s : IN STD_LOGIC;
		 d0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 d1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sl2_32
	PORT(a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dmem
	PORT(clk : IN STD_LOGIC;
		 we : IN STD_LOGIC;
		 a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 wd : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rd : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT imem
	PORT(a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rd : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT signext
	PORT(a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2_5
	PORT(s : IN STD_LOGIC;
		 d0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 d1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 y : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT maindec
	PORT(funct : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 regwrite : OUT STD_LOGIC;
		 branch : OUT STD_LOGIC;
		 bne : OUT STD_LOGIC;
		 jump : OUT STD_LOGIC;
		 jr : OUT STD_LOGIC;
		 memwrite : OUT STD_LOGIC;
		 aluop : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 alusrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 memtoreg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 regdst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT lpm_constant4
	PORT(		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sl2_26
	PORT(a : IN STD_LOGIC_VECTOR(25 DOWNTO 0);
		 y : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)
	);
END COMPONENT;

COMPONENT flopr
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT regfile
	PORT(clk : IN STD_LOGIC;
		 we3 : IN STD_LOGIC;
		 ra1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 ra2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 wa3 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 wd3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rd1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rd2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sl16_32
	PORT(a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	aluCtrl :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	aluOp :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	aluSrc :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	b :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	branch :  STD_LOGIC;
SIGNAL	brTaken :  STD_LOGIC;
SIGNAL	brTarget :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	immed :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	imSh2 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	instruction :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	jmpTarget :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	jr :  STD_LOGIC;
SIGNAL	jump :  STD_LOGIC;
SIGNAL	memToReg :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	memWrite :  STD_LOGIC;
SIGNAL	mo :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	NOT_USED :  STD_LOGIC;
SIGNAL	npc :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	npcOpt :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	pc :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	pcSeq :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	rd1 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	rd2 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	regDst :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	regWrite :  STD_LOGIC;
SIGNAL	result :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	ui :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	wr :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	writeData :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	zero :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 



b2v_alu : alu
PORT MAP(a => rd1,
		 alucont => aluCtrl,
		 b => b,
		 zero => zero,
		 result => result);


b2v_aludec : aludec
PORT MAP(aluop => aluOp,
		 funct => instruction(5 DOWNTO 0),
		 alucontrol => aluCtrl);


b2v_b_mux : mux4_32
PORT MAP(d0 => rd2,
		 d1 => immed,
		 d2 => ui,
		 d3 => ui,
		 s => aluSrc,
		 y => b);


b2v_br_adder : adder
PORT MAP(a => pcSeq,
		 b => imSh2,
		 y => brTarget);


b2v_br_mux : mux2_32
PORT MAP(s => brTaken,
		 d0 => pcSeq,
		 d1 => brTarget,
		 y => npcOpt);


b2v_br_shift : sl2_32
PORT MAP(a => immed,
		 y => imSh2);


b2v_dmem : dmem
PORT MAP(clk => clk,
		 we => memWrite,
		 a => result,
		 wd => rd2,
		 rd => mo);


b2v_imem : imem
PORT MAP(a => pc,
		 rd => instruction);


b2v_imm_signext : signext
PORT MAP(a => instruction(15 DOWNTO 0),
		 y => immed);


b2v_inst : mux2_5
PORT MAP(s => regDst(0),
		 d0 => instruction(20 DOWNTO 16),
		 d1 => instruction(15 DOWNTO 11),
		 y => wr);


b2v_inst10 : maindec
PORT MAP(funct => instruction(5 DOWNTO 0),
		 op => instruction(31 DOWNTO 26),
		 regwrite => regWrite,
		 branch => branch,
		 jump => jump,
		 memwrite => memWrite,
		 aluop => aluOp,
		 alusrc => aluSrc,
		 memtoreg => memToReg,
		 regdst => regDst);


brTaken <= branch AND zero;

jmpTarget(30) <= pcSeq(30);


jmpTarget(29) <= pcSeq(29);


jmpTarget(31) <= pcSeq(31);


jmpTarget(28) <= pcSeq(28);



b2v_inst27 : lpm_constant4
PORT MAP(		 result => SYNTHESIZED_WIRE_0);


b2v_inst9 : mux2_32
PORT MAP(s => memToReg(0),
		 d0 => result,
		 d1 => mo,
		 y => writeData);


b2v_jump_shft : sl2_26
PORT MAP(a => instruction(25 DOWNTO 0),
		 y => jmpTarget(27 DOWNTO 0));


b2v_npc_mux : mux2_32
PORT MAP(s => jump,
		 d0 => npcOpt,
		 d1 => jmpTarget,
		 y => npc);


b2v_pc_adder : adder
PORT MAP(a => SYNTHESIZED_WIRE_0,
		 b => pc,
		 y => pcSeq);


b2v_pc_reg : flopr
PORT MAP(clk => clk,
		 reset => reset,
		 d => npc,
		 q => pc);


b2v_regfile : regfile
PORT MAP(clk => clk,
		 we3 => regWrite,
		 ra1 => instruction(25 DOWNTO 21),
		 ra2 => instruction(20 DOWNTO 16),
		 wa3 => wr,
		 wd3 => writeData,
		 rd1 => rd1,
		 rd2 => rd2);


b2v_upper_imm : sl16_32
PORT MAP(a => instruction(15 DOWNTO 0),
		 y => ui);


END bdf_type;