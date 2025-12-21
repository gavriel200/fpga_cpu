module interrupt (
    input            clear_status,
    output reg [7:0] status,
    output reg       jump,

    input timer_interrupt
);
  always @(*) begin
    jump = 0;

    if (clear_status) begin
      status = 8'd0;
    end else if (timer_interrupt) begin
      status = status | 1;
      jump   = 1;
    end
  end
endmodule
