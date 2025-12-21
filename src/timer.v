module timer (
    input clk,
    input rst,

    input [15:0] time_ms,          // 2 registers for writing time
    input        start,
    input        interrupt_enable, // interrupt enable

    output reg done,      // high when timer finished
    output     interrupt  // 1-cycle interrupt pulse
);
  // 1ms = CLK_FREQ_HZ / 1000 cycles
  localparam CLK_FREQ_HZ = 27000000;
  localparam TICKS_PER_MS = CLK_FREQ_HZ / 1000;

  reg [14:0] mhz_to_khz = 0;
  reg [15:0] ms_counter = 0;

  initial begin
    done = 1;
  end
  reg done_prev = 1;
  assign interrupt = done & ~done_prev & interrupt_enable;

  always @(posedge clk) begin
    done_prev <= done;
    if (rst) begin
      mhz_to_khz <= 0;
      ms_counter <= 0;
      done       <= 1;
      done_prev  <= 1;
    end else if (ms_counter > 0) begin
      done <= 0;

      if (mhz_to_khz < TICKS_PER_MS - 1) begin
        mhz_to_khz <= mhz_to_khz + 1;
      end else begin
        mhz_to_khz <= 0;
        ms_counter <= ms_counter - 1;
      end
    end else begin
      done <= 1;

      if (start) begin
        ms_counter <= time_ms;
        mhz_to_khz <= 0;
        done       <= 0;
      end
    end
  end
endmodule
