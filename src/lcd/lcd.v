module lcd (
    input clk,
    input rst,

    input            spi_ready,
    input            spi_busy,
    output reg       cs,          // spi lcd cs
    output reg       dc,          // data (1) or command (0)
    output reg       spi_enable,
    output reg [7:0] spi_data
);
  initial begin
    cs         = 1;
    dc         = 0;
    spi_enable = 0;
    spi_data   = 0;
  end

  localparam CS_ENABLE = 0;
  localparam CS_DISABLE = 1;

  localparam DC_DATA = 1;
  localparam DC_COMMAND = 0;

  localparam SWRESET = 3'd1;
  localparam SLPOUT = 3'd2;
  localparam INIT = 3'd3;

  localparam IDLE = 3'd4;
  localparam UPDATE = 3'd5;

  reg [2:0] state = SWRESET;

  localparam TICKS_120MS = 3_240_000 - 1;
  reg [21:0] counter = 0;
  reg state_wait = 0;


  localparam init_sequence_len = 15;
  reg [3:0] init_index = 0;
  // first bit data(1)/command(0) then the spi data
  reg [9 * init_sequence_len  - 1 : 0] init_sequence = {
    DC_COMMAND,
    8'h3A,  // COLMOD
    DC_DATA,
    8'h55,  // RGB565 (16bit)

    DC_COMMAND,
    8'h36,  //  (Memory Access Control) [Rotation, Mirroring, RGB/BGR order]
    DC_DATA,
    8'h60,  // portrait


    // resolution: 128X240
    DC_COMMAND,
    8'h2A,  // X start end
    DC_DATA,
    8'h00,  // Xstart[15:8]
    DC_DATA,
    8'h00,  // Xstart[7:0]
    DC_DATA,
    8'h00,  // Xend[15:8]
    DC_DATA,
    8'h7f,  // Xend[7:0]
    // x = 128 

    DC_COMMAND,
    8'h2B,  // Y start end
    DC_DATA,
    8'h00,  // Ystart[15:8]
    DC_DATA,
    8'h00,  // Ystart[7:0]
    DC_DATA,
    8'h00,  // Yend[15:8]
    DC_DATA,
    8'hEF,  // Yend[7:0]
    // Y = 240

    DC_COMMAND,
    8'h29  // (DISPON) display on
  };

  always @(posedge clk) begin

    if (rst) begin
      state      <= SWRESET;
      counter    <= 0;
      state_wait <= 0;
      init_index <= 0;
      // later add more
    end else begin
      case (state)
        SWRESET: begin
          if (state_wait) begin
            if (counter == TICKS_120MS) begin
              state <= SLPOUT;
              counter <= 0;
              state_wait <= 0;
            end else begin
              counter <= counter + 1;
            end
          end else begin
            if (spi_ready) begin
              cs         <= CS_DISABLE;
              state_wait <= 1;
            end else if (!spi_busy) begin
              cs         <= CS_ENABLE;
              dc         <= DC_COMMAND;
              spi_enable <= 1;
              spi_data   <= 8'h01;
            end else if (spi_busy) begin
              spi_enable <= 0;
            end
          end
        end

        SLPOUT: begin
          if (state_wait) begin
            if (counter == TICKS_120MS) begin
              state <= SLPOUT;
              counter <= 0;
              state_wait <= 0;
            end else begin
              counter <= counter + 1;
            end
          end else begin
            if (spi_ready) begin
              cs         <= CS_DISABLE;
              state_wait <= 1;
            end else if (!spi_busy) begin
              cs         <= CS_ENABLE;
              dc         <= DC_COMMAND;
              spi_enable <= 1;
              spi_data   <= 8'h11;
            end else if (spi_busy) begin
              spi_enable <= 0;
            end
          end
        end

        INIT: begin
          if (spi_ready) begin
            cs         <= CS_DISABLE;
            init_index <= init_index + 1;
            if (init_index == init_sequence_len - 1) begin
              state <= IDLE;
            end
          end else if (!spi_busy) begin
            cs         <= CS_ENABLE;
            spi_enable <= 1;
            dc         <= init_sequence[init_index*9];
            spi_data   <= init_sequence[init_index*9+1+:8];
          end else if (spi_busy) begin
            spi_enable <= 0;
          end
        end

        IDLE: begin

        end

        UPDATE: begin

        end
      endcase
    end
  end
endmodule
