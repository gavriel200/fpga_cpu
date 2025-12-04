module random (
    input clk,
    input rst,

    input       w_enable,
    input [7:0] seed,      // set to 0 to disable

    input [7:0] min,
    input [7:0] max,

    output reg [7:0] raw,
    output     [7:0] range
);
  always @(posedge clk) begin
    if (rst) begin
      raw <= 0;
    end else if (w_enable) begin
      raw <= seed;
    end else begin
      raw <= {raw[6:0], raw[7] ^ raw[5] ^ raw[4] ^ raw[3]};
    end
  end

  assign range = min + (raw % (max - min + 1));
endmodule
