module rom (
    input clk,
    input rst,

    input                enable,  // increments pc each clk while enabled
    output     [8*3-1:0] data,
    output reg [   10:0] pc,

    // jump
    input        jump_enable,
    input [10:0] jump_data,

    input interrupt_jump,
    input interrupt_clear_status
);
  localparam INTERRUPT_JUMP_LOCATION = 11'h3E8;  // line 1000
  localparam ROM_LEN = 11'h400;  // 1024 lines
  // reg [8*3-1:0] rom_data[0:ROM_LEN-1];  // each 3 bytes
  (* syn_ramstyle = "block_ram" *) reg [8*3-1:0] rom_data[0:ROM_LEN-1];


  assign data = rom_data[pc];

  reg [10:0] pre_interrupt_pc = 0;

  initial begin
    pc = 0;
    $readmemh("main.hex", rom_data);
  end

  always @(posedge clk) begin
    if (rst) begin
      pc <= 0;
    end else begin
      if (interrupt_jump) begin
        pre_interrupt_pc <= pc;
        pc               <= INTERRUPT_JUMP_LOCATION;
      end else if (interrupt_clear_status) begin
        pc <= pre_interrupt_pc;
      end else if (jump_enable) begin
        pc <= jump_data;
      end else if (enable) begin
        if (pc < ROM_LEN - 1) begin
          pc <= pc + 1;
        end
      end
    end
  end
endmodule
