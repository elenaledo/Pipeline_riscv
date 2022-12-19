module mux4_2_branch(
	input logic [31:0]	mux1,mux2,
	input logic [31:0]	ALU_M_i,
	input logic [31:0]	ALU_W_i,
	input logic [3:0]	opforward_i,

	output logic [31:0]	a_operand_o,
	output logic [31:0]	b_operand_o
);

always_comb begin
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
endmodule : mux4_2_branch
