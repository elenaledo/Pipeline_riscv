module fsm_1bit(
	input logic clk_i,
	input logic rst_ni,
	input logic hit_taken_i,
	input logic [6:0]opcode_X,
	output logic valid_bit_o
);
parameter TAKEN = 1'b1;
parameter NTAKEN = 1'b0;
logic PS;
always_ff @(posedge clk_i) begin
	if(!rst_ni) PS <= NTAKEN;
	else if(opcode_X=7'b1100011)begin
		case(PS)
		TAKEN:begin
			valid_bit_o <= 1'b1;
			if(hit_taken_i) PS <= TAKEN;
			else 		PS <= NTAKEN; 
		end		
		NTAKEN:begin
			valid_bit_o <= 1'b0;
			if(hit_taken_i) PS <= TAKEN;
			else PS <= NTAKEN;
			end
		endcase
	end
	else begin
		PS <= NTAKEN;
		valid_bit_o <= 0;
	end
end
endmodule : fsm_1bit
