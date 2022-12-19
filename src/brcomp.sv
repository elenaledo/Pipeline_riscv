module brcomp(
	input logic [31:0] operand_a_i,
	input logic [31:0] operand_b_i,
	input logic 		br_unsigned,
	output logic 		br_less,
	output logic		br_equal
);

brcomp2 compare(
	.operand_a_i(operand_a_i),
	.operand_b_i(operand_b_i),
	.br_less(br_less),
	.br_equal(br_equal),
	.br_unsigned(br_unsigned)
);

/*
logic br_equal_tmp,br_less_tmp;
logic 	[31:0]operand1_tmp;
logic	[31:0]operand2_tmp;
assign 	operand1_tmp = (br_unsigned==1'b1 && operand_insa_i[31]==1'b1)?(~operand_insa_i + 1):operand_insa_i;
assign  operand2_tmp = (br_unsigned==1'b1 && operand_insa_i[31]==1'b1)?(~operand_insb_i + 1):operand_insb_i;
always_comb begin
	if(operand1_tmp < operand2_tmp)begin
		 br_equal_tmp = 0;
		 br_less_tmp =	1; 
		end
	else if(operand1_tmp == operand2_tmp)begin
		 br_equal_tmp = 1;
		 br_less_tmp =	0; 
		end
	else begin
		br_equal_tmp = 0;
		 br_less_tmp =	0; 
	end
end
*/
endmodule : brcomp
