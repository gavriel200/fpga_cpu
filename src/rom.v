module rom (
    input clk,
    input rst,

    input                enable,  // increments pc each clk while enabled
    output     [8*3-1:0] data,
    output reg [    7:0] pc,

    // jump
    input       jump_enable,
    input [7:0] jump_data,

    input interrupt_jump,
    input interrupt_clear_status
);
  localparam INTERRUPT_JUMP_LOCATION = 8'd240;
  reg [8*3-1:0] rom_data[0:255];  // 256 lines, each 3 bytes

  assign data = rom_data[pc];

  reg [7:0] pre_interrupt_pc = 0;

  initial begin
    pc = 0;
    $readmemh("main.hex", rom_data);
  end

  always @(posedge clk) begin
    if (rst) begin
      pc <= 0;
    end else begin
      if (interrupt_jump) begin
        pre_interrupt_pc <= pc;
        pc               <= 240;
      end else if (interrupt_clear_status) begin
        pc <= pre_interrupt_pc;
      end else if (jump_enable) begin
        pc <= jump_data;
      end else if (enable) begin
        if (pc < 8'hFF) begin
          pc <= pc + 1;
        end
      end
    end
  end
endmodule
