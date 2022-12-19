module control_XM(
	input logic clk_i,
	input logic [31:0]	pc_X_i,
	input logic [31:0] 	inst_X_i,
	input logic [31:0]	aludata_X_i,
	input logic 		wren_X_i,
	input logic [1:0]	wbsel_X_i,
	input logic [4:0]	rdaddr_X_i,
	input logic 		rdwr_X_i,	
	input logic [31:0]	rs2data_X_i,
	input logic [3:0]	lsop_X_i,
	input logic 		lsuns_X_i,
	input logic 		taken_X_i,
	
	output logic [31:0] pc_M_o,
	output logic [31:0] inst_M_o,
	output logic [31:0] aludata_M_o,
	output logic 		wren_M_o,
	output logic [1:0]	wbsel_M_o,
	output logic [4:0]	rdaddr_M_o,
	output logic 		rdwr_M_o,
	output logic [31:0]	rs2data_M_o,
	output logic [3:0]	lsop_M_o,
	output logic 		lsuns_M_o,
	output logic 		taken_M_o
);
always_ff @(posedge clk_i) begin
	pc_M_o 		<=	pc_X_i;
	inst_M_o 	<=  inst_X_i;
	aludata_M_o <= 	aludata_X_i;
	wren_M_o	<= 	wren_X_i;
	wbsel_M_o	<= 	wbsel_X_i;
	rdaddr_M_o	<=	rdaddr_X_i;
	rdwr_M_o	<=	rdwr_X_i;
	rs2data_M_o <= 	rs2data_X_i;
	lsuns_M_o	<=  lsuns_X_i;
	lsop_M_o	<=	lsop_X_i;
	taken_M_o	<=	taken_X_i;
end
endmodule :control_XM
