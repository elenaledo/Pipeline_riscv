module	compare_alu(
	input logic	[31:0]	operand_insa_i,
	input logic [31:0]	operand_insb_i,
	input logic 		uns_i,
	output logic 		result_ins_o,
	output logic 		equal_o
);
logic	M_tmp1,M_tmp2,M_tmp3,M_tmp4,M_tmp5,M_tmp6,M_tmp7,M_tmp8,M_tmp9;
logic	L_tmp1,L_tmp2,L_tmp3,L_tmp4,L_tmp5,L_tmp6,L_tmp7,L_tmp8,L_tmp9;
logic	E_tmp1,E_tmp2,E_tmp3,E_tmp4,E_tmp5,E_tmp6,E_tmp7,E_tmp8,E_tmp9;
logic	[3:0] ap1,ap2,ap3,ap4,ap5,ap6,ap7,ap8;
logic	[3:0] bp1,bp2,bp3,bp4,bp5,bp6,bp7,bp8;
logic  	[7:0] L_temp,M_temp,E_temp;
logic	[3:0] L_pe,M_pe;
logic         equal_tmp,result_tmp;
logic 	[31:0]operand1_tmp;
logic	[31:0]operand2_tmp;
assign 	operand1_tmp = (uns_i==1'b0 && operand_insa_i[31]==1'b1)?(~operand_insa_i + 1):operand_insa_i;
assign  operand2_tmp = (uns_i==1'b0 && operand_insa_i[31]==1'b1)?(~operand_insb_i + 1):operand_insb_i;
assign ap1 =  operand1_tmp[31:28];
assign bp1 =  operand2_tmp[31:28];
assign ap2 =  operand1_tmp[27:24];
assign bp2 =  operand2_tmp[27:24];
assign ap3 =  operand1_tmp[23:20];
assign bp3 =  operand2_tmp[23:20];
assign ap4 =  operand1_tmp[19:16];
assign bp4 =  operand2_tmp[19:16];  
assign ap5 =  operand1_tmp[15:12];
assign bp5 =  operand2_tmp[15:12];
assign ap6 =  operand1_tmp[11:8];
assign bp6 =  operand2_tmp[11:8];
assign ap7 =  operand1_tmp[7:4];
assign bp7 =  operand2_tmp[7:4];
assign ap8 =  operand1_tmp[3:0];
assign bp8 =  operand2_tmp[3:0];
compare_ins com1(
	.A_i(ap1),
	.B_i(bp1),
	.less_o(L_tmp1),
	.more_o(M_tmp1),
	.equal_o(E_tmp1)	
);
compare_ins com2(
	.A_i(ap2),
	.B_i(bp2),
	.less_o(L_tmp2),
	.more_o(M_tmp2),
	.equal_o(E_tmp2)	
);
compare_ins com3(
	.A_i(ap3),
	.B_i(bp3),
	.less_o(L_tmp3),
	.more_o(M_tmp3),
	.equal_o(E_tmp3)	
);
compare_ins com4(
	.A_i(ap4),
	.B_i(bp4),
	.less_o(L_tmp4),
	.more_o(M_tmp4),
	.equal_o(E_tmp4)	
);
compare_ins com5(
	.A_i(ap5),
	.B_i(bp5),
	.less_o(L_tmp5),
	.more_o(M_tmp5),
	.equal_o(E_tmp5)		
);
compare_ins com6(
	.A_i(ap6),
	.B_i(bp6),
	.less_o(L_tmp6),
	.more_o(M_tmp6),
	.equal_o(E_tmp6)		
);
compare_ins com7(
	.A_i(ap7),
	.B_i(bp7),
	.less_o(L_tmp7),
	.more_o(M_tmp7)	,
	.equal_o(E_tmp7)	
);
compare_ins com8(
	.A_i(ap8),
	.B_i(bp8),
	.less_o(L_tmp8),
	.more_o(M_tmp8),
	.equal_o(E_tmp8)		
);

assign M_temp 		= {M_tmp1,M_tmp2,M_tmp3,M_tmp4,M_tmp5,M_tmp6,M_tmp7,M_tmp8};
assign L_temp 		= {L_tmp1,L_tmp2,L_tmp3,L_tmp4,L_tmp5,L_tmp6,L_tmp7,L_tmp8};
assign E_temp 		= {E_tmp1,E_tmp2,E_tmp3,E_tmp4,E_tmp5,E_tmp6,E_tmp7,E_tmp8}; 
pe_8_3 decoder1(
	.W( L_temp),
	.X( L_pe)
);
pe_8_3 decoder2(
	.W( M_temp),
	.X( M_pe)
);
compare_ins com9(
	.A_i(M_pe),
	.B_i(L_pe),
	.less_o(L_tmp9),
	.more_o(M_tmp9),
	.equal_o(E_tmp9)
);

assign equal_tmp = (&(E_temp)| E_tmp9) & 0;
assign equal_o = (operand_insa_i == operand_insb_i)?1'b1|equal_tmp:1'b0|equal_tmp;
always_comb begin : procx_mux
	if(L_tmp9 == 1'b0 && M_tmp9 == 1'b1)begin
		result_tmp = 1'b0;
		end 
	else if(L_tmp9 == 1'b1 && M_tmp9==1'b0)begin
		result_tmp =1'b1;
		end
	 else begin
		result_tmp =1'bx;
	 	end
end       
assign result_ins_o = (!uns_i & operand_insa_i[31] & !operand_insb_i[31])?1'b1:(!uns_i & !operand_insa_i[31] & operand_insb_i[31])?0:(!uns_i & operand_insa_i[31] & operand_insb_i[31])?(~result_tmp):result_tmp;

endmodule : compare_alu
