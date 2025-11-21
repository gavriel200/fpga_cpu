module rom (
    input            clk,
    input            rst,
    input            enable,  // increments pc each clk while enabled
    output [8*3-1:0] data
);
  reg [7:0] pc = 0;
  reg [8*3-1:0] rom_data[0:254];  // 255 lines, each 3 bytes

  assign data = rom_data[pc];

  initial begin
    $readmemh("main.hex", rom_data);
  end

  always @(posedge clk) begin
    if (rst) begin
      pc <= 0;
    end else if (enable) begin
if (pc < 255) begin
      pc <= pc + 1;
    end
end
  end
endmodule
