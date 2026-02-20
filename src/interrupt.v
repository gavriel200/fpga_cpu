module interrupt (
    input clk,
    input rst,

    input            clear_status,
    output reg [7:0] status,
    output           jump,

    input timer_interrupt
);
  assign jump = timer_interrupt && !clear_status;


  always @(posedge clk) begin
    if (rst) begin
      status <= 0;
    end else begin
      if (clear_status) begin
        status <= 8'd0;
      end else if (timer_interrupt) begin
        status <= status | 1;
      end
    end
  end
endmodule
