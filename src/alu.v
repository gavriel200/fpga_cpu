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
      substraction: begin
        C = A - B;
      end
      increment: begin
        C = A + 1;
      end
      decrement: begin
        C = A - 1;
      end
    endcase
  end

endmodule
