module rom (
    input clk,
    input rst,

    input            enable,  // increments pc each clk while enabled
    output [8*3-1:0] data,

    // jump
    input       jump_enable,
    input [7:0] jump_data
);
  reg [7:0] pc = 0;
  reg [8*3-1:0] rom_data[0:255];  // 256 lines, each 3 bytes

  assign data = rom_data[pc];

  initial begin
    $readmemh("main.hex", rom_data);
  end

  always @(posedge clk) begin
    if (rst) begin
      pc <= 0;
    end else begin
      if (jump_enable) begin
        pc <= jump_data;
      end else if (enable) begin
        if (pc < 8'hFF) begin
          pc <= pc + 1;
        end
      end
    end
  end
endmodule
