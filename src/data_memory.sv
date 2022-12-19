module data_memory(
	input logic clk_i,
	//input logic rst_ni,
	input logic [31:0] wdata_i,
	input logic [11:0]	addr_dmem_i,
	input logic wren_i,
	input logic [3:0] sl_op_i,
	input logic ls_op_i,
	output logic [31:0] rdata_dmem_o,
	///////peripherals////////////
	input  logic [31:0] sw_i,
	output logic [31:0] LEDR_o,LEDG_o,HEX0_o,HEX1_o,HEX2_o,HEX3_o,HEX4_o,HEX5_o,HEX6_o,HEX7_o,
	output logic [31:0] LCD_o
);

logic [31:0] wdata_tmp,rdata_dmem_tmp;
logic [31:0] r_data_tmp;
logic [31:0]    output_per_reg   [10:0] ;
//logic [11:0] addr_dmem_1,addr_dmem_2;//,addr_dmem_tmp;
logic [31:0] rdata_1_tmp,rdata_2_tmp,rdata_0_tmp;
//logic st_en1,st_en2;//,st_en0;
//logic [2:0]load_op_tmp;
//logic [1:0]store_op_tmp;
logic [3:0] addr_sel;
logic unused;

assign addr_sel = addr_dmem_i[11:8];
typedef enum logic[3:0] {
	SB = 4'b0001,
	SH = 4'b0010,
	SW = 4'b0011,
	LB = 4'b0100,
	LH = 4'b0101,
	LW = 4'b0110,
	LBU = 4'b0111,
	LHU = 4'b1000
}sl_op_e;
logic [3:0] sl_op_tmp;

assign sl_op_tmp = sl_op_i;
always_comb begin : store_mux
		case ({sl_op_tmp,ls_op_i}) 
		5'b11110: wdata_tmp = wdata_i ;
		5'b00010:	wdata_tmp = (wdata_i & 32'h000000ff) | (r_data_tmp & 32'hffffff00);
		5'b00110:	wdata_tmp = (wdata_i & 32'h0000ffff) | (r_data_tmp & 32'hffff0000);
		default: wdata_tmp =0;
		endcase
end
//////////////////DEMUX//////////

///////////////////////
//////////////DMEM/////////////////////////
dmem DMEM_INS(
	.clk_i(clk_i),
	.wdata_i(wdata_tmp),
	.addr_dmem_i(addr_dmem_i),
	.wren_i(wren_i),
	.rdata_dmem_o(r_data_tmp)
);
always_comb begin
 rdata_2_tmp = r_data_tmp;
//////////////OUTPUT_PERIPH////////////////////DO AGAIN 
 rdata_1_tmp = r_data_tmp;
 end
always_ff @(posedge clk_i) begin
	if((wren_i==1)) begin
	case (addr_dmem_i[11:0]) 
	   	12'h400 : output_per_reg[0]  <=	wdata_tmp;
	    12'h410 : output_per_reg[1]  <=	wdata_tmp;
	  	12'h420 : output_per_reg[2]  <=	wdata_tmp;
	 	12'h430 : output_per_reg[3]  <=	wdata_tmp;
        12'h440 : output_per_reg[4]  <=	wdata_tmp;	
		12'h450 : output_per_reg[5]  <=	wdata_tmp;
		12'h460 : output_per_reg[6]  <=	wdata_tmp;
		12'h470 : output_per_reg[7]  <=	wdata_tmp;
		12'h480 : output_per_reg[8]  <=	wdata_tmp;
		12'h490 : output_per_reg[9]  <=	wdata_tmp;
		12'h4A0 : output_per_reg[10] <=	wdata_tmp;
	    default  : output_per_reg[10:0] <= output_per_reg[10:0] ; 
	   	endcase
	   	end
end
//assign HEX0_o=  dmem['h400];
//assign HEX1_o=  dmem['h410];
//assign HEX2_o=  dmem['h420];
//assign HEX3_o=  dmem['h430];
//assign HEX4_o=  dmem['h440];
//assign HEX5_o=  dmem['h450];
//assign HEX6_o=  dmem['h460];
//assign HEX7_o=  dmem['h470];
//assign LEDR_o=  dmem['h480];
//assign LEDG_o=  dmem['h490];
//assign LCD_o =  dmem['h4A0];
/////////////////input///////////
//assign rdata_0_tmp = dmem[12'h500];
always_ff @(posedge clk_i) begin
	rdata_0_tmp	 <= sw_i;
end
/////////////rdata_mem_tmp/////////////
always_comb begin : READDATA
	case(addr_sel)
	4'd0:begin
		rdata_dmem_tmp = rdata_2_tmp;
		end 
	4'd1:begin
		rdata_dmem_tmp = rdata_2_tmp;
		end
	4'd2:begin
		rdata_dmem_tmp = rdata_2_tmp;
		end
	4'd3:begin
		rdata_dmem_tmp = rdata_2_tmp;
		end
	4'd4:begin
		rdata_dmem_tmp = rdata_1_tmp;
		end	
	4'd5: begin
		rdata_dmem_tmp = rdata_0_tmp;
	end
	default:begin
		rdata_dmem_tmp = rdata_2_tmp;
		end
		endcase
end

	
always_comb begin : load_mux

		case({sl_op_tmp,ls_op_i})
		5'b11110: 	rdata_dmem_o =  rdata_dmem_tmp  ;
		5'b00011: 	rdata_dmem_o =   rdata_dmem_tmp  & 32'h000000ff;	
		5'b00111:	rdata_dmem_o =   rdata_dmem_tmp & 32'h0000ffff;	
		5'b00010:		rdata_dmem_o = (rdata_dmem_tmp[7] ==1)? (rdata_dmem_tmp & 32'h000000ff | 32'hffffff00):(rdata_dmem_tmp & 32'h000000ff);
		5'b00110:		rdata_dmem_o = (rdata_dmem_tmp[15] ==1)? (rdata_dmem_tmp & 32'h0000ffff | 32'hffff0000):(rdata_dmem_tmp & 32'h0000ffff);
		default:	rdata_dmem_o = 0 ; 
		endcase
end
//peripherals output 
    assign LCD_o      = output_per_reg[10]  ;
    assign	LEDG_o     = output_per_reg[9]   ;
    assign LEDR_o     = output_per_reg[8]   ;
    assign HEX0_o     = output_per_reg[0]   ;
    assign HEX1_o     = output_per_reg[1]    ;
    assign HEX2_o     = output_per_reg[2]    ;
    assign HEX3_o     = output_per_reg[3]    ;
    assign HEX4_o    = output_per_reg[4]    ;
    assign HEX5_o     = output_per_reg[5]    ;
    assign HEX6_o     = output_per_reg[6]    ;
    assign HEX7_o     = output_per_reg[7]    ;
endmodule : data_memory

