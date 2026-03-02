module interrupt (
    input clk,
    input rst,

    input            clear_status,
    output reg [7:0] status,
    output           jump,

    input timer_interrupt,
    input button_1_interrupt,
    input button_2_interrupt,
    input button_3_interrupt
);
  assign jump = (timer_interrupt |
                button_1_interrupt |
                button_2_interrupt |
                button_3_interrupt) &&
                !clear_status;


  wire [7:0] interrupt_set;

  assign interrupt_set = 
        (timer_interrupt    ? 8'b00000001 : 8'b0) |
        (button_1_interrupt ? 8'b00000010 : 8'b0) |
        (button_2_interrupt ? 8'b00000100 : 8'b0) |
        (button_3_interrupt ? 8'b00001000 : 8'b0);


  always @(posedge clk) begin
    if (rst) begin
      status <= 0;
    end else begin
      if (clear_status) begin
        status <= 8'd0;
      end else begin
        status <= status | interrupt_set;
      end
    end
  end
endmodule
