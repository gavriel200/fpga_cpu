module timer (
    input clk,
    input rst,

    // input i_enable,  // interrupt enable
    input [15:0] time_ms,  // 2 registers for writing time
    input start,

    output done
);
  reg [14:0] mhz_to_khz = 0;
  reg [15:0] ms_counter = 0;
  assign done = ms_counter == 0;

  always @(posedge clk) begin
    if (rst) begin
      mhz_to_khz <= 0;
      ms_counter <= 0;
    end else if (ms_counter > 0) begin
      if (mhz_to_khz < 15'd27000 - 1) begin
        mhz_to_khz <= mhz_to_khz + 1;
      end else begin
        mhz_to_khz <= 0;
        ms_counter <= ms_counter - 1;
      end
    end else if (start) begin
      ms_counter <= time_ms;
    end
  end
endmodule
