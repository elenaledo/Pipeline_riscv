module regfile(
	input logic 		clk_i,
	input logic 		rst_ni,
	input logic 		rd_wr_i,
	input logic [4:0]	rd_addr_i,
	input logic [4:0]	rs1_addr_i,
	input logic [4:0]	rs2_addr_i,
	input logic [31:0]	rd_data_i,

	output logic [31:0] rs1_data_o,
	output logic [31:0] rs2_data_o
);
logic [31:0] register [0:31];
/*
initial begin
	if((rd_wr_i) & (rd_addr_i!=5'b0)) begin
		$writememh("memory/regfile.data",register);
	end
end
*/
/* verilator lint_off UNUSED */
logic unused;
assign unused = rst_ni;
/* verilator lint_on UNUSED */

initial  begin
	for (int i = 0;i < 31;i++) begin
		register[i] =0;
	end
end

always_ff @(posedge clk_i) begin
	if((rd_wr_i) & (rd_addr_i!=5'b0)) begin
		register[0] <= 0;
		register[rd_addr_i] <= rd_data_i;
		$writememh("memory/regfile.data",register);
	end
	
end

always_comb begin 
	 rs1_data_o = register[rs1_addr_i];
	 rs2_data_o = register[rs2_addr_i];
end
endmodule : regfile 
