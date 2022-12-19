module ctrl_unit(
	input logic [31:0] instr_i,
	
	/////////output........
	output logic is_pc_o,
	output logic br_unsigned_o,
	output logic rd_wren_o,
	output logic op_a_sel_o,
	output logic op_b_sel_o,
	output logic [3:0] alu_op_o,
	output logic mem_wren_o,
	output logic [1:0]wb_sel_o,
	//////
	output logic [31:0]imm_o,
	output logic [4:0]rs1_addr_o,
	output logic [4:0]rs2_addr_o,
	output logic [4:0]rd_addr_o,
	output logic [3:0]sl_op_o,
	output logic ls_unsign_o
	//output logic [1:0]store_op_o,
	//output logic [2:0]load_op_o 
);
logic [11:0] ctrl_bits_tmp;
assign  {is_pc_o,rd_wren_o,br_unsigned_o,op_b_sel_o,op_a_sel_o,alu_op_o[3:0],mem_wren_o,wb_sel_o[1:0]}= ctrl_bits_tmp;
//INSTRUCTION [ 6 : 2 ]//////////
typedef enum logic[6:0] {
	R_TYPE 		 = 7'b0110011,
	I_TYPE_LOGIC = 7'b0010011,
	I_TYPE_LOAD  = 7'b0000011,
	S_TYPE	 	 = 7'b0100011,
	B_TYPE		 = 7'b1100011,
	LUI			 = 7'b0110111,
	AUIPC		 = 7'b0010111,
	JAL 		 = 7'b1101111,
	JALR		 = 7'b1100111
}opcode_e;
logic [6:0] opcode_tmp;
assign opcode_tmp = instr_i[6:0];
//////////////////////////////////
//INSTRUCTION [ 30 ] [ 14 : 12 ]//////////
typedef enum logic[3:0] {
	ADD = 	4'b0_000,
	SUB = 	4'b1_000,
	SLT = 	4'b0_010,
	SLTU = 	4'b0_011,
	XOR = 	4'b0_100,
	OR = 	4'b0_110,
	AND = 	4'b0_111,
	SLL = 	4'b0_001,
	SRL = 	4'b0_101,
	SRA = 	4'b1_101
}funct_alu_e;
logic [3:0] funct_alu_tmp;
assign funct_alu_tmp = {instr_i[30],instr_i[14:12]};
/////////////
////////////////
typedef enum logic[2:0] {
	LB = 	3'b000,
	LH = 	3'b001,
	LW = 	3'b010,
	LBU = 	3'b100,
	LHU = 	3'b101
}funct_load_e;
logic [2:0] funct_load_tmp;
assign funct_load_tmp = instr_i[14:12];
////////////////////
typedef enum logic[2:0] {
	SB = 	3'b000,
	SH = 	3'b001,
	SW = 	3'b010
}funct_store_e;
logic [2:0] funct_store_tmp;
assign funct_store_tmp = instr_i[14:12];
//////////////////////////
typedef enum logic[2:0] {
	BEQ = 	3'b000,
	BNE = 	3'b001,
	BLT = 	3'b100,
	BGE = 	3'b101,
	BLTU = 	3'b110,
	BGEU = 	3'b111
}funct_branch_e;
logic [2:0] funct_branch_tmp;
assign funct_branch_tmp = instr_i[14:12];
//////////////////////////////
always_comb begin : mux
	case(opcode_tmp)
	//R_TYPE
	R_TYPE: case(funct_alu_tmp)
				ADD:begin
					sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_0000_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				SUB:begin
					sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_0001_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				SLT:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_0010_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				SLTU:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_0011_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				AND:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_0100_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				OR:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_0101_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				XOR:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_0110_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				SLL:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_0111_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				SRL:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_1000_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				SRA:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_0_0_1001_0_01;
					imm_o=32'h0;
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				default:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b0;
					imm_o=32'h0;
					rd_addr_o=0;
					rs1_addr_o=0;
					rs2_addr_o=0;
				end
			endcase
	//I_TYPE_LOGIC
	I_TYPE_LOGIC: case(instr_i[14:12])
				3'b000:begin//addi
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0000_0_01;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'd0,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				3'b010:begin//slti
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0010_0_01;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'd0,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				3'b011:begin//sltiu
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0011_0_01;
					imm_o={20'd0,instr_i[31:20]};	
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				3'b111:begin//andi
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0100_0_01;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'd0,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				3'b110:begin//ori
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0101_0_01;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'd0,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				3'b100:begin//xori
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0110_0_01;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'd0,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				3'b001:begin//slli
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0111_0_01;
					imm_o={27'd0,instr_i[24:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				3'b101:begin//srli
					case(instr_i[30])
					1'b0: begin
					sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_1000_0_01;
					imm_o={27'b0,instr_i[24:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
					end
					1'b1:begin//srai
					sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_1001_0_01;
					imm_o={27'b0,instr_i[24:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
					end
					endcase
					end
				default:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b0;
					imm_o=32'h0;
					rd_addr_o=0;
					rs1_addr_o=0;
					rs2_addr_o=0;
				end
			endcase
	I_TYPE_LOAD: case(funct_load_tmp)
				LB:begin//srai
				sl_op_o[3:0] = 4'b0001;ls_unsign_o=0;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0000_0_00;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'h00000,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				LH:begin//srai
				sl_op_o[3:0] = 4'b0011;ls_unsign_o=0;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0000_0_00;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'h00000,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				LW:begin//srai
				sl_op_o[3:0] = 4'b1111;ls_unsign_o=0;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0000_0_00;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'h00000,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				LBU:begin//srai
				sl_op_o[3:0] = 4'b0001;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0000_0_00;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'h00000,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				LHU:begin//srai
				sl_op_o[3:0] = 4'b0011;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_0_1_1_1_0_0000_0_00;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'h00000,instr_i[31:20]};
					rd_addr_o=instr_i[11:7];
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=0;
				end
				default:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b0;
					imm_o=32'h0;
					rd_addr_o=0;
					rs1_addr_o=0;
					rs2_addr_o=0;
				end
			endcase
	S_TYPE: case(funct_store_tmp)
				SB:begin//srai
				sl_op_o[3:0] = 4'b0001;ls_unsign_o=0;
					ctrl_bits_tmp=12'b_0_0_1_1_0_0000_1_00;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:25],instr_i[11:7]}:{20'h00000,instr_i[31:25],instr_i[11:7]};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				SH:begin//srai
				sl_op_o[3:0] = 4'b0011;ls_unsign_o=0;
					ctrl_bits_tmp=12'b_0_0_1_1_0_0000_1_00;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:25],instr_i[11:7]}:{20'h00000,instr_i[31:25],instr_i[11:7]};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				SW:begin//srai
				sl_op_o[3:0] = 4'b1111;ls_unsign_o=0;
					ctrl_bits_tmp=12'b_0_0_1_1_0_0000_1_00;
					imm_o=(instr_i[31])?{20'hfffff,instr_i[31:25],instr_i[11:7]}:{20'h00000,instr_i[31:25],instr_i[11:7]};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				default:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b0;
					imm_o=32'h0;
					rd_addr_o=0;
					rs1_addr_o=0;
					rs2_addr_o=0;
				end
			endcase
	B_TYPE: case(funct_branch_tmp)
				BEQ: begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_1_0_0_1_1_0000_0_01;
					imm_o=(instr_i[31])?{19'hfffff,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0}:{19'h00000,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				BNE: begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_1_0_0_1_1_0000_0_01;
					imm_o=(instr_i[31])?{19'hfffff,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0}:{19'h00000,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				BLT: begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_1_0_0_1_1_0000_0_01;
					imm_o=(instr_i[31])?{19'hfffff,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0}:{19'h00000,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				BGE: begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_1_0_0_1_1_0000_0_01;
					imm_o=(instr_i[31])?{19'hfffff,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0}:{19'h00000,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				BLTU: begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_1_0_1_1_1_0000_0_01;
					imm_o=(instr_i[31])?{19'hfffff,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0}:{19'h00000,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				BGEU: begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b_1_0_1_1_1_0000_0_01;
					imm_o=(instr_i[31])?{19'hfffff,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0}:{19'h00000,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
					rd_addr_o=0;
					rs1_addr_o=instr_i[19:15];
					rs2_addr_o=instr_i[24:20];
				end
				default:begin
				sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
					ctrl_bits_tmp=12'b0;
					imm_o=32'h0;
					rd_addr_o=0;
					rs1_addr_o=0;
					rs2_addr_o=0;
				end
			endcase
	LUI:begin
	sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
		ctrl_bits_tmp=12'b_0_1_1_1_0_0000_0_01;
		imm_o={instr_i[31:12],12'b0};
		rd_addr_o=instr_i[11:7];
		rs1_addr_o=5'b00000;
		rs2_addr_o=5'b00000;
	end
	AUIPC:begin
	sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
		ctrl_bits_tmp=12'b_0_1_1_1_1_0000_0_01;
		imm_o={instr_i[31:12],12'b0};
		rd_addr_o=instr_i[11:7];
		rs1_addr_o=5'b00000;
		rs2_addr_o=5'b00000;
	end
	JAL:begin
	sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
		ctrl_bits_tmp=12'b_1_1_1_1_1_0000_0_10;
		imm_o=(instr_i[31])?{11'hfff,instr_i[31],instr_i[19:12],instr_i[20],instr_i[30:21],1'b0}:{11'h000,instr_i[31],instr_i[19:12],instr_i[20],instr_i[30:21],1'b0};
		rd_addr_o=instr_i[11:7];
		rs1_addr_o=5'b00000;
		rs2_addr_o=5'b00000;
	end
	JALR:begin
	sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
		ctrl_bits_tmp=12'b_1_1_1_1_0_0000_0_10;
		imm_o=(instr_i[31])?{20'hfffff,instr_i[31:20]}:{20'd0,instr_i[31:20]};
		rd_addr_o=instr_i[11:7];
		rs1_addr_o=instr_i[19:15];
		rs2_addr_o=5'b00000;
	end
	default:begin
	sl_op_o[3:0] = 4'b0000;ls_unsign_o=1;
			ctrl_bits_tmp=12'bx00000000000;
			imm_o=32'h0;
			rd_addr_o=0;
			rs1_addr_o=0;
			rs2_addr_o=0; 
		end
	endcase
end
endmodule : ctrl_unit
