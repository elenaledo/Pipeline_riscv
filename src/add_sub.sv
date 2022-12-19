module add_sub(
	input logic [31:0] opera_i,
	input logic [31:0] operb_i,
	input logic T_i,
	output logic [31:0] result_o
);
logic [31:0] operb_tmp;
logic [31:0] T_tmp;
assign T_tmp = {31'b0,T_i};
assign operb_tmp[31:0] = ~ (operb_i[31:0]);
always_comb begin : proc_state
	if(T_i==1'b1) begin result_o = opera_i + T_tmp + operb_tmp ; end
	else begin result_o = opera_i + operb_i; end
end
endmodule : add_sub
