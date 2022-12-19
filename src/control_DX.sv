module control_DX(
	input logic clk_i,
	input logic [31:0]	pc_D_i,
	input logic [31:0] 	rs1data_D_i,
	input logic [31:0]	rs2data_D_i,
	input logic [31:0] 	inst_D_i,
	input logic [21:0] 	othersig_D_i,
	input logic [31:0] 	imm_D_i,
	input logic [3:0]	opforward_D_i,
	input logic [1:0]	opforward_Dstore_i,

	
	output logic [31:0] pc_X_o,
	output logic [31:0] rs1data_X_o,
	output logic [31:0] rs2data_X_o,
	output logic [31:0]	inst_X_o,
	output logic [31:0] imm_X_o,
	output logic [21:0] othersig_X_o, 
	output logic [3:0]	opforward_X_o,
	output logic [1:0]	opforward_Xstore_o
);

always_ff @(posedge clk_i) begin
	pc_X_o 			<= pc_D_i;
	rs1data_X_o 	<= rs1data_D_i;
	rs2data_X_o 	<= rs2data_D_i;
	inst_X_o 		<= inst_D_i;
	othersig_X_o 	<= othersig_D_i;
	imm_X_o  		<= imm_D_i;
	opforward_X_o   <= opforward_D_i;
	opforward_Xstore_o <= opforward_Dstore_i;

end
endmodule : control_DX
