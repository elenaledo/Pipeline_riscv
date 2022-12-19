module stall_check(
	input logic [31:0]	instF_stall_i,
	input logic [31:0]	instD_stall_i,

	output logic 		need_stall_o
);
logic [6:0]	check_typeload;
logic [4:0]	rs1_F,rs2_F;
logic [4:0]	rd_D;

/* verilator lint_off UNUSED */
logic [34:0]unused;
assign unused = {instF_stall_i[31:25],instF_stall_i[14:7],instD_stall_i[31:12]};
/* verilator lint_on UNUSED */

assign check_typeload = instD_stall_i[6:0];

assign rs1_F = instF_stall_i[19:15];
assign rs2_F = (instF_stall_i[6:0]==7'b0010011)?0:instF_stall_i[24:20];
assign rd_D  = instD_stall_i[11:7];

always_comb begin
	if(check_typeload == 7'b0000011)begin
		if((rs1_F == rd_D && rs1_F != 0 && rd_D != 0  ) || (rs2_F == rd_D && rs2_F != 0  && rd_D != 0)) need_stall_o = 1;
		else need_stall_o = 0;
	end
	else need_stall_o = 0;
end
endmodule : stall_check
