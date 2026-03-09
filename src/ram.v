module ram (
    input clk,

    input [7:0] addr,

    input       w_enable,
    input [7:0] w_data,

    output reg [7:0] r_data
);

  (* ram_style = "block" *)
  reg [7:0] memory[0:255];


  // assign r_data = memory[addr*8+:8];

  always @(posedge clk) begin
    if (w_enable) begin
      memory[addr] <= w_data;
    end

    r_data <= memory[addr];
  end

endmodule
