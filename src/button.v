module button (
    input clk,
    input rst,

    input input_button,

    input interrupt_enable,

    output reg output_button,

    output interrupt
);
  initial begin
    output_button = 0;
  end
  reg output_button_prev = 0;

  localparam TARGET_4HZ = 6750000;

  reg [22:0] counter = 0;

  assign interrupt = output_button & ~output_button_prev & interrupt_enable;

  always @(posedge clk) begin
    output_button_prev <= output_button;
    if (rst) begin
      counter <= 0;
      output_button <= 0;
      output_button_prev <= 0;
    end else begin
      if (input_button) begin
        if (counter < TARGET_4HZ - 1) begin
          counter <= counter + 1;
        end else begin
          output_button <= 1;
        end
      end else begin
        counter <= 0;
        output_button <= 0;
      end
    end
  end

endmodule
