module pc_unit(
	input logic clk_i,rst_ni,
	input logic [31:0] pcin_i,
	output logic [31:0] pcout_o
);

always_ff @(posedge clk_i or negedge rst_ni) begin
	if(!rst_ni) begin pcout_o <= 0; end
 	else begin 
			pcout_o <= pcin_i;
		end
end
endmodule : pc_unit
