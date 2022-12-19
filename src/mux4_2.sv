module mux4_2(
	input logic [31:0]	mux1,mux2,
	input logic [31:0]	ALU_M_i,
	input logic [31:0]	ALU_W_i,
	input logic [31:0]	inst_X_i,
	input logic [3:0]	opforward_i,

	output logic [31:0]	a_operand_o,
	output logic [31:0]	b_operand_o
);
/* verilator lint_off UNUSED */
 logic [24:0]unused;
 assign unused = {inst_X_i[31:7]};
/* verilator lint_on UNUSED */
always_comb begin
	if(inst_X_i[6:0]==7'b1100011) begin
		a_operand_o = mux1; b_operand_o = mux2;
	end
	else if(inst_X_i[6:0]==7'b1101111) begin
		a_operand_o = mux1; b_operand_o = mux2;
	end
	/*
	else if(inst_X_i[6:0]==7'b1100111) begin
			a_operand_o = mux1; b_operand_o = mux2;
	end
	*/
	else begin
	case(opforward_i)
	4'd0:begin a_operand_o = mux1	; b_operand_o = mux2; end
	
	4'd1:begin a_operand_o = ALU_M_i; b_operand_o = ALU_M_i; end
	4'd2:begin a_operand_o = ALU_W_i; b_operand_o = ALU_W_i; end
	4'd3:begin a_operand_o = ALU_M_i; b_operand_o = mux2; end
	4'd4:begin a_operand_o = mux1   ; b_operand_o = ALU_M_i; end
	4'd5:begin a_operand_o = ALU_W_i; b_operand_o = mux2; end

	4'd8:begin a_operand_o = mux1	; b_operand_o = ALU_W_i; end
	4'd9:begin a_operand_o = ALU_W_i; b_operand_o = ALU_M_i; end
	4'd10:begin a_operand_o = ALU_M_i; b_operand_o = ALU_W_i; end
	default:begin a_operand_o = mux1; b_operand_o = mux2; end
	endcase
	end
end
endmodule : mux4_2
