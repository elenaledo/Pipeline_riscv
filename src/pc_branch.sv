module pc_branch(
	input logic br_less_i,
	input logic br_equal_i,
	input logic is_pc_i,
	input logic [6:0] instr_opcode_i,
	input logic [2:0] instr_branch_i,

	output logic pc_sel_o
);

always_comb begin : mux
	case({instr_opcode_i,is_pc_i})
	8'b1100011_1: begin //B_TPYE
		case(instr_branch_i)
	 	3'b000:pc_sel_o = (br_equal_i)? 1:0;
	 	3'b001:pc_sel_o = (br_equal_i)? 0:1;
	 	3'b100:pc_sel_o = (br_less_i)? 1:0;
	 	3'b101:pc_sel_o = (!br_less_i | br_equal_i)?1:0;
	 	3'b110:pc_sel_o = (br_less_i)? 1:0;
	 	3'b111:pc_sel_o = (!br_less_i | br_equal_i)?1:0;
		default:pc_sel_o = 1'b0;
		endcase
	end
	8'b11011111: begin //JAL
		pc_sel_o =1'b1;
	end
	8'b11001111: begin	//JALR
		pc_sel_o =1'b1;
	end
	8'b11001110: begin	//JALR
		pc_sel_o =1'b0;
	end
	default: begin
		pc_sel_o =1'bx;
	end
endcase
end

endmodule : pc_branch
