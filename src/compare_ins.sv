module compare_ins(
	input logic [3:0]	A_i,
	input logic [3:0]	B_i,
	output logic 		less_o,
	output logic 		more_o,
	output logic 		equal_o
);
logic	[3:0]	x_tmp;
logic			equal_tmp;
logic 			more_tmp;
logic 			less_tmp;
assign x_tmp[3]=~(A_i[3]^B_i[3]);
assign x_tmp[2]=~(A_i[2]^B_i[2]);
assign x_tmp[1]=~(A_i[1]^B_i[1]);
assign x_tmp[0]=~(A_i[0]^B_i[0]);

assign	equal_tmp = (x_tmp[3] & x_tmp[2] & x_tmp[1] & x_tmp[0]);
assign  more_tmp = ((A_i[3]&(~B_i[3]))|(x_tmp[3]&A_i[2]&(~B_i[2]))|(x_tmp[3]&x_tmp[2]&A_i[1]&(~B_i[1]))|(x_tmp[3]&x_tmp[2]&x_tmp[1]&A_i[0]&(~B_i[0])));
assign  less_tmp	 =	~((equal_tmp) | (more_tmp));

assign 	less_o = less_tmp;
assign  more_o = more_tmp;
assign 	equal_o = equal_tmp;
endmodule : compare_ins
