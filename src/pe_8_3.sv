module pe_8_3(
	input logic		[7:0]W,
	output logic 	[3:0]X
);
 always_comb begin : prox_encoder
		if     (W[7]==1) X = 4'b1110;
		else if(W[6]==1) X = 4'b1100;
		else if(W[5]==1) X = 4'b1010;
		else if(W[4]==1) X = 4'b1000;
		else if(W[3]==1) X = 4'b0110;
		else if(W[2]==1) X = 4'b0100;
		else if(W[1]==1) X = 4'b0010;
		else if(W[0]==1) X = 4'b0001;
		else X = 4'b0000;
	end
endmodule : pe_8_3
