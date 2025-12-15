module timer (
    input clk,
    input rst,

    input        i_enable,  // interrupt enable
    input [15:0] time_ms,   // number of ms to count
    input        start,     // start pulse

    output reg done,  // high when timer finished
    output interrupt  // 1-cycle interrupt pulse
);

  // 1ms = CLK_FREQ_HZ / 1000 cycles
  localparam CLK_FREQ_HZ = 27000000;
  localparam TICKS_PER_MS = CLK_FREQ_HZ / 1000;

  reg [14:0] mhz_to_khz = 0;
  reg [15:0] ms_counter = 0;

  // Detect rising edge of start
  reg done_prev = 0;
  assign interrupt = done & ~done_prev;

  always @(posedge clk) begin
    done_prev <= done;

    if (rst) begin
      mhz_to_khz <= 0;
      ms_counter <= 0;
      done       <= 1;
      interrupt  <= 0;
    end else begin
      if (ms_counter != 0) begin
        done <= 0;

        if (mhz_to_khz < TICKS_PER_MS - 1) begin
          mhz_to_khz <= mhz_to_khz + 1;
        end else begin
          mhz_to_khz <= 0;
          ms_counter <= ms_counter - 1;

          // If now finished, raise interrupt
          if (ms_counter == 16'd1) begin
            done <= 1;
            if (i_enable) interrupt <= 1;  // 1-cycle interrupt pulse
          end
        end

      end else begin
        done <= 1;

        if (start_rise) begin
          ms_counter <= time_ms;
          mhz_to_khz <= 0;
          done       <= 0;
        end
      end
    end
  end
endmodule
