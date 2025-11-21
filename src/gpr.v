`include "global_params.vh"

module gpr (
    input clk,
    input rst,

    // write
    input       w_enable,  // write eable
    input [2:0] w_addr,    // which register to update
    input [7:0] w_data,

    // read
    input  [2:0] r_addr_a,
    input  [2:0] r_addr_b,
    output [7:0] r_data_a,
    output [7:0] r_data_b
);
  reg [8*8-1:0] registers;

  assign r_data_a = registers[r_addr_a*8+:8];
  assign r_data_b = registers[r_addr_b*8+:8];

  always @(posedge clk) begin
    if (rst) begin
      registers <= 64'b0;
    end else if (w_enable) begin
      registers[w_addr*8+:8] <= w_data;
    end
  end
endmodule
