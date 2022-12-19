module forwarding_control_logic(
	input logic	[31:0]	instD_com_i,
	input logic [31:0]	instX_com_i,
	input logic [31:0]	instM_com_i,
	input logic [31:0]  instW_com_i,
	output logic [3:0]		forward_sel_o,
	output logic [1:0]			forward_forstore_o
);
logic [4:0]	rd_M_com,rd_X_com,rd_W_com;
logic [4:0]	rs1_D_com,rs2_D_com,rs2_X_com;
logic [6:0] opcode_D;
assign rd_M_com = (instM_com_i[6:0]==7'b1100011 || instM_com_i[6:0]==7'b0100011)?0:instM_com_i[11:7];//BOTH NEED EXCEPT STORE AND B TYPE????? 
assign rd_X_com = (instX_com_i[6:0]==7'b1100011 || instX_com_i[6:0]==7'b0100011)?0:instX_com_i[11:7];
assign rd_W_com = (instW_com_i[6:0]==7'b1100011 || instW_com_i[6:0]==7'b0100011)?0:instW_com_i[11:7];
assign rs2_X_com= instX_com_i[24:20];//STORE IS SPECIAL

assign opcode_D 	  = instD_com_i[6:0];//i_type_logic = 0010011
assign rs1_D_com	  = (opcode_D == 7'b0110111 || opcode_D == 7'b0010111 || opcode_D == 7'b1101111)?0:instD_com_i[19:15];
assign rs2_D_com	  = (opcode_D == 7'b0110011 || opcode_D == 7'b1100011)?instD_com_i[24:20]:0;//accept when R_TYPE
/* verilator lint_off UNUSED */
 logic [59:0]unused;
 assign unused = {instM_com_i[31:12],instX_com_i[31:25],instX_com_i[19:12],instW_com_i[31:7]};
/* verilator lint_on UNUSED */
always_comb begin
	if		((rd_X_com == 0  && rd_M_com == 0))  forward_sel_o = 4'd0;
	else if (instD_com_i==0) forward_sel_o = 4'd0;
	//else if	(rs1_D_com == 0 || rs2_D_com==0) forward_sel_o = 4'd0;
	else begin
		if		(rs1_D_com == rd_X_com && rs2_D_com == rd_X_com && rs2_D_com != 0 && rs1_D_com != 0) forward_sel_o = 4'd1;//a=aluM,b=aluM

		else if	(rs1_D_com == rd_M_com && rs2_D_com == rd_M_com && rs2_D_com != 0 && rs1_D_com != 0 ) forward_sel_o = 4'd2;//a=aluW,b=aluW	

		else if (rs1_D_com == rd_M_com && rs2_D_com == rd_X_com && rs2_D_com != 0 && rs1_D_com != 0) forward_sel_o = 4'd9;//a=aluW,b=aluM
		else if (rs1_D_com == rd_X_com && rs2_D_com == rd_M_com && rs2_D_com != 0 && rs1_D_com != 0) forward_sel_o = 4'd10;//a=aluM,b=aluW
						
		else if	((rs1_D_com == rd_X_com  && rs1_D_com != 0) && (rs2_D_com == 0 || rs2_D_com != rd_X_com || rs2_D_com != rd_M_com)) forward_sel_o = 4'd3;//a=aluM,b=mux2  \\\\	
				
		else if	((rs1_D_com != rd_M_com || rs1_D_com != rd_X_com) && (rs2_D_com == rd_X_com && rs2_D_com != 0)) forward_sel_o = 4'd4;//a=mux1,b=aluM  ***
		
		else if	((rs1_D_com != rd_M_com || rs1_D_com != rd_X_com) && (rs2_D_com == rd_M_com && rs2_D_com != 0)) forward_sel_o = 4'd8;//a=mux1,b=aluW

		else if	((rs1_D_com == rd_M_com  && rs1_D_com != 0) && (rs2_D_com == 0 || rs2_D_com != rd_X_com ||  rs2_D_com != rd_M_com )) forward_sel_o = 4'd5;//a=aluW,b=mux2 ???
	
		else forward_sel_o = 4'd0;
	end
end
always_comb begin
	if((rd_M_com == rs2_X_com ) && instX_com_i[6:0]==7'b0100011 && rd_M_com != 0) 		forward_forstore_o = 2'd1;//SPECIAL FOR STORE)
	else if (rd_W_com == rs2_X_com  && instX_com_i[6:0]==7'b0100011 && rd_W_com != 0)  	forward_forstore_o = 2'd2;
	else forward_forstore_o = 2'd0;
end
endmodule : forwarding_control_logic
