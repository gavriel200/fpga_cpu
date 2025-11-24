module flags (
    input clk,
    input rst,

    input w_enable,

    input z_val,
    output reg z,  // zero

    input c_val,
    output reg c  // carry
);
  always @(posedge clk) begin
    if (rst) begin
      z <= 0;
      c <= 0;
    end else if (w_enable) begin
      z <= z_val;
      c <= c_val;
    end
  end
endmodule
