module control_MW(
	input logic clk_i,
	input logic [4:0]	rdaddr_M_i,
	input logic 		rdwr_M_i,
	input logic [31:0]	datareg_M_i,
	input logic [31:0]  inst_M_i,
	
	output logic [4:0]	rdaddr_W_o,
	output logic 		rdwr_W_o,
	output logic [31:0]	datareg_W_o,
	output logic [31:0] inst_W_o
);
initial begin
	datareg_W_o	= 32'b0;
	rdaddr_W_o	= 5'b0;
	rdwr_W_o 	= 1'b0;
	inst_W_o    = 32'b0;
	end
always_ff @(posedge clk_i) begin
	rdaddr_W_o	<=	rdaddr_M_i;
	rdwr_W_o	<=	rdwr_M_i;
	datareg_W_o	<=	datareg_M_i;
	inst_W_o	<=  inst_M_i;
end
endmodule : control_MW
