module inst_memory #(
  parameter int unsigned IMEM_W = 14
) (
  input  logic [13:0] addr_inst_i ,
  output logic [31:0]       data_inst_o,

  /* verilator lint_off UNUSED */
  input  logic              clk_i   ,
  input  logic              rst_ni
  /* verilator lint_on UNUSED */
);

  /* verilator lint_off UNUSED */
  logic unused;
  assign unused = |addr_inst_i[1:0];
  /* verilator lint_on UNUSED */


  logic [3:0][7:0] imem [2**(IMEM_W-2)-1:0];


  initial begin
    $readmemh("./memory/instmem.data.sim", imem);
  end



  always_comb begin : proc_data
    data_inst_o = imem[addr_inst_i[IMEM_W-1:2]][3:0];
  end

endmodule : inst_memory
