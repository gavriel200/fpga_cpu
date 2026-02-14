module framebuffer (
    input clk,
    input rst,

    input [5:0] x_update,
    input [5:0] y_update,
    input [3:0] data_update,
    input       enable_update,

    input  [5:0] x_output,
    input  [5:0] y_output,
    output [3:0] frame
);
  reg [3:0] frames[59:0][31:0];  // 60 x 32 array

  assign frame = frames[x_output][y_output];

  always @(posedge clk) begin
    //    if (rst) begin
    //      ;  // stop
    //    end else begin
    if (enable_update) begin
      frames[x_update][y_update] <= data_update;
    end
    //    end
  end

endmodule
