module ram (
    input clk,
    input rst,

    input [11:0] addr,

    input       w_enable,
    input [7:0] w_data,

    output [7:0] r_data
);
  reg [8*128-1:0] memory;

  assign r_data = memory[addr*8+:8];

  always @(posedge clk) begin
    if (rst) begin
      memory <= 0;
    end else if (w_enable) begin
      memory[addr*8+:8] <= w_data;
    end
  end
endmodule
