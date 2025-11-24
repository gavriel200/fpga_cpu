`include "global_params.vh"

module alu (
    input [2:0] operation,

    input [7:0] A,
    input [7:0] B,

    output reg [7:0] C,

    output reg flags_c_val,  // carry / NOT borrow op for sub/dec
    output reg flags_z_val   // zero
);

  reg [8:0] tmp;

  always @(*) begin
    flags_c_val = 0;

    case (operation)

      addition: begin
        tmp = {1'b0, A} + {1'b0, B};
        C = tmp[7:0];

        flags_c_val = tmp[8];
      end

      substraction: begin
        tmp = {1'b0, A} - {1'b0, B};
        C = tmp[7:0];

        flags_c_val = ~tmp[8];  // NOT borrow
      end

      increment: begin
        tmp = {1'b0, A} + 1;
        C = tmp[7:0];

        flags_c_val = tmp[8];
      end

      decrement: begin
        tmp = {1'b0, A} - 1;
        C = tmp[7:0];

        flags_c_val = ~tmp[8];  // NOT borrow
      end
    endcase

    flags_z_val = (C == 8'd0);
  end

endmodule
