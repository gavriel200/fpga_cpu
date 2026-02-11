// we have screen with = 135X240

// Xx
// Xx   =  x


// 128 / 4 = 32
// 240 / 4 = 60

// we do screen 128X240
// need in the init to change the 135 -> 128

// and we have 1 framebuffer pixel be 4 in the screen

// so we have 32 * 60 * 5(colors) = 9,600 bits - 1.2 kb


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

  initial begin
    frames[10][10] = 4;
    frames[10][12] = 2;
    frames[0][0]   = 5;
    frames[4][4]   = 7;
    frames[32][10] = 7;
  end

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
