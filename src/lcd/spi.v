module spi (
    input clk,
    input rst,

    input [7:0] data,
    input enable,

    output wire spi_data,
    output reg  spi_clk,

    output wire ready,
    output wire busy
);

  localparam IDLE = 2'd0;
  localparam WAIT_HALF_START = 2'd1;
  localparam SENDING = 2'd2;
  localparam WAIT_HALF_END = 2'd3;

  localparam TIME_COUNTER = 18;
  localparam HALF_TIME_COUNTER = 9;

  reg [7:0] current_data;

  reg [4:0] counter = 0;
  reg [1:0] state = IDLE;
  reg [1:0] prev_state = IDLE;

  reg [2:0] index = 3'd7;

  assign spi_data = current_data[index];
  assign ready = prev_state == WAIT_HALF_END && state == IDLE;
  assign busy = state != IDLE;

  always @(posedge clk) begin
    if (rst) begin
      counter <= 0;
      state <= IDLE;
      prev_state <= IDLE;
      current_data <= 0;
      index <= 7;
      spi_clk <= 1;
    end else begin
      prev_state <= state;

      case (state)
        IDLE: begin
          spi_clk <= 0;
          index   <= 7;

          if (enable) begin
            current_data <= data;
            counter <= 0;
            state <= WAIT_HALF_START;
            spi_clk <= 0;
          end
        end

        WAIT_HALF_START: begin
          if (counter == HALF_TIME_COUNTER - 1) begin
            state   <= SENDING;
            counter <= 0;
            spi_clk <= 1;
          end else begin
            counter <= counter + 1;
          end
        end

        SENDING: begin
          if (counter == HALF_TIME_COUNTER - 1) begin
            spi_clk <= ~spi_clk;
            if (index != 0) begin
              index <= index - 1;
            end
          end else if (counter == TIME_COUNTER - 1) begin
            spi_clk <= ~spi_clk;
            counter <= 0;

            if (index == 0) begin
              state   <= WAIT_HALF_END;
              spi_clk <= 1;
            end
          end else begin
            counter <= counter + 1;
          end
        end


        WAIT_HALF_END: begin
          if (counter == HALF_TIME_COUNTER - 1) begin
            state   <= IDLE;
            counter <= 0;
            spi_clk <= 0;
          end else begin
            counter <= counter + 1;
          end
        end
      endcase
    end
  end
endmodule
