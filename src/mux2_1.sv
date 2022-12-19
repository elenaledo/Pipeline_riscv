module mux2_1(
	input logic [31:0] ina_i,
	input logic [31:0] inb_i,
	input logic sel_i,
	output logic [31:0] out_o
);
assign out_o = (sel_i)?ina_i:inb_i;

endmodule : mux2_1
