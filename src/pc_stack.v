module pc_stack (
    input clk,
    input rst,

    input          push_enable,
    input [  10:0] push_data,
    input [64-1:0] registers_push_data,

    input           pop_enable,
    output [  10:0] pop_data,
    input  [64-1:0] registers_pop_data
);
  reg [11*32-1:0] memory_pc = 0;
  reg [64*32-1:0] memory_registers = 0;
  reg [5:0] pointer = 0;

  assign pop_data = memory_pc[(pointer-1)*11+:11];
  assign registers_pop_data = memory_registers[(pointer-1)*64+:64];

  always @(posedge clk) begin
    if (rst) begin
      memory_pc <= 0;
      memory_registers <= 0;
      pointer <= 0;
    end else if (push_enable && !pop_enable) begin
      if (pointer < 8'h20) begin
        memory_pc[pointer*11+:11] <= push_data;
        memory_registers[pointer*64+:64] <= registers_push_data;
        pointer <= pointer + 1;
      end
    end else if (pop_enable && !push_enable) begin
      if (pointer > 0) begin
        pointer <= pointer - 1;
      end
    end
  end
endmodule
