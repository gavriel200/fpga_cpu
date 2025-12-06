`include "global_params.vh"

module registers (
    input clk,
    input rst,

    // write
    input       w_enable,
    input [5:0] w_addr,
    input [7:0] w_data,

    // read
    input  [5:0] r_addr_a,
    input  [5:0] r_addr_b,
    output [7:0] r_data_a,
    output [7:0] r_data_b,

    // ram
    output [11:0] ram_addr,

    // random
    output [7:0] random_min,
    output [7:0] random_max,
    output       random_w_enable,
    output [7:0] random_seed,
    input  [7:0] random_raw,
    input  [7:0] random_range,

    // leds
    output [4:0] leds,

    output [15:0] timer_time_ms,
    output        timer_start,
    input         timer_done
);
  localparam REGISTER_NUM = 40;
  reg [8*REGISTER_NUM-1:0] registers_data;


  assign r_data_a        = read_reg(r_addr_a);
  assign r_data_b        = read_reg(r_addr_b);

  // ram
  assign ram_addr        = registers_data[RM0*8+:12];
  // random
  assign random_min      = registers_data[RNDMIN*8+:8];
  assign random_max      = registers_data[RNDMAX*8+:8];
  assign random_w_enable = registers_data[RNDWE*8+:8];
  assign random_seed     = registers_data[RNDSEED*8+:8];
  // leds
  assign leds            = registers_data[RLD*8+:5];
  // timer
  assign timer_time_ms   = registers_data[RTM0*8+:16];
  assign timer_start     = registers_data[RTMS*8+:8];

  always @(posedge clk) begin
    if (rst) begin
      registers_data <= 0;
    end else if (w_enable && !is_readonly(w_addr)) begin
      registers_data[w_addr*8+:8] <= w_data;
    end
  end

  function [7:0] read_reg;
    input [5:0] addr;

    begin
      if (addr <= 6'h1f) begin
        read_reg = registers_data[addr*8+:8];
      end else begin
        case (addr)
          RNDRAW:   read_reg = random_raw;
          RNDRANGE: read_reg = random_range;
          RTMD:     read_reg = timer_done;
          default:  read_reg = registers_data[(REGISTER_NUM-1)*8+:8];
        endcase
      end
    end
  endfunction

  function automatic is_readonly;
    input [5:0] addr;

    begin
      if (addr <= 6'h1f) begin
        is_readonly = 0;
      end else begin
        is_readonly = 1;
      end
    end
  endfunction

endmodule
