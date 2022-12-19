module control_FD(
	input logic 		clk_i,
	input logic [31:0]	inst_F_i,
	input logic [31:0]	pc_F_i,

	output logic [31:0] inst_D_o,
	output logic [31:0] pc_D_o
);
always_ff @(posedge clk_i) begin
	pc_D_o <= pc_F_i;
	inst_D_o <= inst_F_i;

end
endmodule : control_FD
