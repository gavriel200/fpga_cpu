`include "global_params.vh"

module alu (
    input [2:0] operation,

    input [7:0] A,
    input [7:0] B,

    output reg [7:0] C
);

  always @(*) begin
    case (operation)
      addition: begin
        C = A + B;
      end
    endcase
  end

endmodule
