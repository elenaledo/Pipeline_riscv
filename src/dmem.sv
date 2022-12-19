module dmem(
		input logic clk_i,
		//input logic rst_ni,
		input logic [31:0] wdata_i,
		input logic [11:0]	addr_dmem_i,
		input logic wren_i,
		output logic [31:0] rdata_dmem_o	
	);
	parameter DMEM = 12;
	logic [3:0][7:0] sdmem [0:2**(DMEM-2) - 1];
	
	logic unused;
	assign unused = |addr_dmem_i[1:0] & 0;
	/*
	initial begin
	    for (int i=0; i < 2**(DMEM-2); i++) begin
	      sdmem[i] = 0;
	    end
	end
	*/
	//////////////DMEM/////////////////////////
	always_ff @(posedge clk_i) begin
		if((wren_i==1)) begin
			sdmem[addr_dmem_i[11:2]][0] <= wdata_i[7:0];
			sdmem[addr_dmem_i[11:2]][1] <= wdata_i[15:8];
			sdmem[addr_dmem_i[11:2]][2] <= wdata_i[23:16];
			sdmem[addr_dmem_i[11:2]][3] <= wdata_i[31:24];
			$writememh("memory/datamem.data",sdmem);
		end
	end
	always_comb begin
	 rdata_dmem_o = sdmem[addr_dmem_i[11:2]] | {31'b0,unused};
	//////////////OUTPUT_PERIPH////////////////////DO AGAIN 
	 end
	endmodule : dmem
