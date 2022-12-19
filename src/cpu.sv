module cpu(
	input logic clk_i,
	input logic rst_ni,
	output logic [31:0] instr,
	//////////////////////
	input logic [31:0] SW,
	output logic [31:0] LEDR,LEDG,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,
	output logic [31:0] LCD,
	output logic [11:0] rs2data
);

logic [31:0] data_alu,rs1_data,rs2_data,imm,data_select1,data_select2,PC;
logic [4:0]rs1_addr,rs2_addr,rd_addr;
logic br_uns,op_a,op_b,is_pc,br_l,br_e,mem_wr,rd_wr,pc_sel;
logic [1:0]wb_sel;
logic [3:0]alu_op,sl_op;
logic [31:0]nxt_pc,rdata_tmp,data_mux3;
assign rs2data = data_alu[11:0];
mux2_1 mux0(
	.ina_i(data_alu),
	.inb_i(PC + 'd4),
	.sel_i(pc_sel),
	.out_o(nxt_pc)	
);
pc_unit pc_unit(
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.pcin_i(nxt_pc),
	.pcout_o(PC)
);

inst_memory instruction_mem(
	//.clk_i(clk_i),
	.addr_inst_i(PC),
	.data_inst_o(instr)	
);

ctrl_unit control_unit(
	.instr_i(instr),
	
	
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
	.sl_op_o(sl_op)
	//output logic [1:0]store_op_o,	
);
pc_branch pc_branch_unit(
	.br_less_i(br_l),
	.br_equal_i(br_e),
	.is_pc_i(is_pc),
	.instr_opcode_i(instr[6:0]),
	.instr_branch_i(instr[14:12]),

	.pc_sel_o(pc_sel)
);
regfile regfile_unit(
	.clk_i(clk_i),
	.rd_wr_i(rd_wr),
	.rd_addr_i(rd_addr),
	.rs1_addr_i(rs1_addr),
	.rs2_addr_i(rs2_addr),
	.rd_data_i(data_mux3),

	.rs1_data_o(rs1_data),
	.rs2_data_o(rs2_data)	
);
mux2_1 mux1(
	.ina_i(PC),
	.inb_i(rs1_data),
	.sel_i(op_a),
	.out_o(data_select1)	
);
mux2_1 mux2(
	.ina_i(imm),
	.inb_i(rs2_data),
	.sel_i(op_b),
	.out_o(data_select2)	
);
brcomp br_unit(
	.operand_a_i(rs1_data),
	.operand_b_i(rs2_data),
	.br_unsigned(br_uns),
	.br_less(br_l),
	.br_equal(br_e)
);

alu alu_unit(
	.operand_a_i(data_select1),
	.operand_b_i(data_select2),
	.alu_op_i(alu_op),
	.result_alu_o(data_alu)
);
data_memory dmem_unit(
	.clk_i(clk_i),
	.rst_ni(rst_ni),
	.wdata_i(rs2_data),
	.addr_dmem_i(data_alu[11:0]),
	.wren_i(mem_wr),
	.sl_op_i(sl_op),
	.rdata_dmem_o(rdata_tmp),
	.sw_i(SW),
	.LEDR_o(LEDR),
	.LEDG_o(LEDG),
	.HEX0_o(HEX0),
	.HEX1_o(HEX1),
	.HEX2_o(HEX2),
	.HEX3_o(HEX3),
	.HEX4_o(HEX4),
	.HEX5_o(HEX5),
	.HEX6_o(HEX6),
	.HEX7_o(HEX7),
	.LCD_o(LCD)
);
always_comb begin : mux_3_2
	case (wb_sel)
	2'b00:	data_mux3 = rdata_tmp;
	2'b01:	data_mux3 = data_alu;
	2'b10:	data_mux3 = PC + 32'd4;
	default: data_mux3 = 32'b0;
	endcase
end
endmodule : cpu
