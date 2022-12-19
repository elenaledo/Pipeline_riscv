	 module alu
(
	input logic	[31:0]	operand_a_i,
	input logic	[31:0]	operand_b_i,
	input logic [3:0]	alu_op_i,
	output logic [31:0]	result_alu_o
);
logic [31:0]	or_result_tmp;
logic [31:0]	and_result_tmp;
logic [31:0]	xor_result_tmp;
logic [31:0]	sll_result_tmp;
logic [31:0]	srl_result_tmp;
logic [31:0]	sra_result_tmp;

logic [35:0]	sra_tmp1 = 36'h7ffffffff;
logic [31:0]	sra_tmp2,sra_tmp3;
logic			result_compare_tmp,result_compare_tmp_uns;
logic 			equal_tmp;
//logic 			equal_tmp;
assign 	and_result_tmp[31:0]	= (operand_b_i[31:0]) & (operand_a_i[31:0]);
assign 	or_result_tmp[31:0]		= (operand_b_i[31:0]) | (operand_a_i[31:0]);
assign 	xor_result_tmp[31:0]	= (operand_b_i[31:0]) ^ (operand_a_i[31:0]);
assign 	sll_result_tmp[31:0]	=  (operand_a_i << operand_b_i);
assign 	srl_result_tmp[31:0]	=  (operand_a_i >> operand_b_i);
assign 	sra_tmp2				= 	(sra_tmp1[31:0] >> operand_b_i);
assign  sra_tmp3				= ~(sra_tmp2);
assign 	sra_result_tmp[31:0]	=  (operand_a_i[31] == 1'b0) ? (srl_result_tmp):(	sra_tmp3 | srl_result_tmp); //;
brcomp2 compare(
	.operand_a_i(operand_a_i),
	.operand_b_i(operand_b_i),
	.br_less(result_compare_tmp),
	.br_equal(equal_tmp),
	.br_unsigned(1'b0)
);
brcomp2 compare_uns(
	.operand_a_i(operand_a_i),
	.operand_b_i(operand_b_i),
	.br_less(result_compare_tmp_uns),
	.br_equal(equal_tmp),
	.br_unsigned(1'b1)
);

typedef enum logic[3:0] {
	A_ADD=4'h0,
	A_SUB=4'h1,
	A_SLT=4'h2,
	A_SLTU=4'h3,
	A_AND=4'h4,
	A_OR=4'h5,
	A_XOR=4'h6,
	A_SLL=4'h7,
	A_SRL=4'h8,
	A_SRA= 4'h9	
} alu_op_e;
logic [3:0] alu_op_tmp;

assign alu_op_tmp = alu_op_i; 
always_comb begin : proc_mux
	case(alu_op_tmp)
	A_ADD:	result_alu_o =	operand_a_i + operand_b_i;
	A_SUB:	result_alu_o =	operand_a_i + (~operand_b_i + 1);
	A_SLT:	result_alu_o = {31'b0,result_compare_tmp} | ({27'b0,~equal_tmp,sra_tmp1[35:32]} & 0);
	A_SLTU:	result_alu_o = {31'b0,result_compare_tmp_uns} | ({27'b0,~equal_tmp,sra_tmp1[35:32]} & 0);
	A_AND:	result_alu_o =	and_result_tmp;
	A_OR:	result_alu_o =	or_result_tmp;
	A_XOR:	result_alu_o =	xor_result_tmp;
	A_SLL:	result_alu_o =	sll_result_tmp;
	A_SRL:	result_alu_o =  srl_result_tmp;
	A_SRA:  result_alu_o =  sra_result_tmp;
	default: result_alu_o = '0 ;
	endcase
end
endmodule : alu
