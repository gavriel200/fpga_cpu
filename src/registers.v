`include "global_params.vh"

module registers (
    input clk,
    input rst,

    // write
    input       w_enable,  // write eable
    input [3:0] w_addr,    // which register to update
    input [7:0] w_data,

    // read
    input  [3:0] r_addr_a,
    input  [3:0] r_addr_b,
    output [7:0] r_data_a,
    output [7:0] r_data_b,

    // ram
    output [11:0] ram_addr
);
  reg [8*11-1:0] registers_data;

  assign r_data_a = registers_data[r_addr_a*8+:8];
  assign r_data_b = registers_data[r_addr_b*8+:8];

  assign ram_addr = registers_data[RM0*8+:12];

  always @(posedge clk) begin
    if (rst) begin
      registers_data <= 0;
    end else if (w_enable) begin
      registers_data[w_addr*8+:8] <= w_data;
    end
  end
endmodule
