module stack (
    input clk,
    input rst,

    input push_enable,
    input [7:0] push_data,

    input pop_enable,
    output [7:0] pop_data
);
  reg [8*256-1:0] memory = 0;
  reg [7:0] pointer = 0;

  assign pop_data = memory[(pointer-1)*8+:8];

  always @(posedge clk) begin
    if (rst) begin
      memory  <= 0;
      pointer <= 0;
    end else if (push_enable && !pop_enable) begin
      if (pointer < 8'hFF) begin
        memory[pointer*8+:8] <= push_data;
        pointer <= pointer + 1;
      end
    end else if (pop_enable && !push_enable) begin
      if (pointer > 0) begin
        pointer <= pointer - 1;
      end
    end
  end


endmodule
