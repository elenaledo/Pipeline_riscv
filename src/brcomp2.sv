module brcomp2(
	input logic [31:0] operand_a_i,
	input logic [31:0] operand_b_i,
	input logic 		br_unsigned,
	output logic 	br_less,
	output logic 	br_equal
);
logic br_less_tmp;
logic [31:0] operand_b_tmp,operand_a_tmp;
assign operand_b_tmp = (operand_b_i[31] & !br_unsigned)?(~operand_b_i + 1):(operand_b_i);
assign operand_a_tmp = (operand_a_i[31] & !br_unsigned)?(~operand_a_i + 1):(operand_a_i);
always_comb begin : mux1
		if(operand_a_tmp < operand_b_tmp) begin
			br_equal = 0; br_less_tmp = 1;
		end
		else if(operand_a_tmp == operand_b_tmp) begin
			br_equal = 1; br_less_tmp = 0;
		end
		else begin
			br_equal = 0; br_less_tmp = 0;
		end
end
always_comb begin
	if(br_unsigned==1) br_less = br_less_tmp;
	else begin
		br_less =(br_equal==1)?0:(operand_a_i[31] & !operand_b_i[31])?1:(!operand_a_i[31] & operand_b_i[31])?0:(!operand_a_i[31] & !operand_b_i[31])?br_less_tmp:~br_less_tmp;
	end
end
endmodule : brcomp2
