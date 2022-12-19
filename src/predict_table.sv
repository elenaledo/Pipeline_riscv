 module predict_table(
	//input logic rst_ni,
	input logic clk_i,
	input logic [31:0] inst_F_i,
	input logic [31:0] inst_X_i,
	input logic [31:0] pc_F_i,
	input logic [11:0] pc_present_i,
	input logic [13:0] pc_X_i,
	input logic [31:0] pc_result_i,
	input logic  	   valid_bit_i,
	
	output logic [31:0] nxt_pc_F_o,
	output logic pc_sel_o,hit_miss_o
);
logic [31:0] 	tag 	[(2**12)-1:0];
logic 			valid 	[(2**12)-1:0];
logic [11:0] tag_addrX;
logic [31:0] nxt_pc_F_tmp;


assign tag_addrX = pc_X_i[13:2];
/* verilator lint_off UNUSED */
logic [51:0]unused;
assign unused = {inst_F_i[31:7],inst_X_i[31:7],pc_X_i[1:0]};
/* verilator lint_on UNUSED */
///write_execute/////
always_comb begin
	if(inst_X_i[6:0]==7'b1100011 ) begin
		hit_miss_o = (valid[tag_addrX] & ~(valid_bit_i));
	end
	else hit_miss_o = 0;
end

always_ff @(posedge clk_i) begin
	if(inst_X_i[6:0]==7'b1100011 /*|| inst_X_i[6:0]==7'b1100111*/ || inst_X_i[6:0]==7'b1101111) begin
		tag[tag_addrX] <= pc_result_i;
		valid[tag_addrX] <= valid_bit_i;
		//hit_miss_o <= (valid[tag_addrX] & ~(valid_bit_i));
		$writememh("./memory/tag.data",tag);
		$writememh("./memory/valid.data",valid);
	end
end
	
	/*
	else begin
		tag[tag_addrX]	 <= tag[tag_addrX];
		valid[tag_addrX]	 <= valid[tag_addrX];
		hit_miss_o	 <= hit_miss_o;
	end
	*/

always_comb begin
	if (inst_F_i[6:0]==7'b1100011 /*|| inst_F_i[6:0]==7'b1100111*/ || inst_F_i[6:0]==7'b1101111) begin
		if(valid[pc_present_i] ==1'b1) begin
			nxt_pc_F_tmp = tag[pc_present_i];
			end
		else begin
			nxt_pc_F_tmp 	= pc_F_i;
			end
	end	
	else begin
		nxt_pc_F_tmp = pc_F_i;
	end
end
always_comb begin
	if (inst_X_i[6:0]==7'b1100011 || inst_X_i[6:0]==7'b1100111 || inst_X_i[6:0]==7'b1101111) begin
		if(valid[tag_addrX] ==1'b1 && inst_X_i[6:0] != 7'b1100111) begin
			pc_sel_o   = 1'b0;
			nxt_pc_F_o = nxt_pc_F_tmp;
			end
		else begin
			pc_sel_o	= valid_bit_i;
			nxt_pc_F_o =(valid_bit_i)?pc_result_i:nxt_pc_F_tmp;
			end
	end	
	else begin
		pc_sel_o   = 1'b0;
		nxt_pc_F_o = nxt_pc_F_tmp;
	end
end

endmodule : predict_table
