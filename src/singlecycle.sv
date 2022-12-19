
module singlecycle(
	input logic clk_i,
	input logic rst_ni,
	//////////////////////
	input logic [31:0] io_sw_i,
	output logic [31:0] io_ledr_o,io_ledg_o,
	output logic [31:0] io_hex0_o,io_hex1_o,io_hex2_o,io_hex3_o,io_hex4_o,io_hex5_o,io_hex6_o,io_hex7_o,
	output logic [31:0] io_lcd_o	
);
logic [31:0] data_alu,rs1_data,rs2_data,imm,data_select1,data_select2,PC,instr,inst_W;
logic [4:0]rs1_addr,rs2_addr,rd_addr;
logic br_uns,op_a,op_b,is_pc,br_l,br_e,pc_sel,rd_wr,mem_wr,ls_uns;
logic [1:0] wb_sel;
logic [3:0]alu_op,sl_op;
logic [31:0]	rdata_tmp,data_mux3;
logic [31:0]	pc_D,pc_X,pc_M;
logic [31:0]	inst_D,inst_X,inst_M;
logic [31:0]	imm_X,pc_predict;
logic   [31:0]   inst_F_done,nxt_pc;
/* verilator lint_off UNUSED */
 logic 	 [5:0] unused;
 assign unused = {rdaddr_W,rdwr_W};
/* verilator lint_on UNUSED */
 logic 		valid_predict,hit_miss_test;



///////////////////////*************///////////////////////////
//////////////////////////F STAGE/////////////////////////////
predict_table predict(
	.clk_i(clk_i),
	//.rst_ni(rst_ni),
	.inst_F_i(inst_F_done),
	.inst_X_i(inst_X),
	.pc_F_i(pc_F_stall),
	.pc_present_i(PC[13:2]),
	.pc_X_i(pc_X[13:0]),
	.pc_result_i(data_alu),
	.valid_bit_i(pc_sel),
	.nxt_pc_F_o(pc_predict),
	.pc_sel_o(valid_predict),
	.hit_miss_o(hit_miss_test)	
);
mux2_1 mux_stall1(
	.ina_i(PC),
	.inb_i(PC + 32'd4),
	.sel_i(need_stall),
	.out_o(pc_F_stall)	
);
mux2_1 mux0(
	.ina_i(pc_X+ 32'd4),
	.inb_i(pc_predict),
	.sel_i(hit_miss_test),
	.out_o(nxt_pc)
);
pc_unit pc_unit(
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.pcin_i(nxt_pc),
	.pcout_o(PC)
);

inst_memory instruction_mem(
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.addr_inst_i(PC[13:0]),
	.data_inst_o(instr)	
);
mux2_1 mux_stall5(
	.ina_i(0),
	.inb_i(instr),
	.sel_i(need_stall),
	.out_o(inst_F_stall)	
);
mux2_1 mux_stall11(
	.ina_i(0),
	.inb_i(inst_F_stall),
	.sel_i(valid_predict | hit_miss_test),
	.out_o(inst_F_done)	
);
control_FD	FtransferD(
	.clk_i(clk_i),
	
	.inst_F_i(inst_F_done),
	.pc_F_i(PC),

	
	.inst_D_o(inst_D),
	.pc_D_o(pc_D)
);
//DECLARE LOGIC/////////
logic need_stall;
logic [31:0] inst_F_stall,pc_F_stall;

////////////
stall_check need_stall_check(
	.instF_stall_i(instr),
	.instD_stall_i(inst_D),
	.need_stall_o(need_stall)	
);

////////////////////*******************///////////////////////
/////////////////////////D STAGE///////////////////////////////
ctrl_unit control_unit(
	.instr_i(inst_D),
		
	.is_pc_o(is_pc),
	.br_unsigned_o(br_uns),
	.rd_wren_o(rd_wr),
	.op_a_sel_o(op_a),
	.op_b_sel_o(op_b),
	.alu_op_o(alu_op),
	.mem_wren_o(mem_wr),
	.wb_sel_o(wb_sel),
	//////
	.imm_o(imm),
	.rs1_addr_o(rs1_addr),
	.rs2_addr_o(rs2_addr),
	.rd_addr_o(rd_addr),
	.sl_op_o(sl_op),
	.ls_unsign_o(ls_uns)
	//output logic [1:0]store_op_o,	
);
//*declare other 14 bit control*////////

logic [21:0] 	othersig_D,othersig_X;
logic [21:0] 	othersig_D_nop;
logic [31:0] 	inst_D_done;
logic [31:0] 	rs1_data_X,rs2_data_X;
logic [3:0] 	opforward,opforward_X;
logic [1:0] 	opforward_store;


logic [1:0] 	opforward_store_X;
assign othersig_D[21:0] = {sl_op,ls_uns,is_pc,br_uns,rd_wr,op_a,op_b,alu_op,mem_wr,wb_sel,rd_addr};
////////

regfile regfile_unit(
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.rd_wr_i(rdwr_M),
	.rd_addr_i(rdaddr_M),
	.rs1_addr_i(rs1_addr),
	.rs2_addr_i(rs2_addr),
	.rd_data_i(data_mux3),

	.rs1_data_o(rs1_data),
	.rs2_data_o(rs2_data)	
);
forwarding_control_logic forward_control(
	.instD_com_i(inst_D),
	.instX_com_i(inst_X),
	.instM_com_i(inst_M),
	.instW_com_i(inst_W),

	.forward_sel_o(opforward),
	.forward_forstore_o(opforward_store)
);
mux2_1 mux_stall12(
	.ina_i(0),
	.inb_i(inst_D),
	.sel_i(valid_predict | hit_miss_test),
	.out_o(inst_D_done)	
);
assign pc_sel_M = 0;
always_comb begin
	if(valid_predict | pc_sel_M | hit_miss_test) othersig_D_nop = 0;
	else othersig_D_nop = othersig_D;
end
logic [3:0] opforward_D_check;
always_comb begin
	if(valid_predict | hit_miss_test) opforward_D_check = 0;
	else opforward_D_check = opforward;
end
logic [1:0] opforward_store_D;
always_comb begin
	if(valid_predict | hit_miss_test) opforward_store_D = 0;
	else opforward_store_D =opforward_store ;
end

control_DX 	DtranferX(
	.clk_i(clk_i),
	
	.opforward_D_i(opforward_D_check),
	.pc_D_i(pc_D),
	.rs1data_D_i(rs1_data),
	.rs2data_D_i(rs2_data),
	.inst_D_i(inst_D_done),
	.othersig_D_i(othersig_D_nop),
	.imm_D_i(imm),
	.opforward_Dstore_i(opforward_store_D),
	
	
	.opforward_X_o(opforward_X),
	.pc_X_o(pc_X),
	.rs1data_X_o(rs1_data_X),
	.rs2data_X_o(rs2_data_X),
	.inst_X_o(inst_X),
	.imm_X_o(imm_X),
	.othersig_X_o(othersig_X),
	.opforward_Xstore_o(opforward_store_X)
);
////////////////////**********************////////////////////
///////////////////////////X STAGE//////////////////////////

pc_branch pc_branch_unit(
	.br_less_i(br_l),
	.br_equal_i(br_e),
	.is_pc_i(othersig_X[16]),//is_pc
	.instr_opcode_i(inst_X[6:0]),
	.instr_branch_i(inst_X[14:12]),

	.pc_sel_o(pc_sel)
);
mux2_1 mux1(
	.ina_i(pc_X),
	.inb_i(rs1_data_X),
	.sel_i(othersig_X[13]),//op_a
	.out_o(data_select1)	
);
mux2_1 mux2(
	.ina_i(imm_X),
	.inb_i(rs2_data_X),
	.sel_i(othersig_X[12]),//op_b
	.out_o(data_select2)	
);
mux4_2_branch mux_forward_branch(
	.mux1(rs1_data_X),
	.mux2(rs2_data_X),
	.ALU_M_i(aludata_M),
	.ALU_W_i(datareg_W),
	.opforward_i(opforward_X),
		
	.a_operand_o(a_branch),
	.b_operand_o(b_branch)	
);
brcomp br_unit(
	.operand_a_i(a_branch),
	.operand_b_i(b_branch),
	.br_unsigned(othersig_X[15]),//br_unsigned
	.br_less(br_l),
	.br_equal(br_e)
);
mux4_2 mux_forward(
	.mux1(data_select1),
	.mux2(data_select2),
	.ALU_M_i(aludata_M),
	.ALU_W_i(datareg_W),
	.inst_X_i(inst_X),
	.opforward_i(opforward_X),
		
	.a_operand_o(a_operand),
	.b_operand_o(b_operand)	
);

alu alu_unit(
	.operand_a_i(a_operand),
	.operand_b_i(b_operand),
	.alu_op_i(othersig_X[11:8]),//alu_op
	.result_alu_o(data_alu)
);
//////////////////*declare logic*/////////////
logic [1:0]		wbsel_M;
logic 			rdwr_M,wren_M,lsuns_M,pc_sel_M;
logic [4:0]		rdaddr_M;
logic [31:0]	aludata_M;
logic [31:0]	rs2_data_M;
logic [31:0] 	a_operand,b_operand,a_branch,b_branch;
logic [3:0]		lsop_M;
//////////////////------------/////////////
control_XM XtranferM(
	.clk_i		(clk_i),
	.pc_X_i		(pc_X),
	.inst_X_i	(inst_X),
	.aludata_X_i(data_alu),
	.wren_X_i	(othersig_X[7]),//wren
	.wbsel_X_i	(othersig_X[6:5]),//wb_sel
	.rdwr_X_i	(othersig_X[14]),
	.rdaddr_X_i	(othersig_X[4:0]),
	.rs2data_X_i(rs2_data_X),
	.lsop_X_i	(othersig_X[21:18]),//ls op
	.lsuns_X_i	(othersig_X[17]),//ls unsign
	.taken_X_i	(pc_sel),

	.pc_M_o		(pc_M),
	.inst_M_o	(inst_M),
	.aludata_M_o(aludata_M),
	.wren_M_o	(wren_M),//wren
	.wbsel_M_o	(wbsel_M),//wb_sel
	.rdwr_M_o	(rdwr_M),
	.rdaddr_M_o	(rdaddr_M),
	.rs2data_M_o(rs2_data_M),
	.lsop_M_o	(lsop_M),//ls op
	.lsuns_M_o	(lsuns_M),//ls unsign
	.taken_M_o 	(pc_sel_M)
);
/////////////////*******************///////////////////////
//////////////////////M STAGE/////////////////////////////
/*
mux2_1 muxstore(
	.ina_i(datareg_W_tmp3),
	.inb_i(rs2_data_M),
	.sel_i(opforward_store_X),//op_b
	.out_o(datamem_W)	
);
*/
always_comb begin
		if(opforward_store_X ==2'd1 ) 		datamem_W = datareg_W;
		else if(opforward_store_X ==2'd2)   datamem_W = datareg_W_tmp;
		
		else 								datamem_W = rs2_data_M;
end
data_memory dmem_unit(
	.clk_i(clk_i),
	//.rst_ni(rst_ni),
	.wdata_i(datamem_W),
	.addr_dmem_i(aludata_M[11:0]),
	.wren_i(wren_M),
	.sl_op_i(lsop_M),
	.ls_op_i(lsuns_M),
	.rdata_dmem_o(rdata_tmp),
	.sw_i(io_sw_i),
	.LEDR_o(io_ledr_o),
	.LEDG_o(io_ledg_o),
	.HEX0_o(io_hex0_o),
	.HEX1_o(io_hex1_o),
	.HEX2_o(io_hex2_o),
	.HEX3_o(io_hex3_o),
	.HEX4_o(io_hex4_o),
	.HEX5_o(io_hex5_o),
	.HEX6_o(io_hex6_o),
	.HEX7_o(io_hex7_o),
	.LCD_o(io_lcd_o)
);
always_comb begin : mux_3_2
	case (wbsel_M)
	2'b00:	data_mux3 = rdata_tmp;
	2'b01:	data_mux3 = aludata_M;
	2'b10:	data_mux3 = pc_M + 32'd4;
	default: data_mux3 = 32'b0;
	endcase
end
////DECLARE LOGIC///////////
logic	[4:0]	rdaddr_W;
logic 			rdwr_W;
logic	[31:0]	datareg_W;
logic 	[31:0]	datamem_W; 
//////////
control_MW MtransferW(
	.clk_i(clk_i),
	.rdaddr_M_i(rdaddr_M),
	.rdwr_M_i(rdwr_M),
	.datareg_M_i(data_mux3),
	.inst_M_i(inst_M),
	
	.rdaddr_W_o(rdaddr_W),
	.rdwr_W_o(rdwr_W),
	.datareg_W_o(datareg_W),
	.inst_W_o(inst_W)
);

logic [31:0] datareg_W_tmp;
always_ff @(posedge clk_i) begin
	datareg_W_tmp	<= datareg_W;
end

/////////////////////*****************///////////////////
//////////////////////////W STAGE///////////////////////
endmodule : singlecycle
