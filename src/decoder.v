`include "global_params.vh"

module decoder (
    // rom
    input      [23:0] rom_data,
    input      [ 7:0] rom_pc,
    output reg        rom_jump_enable,
    output reg [ 7:0] rom_jump_data,

    // gpr
    output reg       gpr_w_enable,
    output reg [3:0] gpr_w_addr,
    output reg [7:0] gpr_w_data,
    output reg [3:0] gpr_r_addr_a,
    output reg [3:0] gpr_r_addr_b,
    input      [7:0] gpr_r_data_a,
    input      [7:0] gpr_r_data_b,

    output reg flags_w_enable,

    // alu
    output reg [2:0] alu_operation,
    output reg [7:0] alu_A,
    output reg [7:0] alu_B,
    input      [7:0] alu_C,

    // flags
    input flags_z,
    input flags_c,


    // stack
    output reg       stack_push_enable,
    output reg [7:0] stack_push_data,
    output reg       stack_pop_enable,
    input      [7:0] stack_pop_data
);

  wire [7:0] instruction = rom_data[23:16];
  wire [7:0] arg_a = rom_data[15:8];
  wire [7:0] arg_b = rom_data[7:0];

  always @(*) begin
    // default values (avoid latches)
    rom_jump_enable = 0;
    rom_jump_data = 0;
    gpr_w_enable = 0;
    gpr_w_addr = 0;
    gpr_w_data = 0;
    gpr_r_addr_a = 0;
    gpr_r_addr_b = 0;
    flags_w_enable = 0;
    alu_operation = 0;
    alu_A = 0;
    alu_B = 0;
    stack_push_enable = 0;
    stack_push_data = 0;
    stack_pop_enable = 0;

    case (instruction)
      NOP: begin
        gpr_w_enable = 0;
      end

      LD: begin
        gpr_w_enable = 1;
        gpr_w_addr   = arg_a[3:0];
        gpr_r_addr_a = arg_b[3:0];
        gpr_w_data   = gpr_r_data_a;
      end

      LDR: begin
        gpr_w_enable = 1;
        gpr_w_addr   = arg_a[3:0];
        gpr_w_data   = arg_b;
      end

      ADD: begin
        gpr_w_enable   = 1;
        gpr_w_addr     = arg_a[3:0];

        gpr_r_addr_a   = arg_a[3:0];
        gpr_r_addr_b   = arg_b[3:0];

        flags_w_enable = 1;

        alu_A          = gpr_r_data_a;
        alu_B          = gpr_r_data_b;

        alu_operation  = addition;
        gpr_w_data     = alu_C;
      end

      SUB: begin
        gpr_w_enable   = 1;
        gpr_w_addr     = arg_a[3:0];

        gpr_r_addr_a   = arg_a[3:0];
        gpr_r_addr_b   = arg_b[3:0];

        flags_w_enable = 1;

        alu_A          = gpr_r_data_a;
        alu_B          = gpr_r_data_b;

        alu_operation  = substraction;
        gpr_w_data     = alu_C;
      end

      INC: begin
        gpr_w_enable   = 1;
        gpr_w_addr     = arg_a[3:0];

        gpr_r_addr_a   = arg_a[3:0];

        flags_w_enable = 1;

        alu_A          = gpr_r_data_a;

        alu_operation  = increment;
        gpr_w_data     = alu_C;
      end

      DEC: begin
        gpr_w_enable   = 1;
        gpr_w_addr     = arg_a[3:0];

        gpr_r_addr_a   = arg_a[3:0];

        flags_w_enable = 1;

        alu_A          = gpr_r_data_a;

        alu_operation  = decrement;
        gpr_w_data     = alu_C;
      end

      CLR: begin
        gpr_w_enable = 1;
        gpr_w_addr   = arg_a[3:0];
        gpr_w_data   = 8'h00;
      end

      FIL: begin
        gpr_w_enable = 1;
        gpr_w_addr   = arg_a[3:0];
        gpr_w_data   = 8'hFF;
      end

      PSH: begin
        gpr_r_addr_a      = arg_a[3:0];
        stack_push_enable = 1;
        stack_push_data   = gpr_r_data_a;
      end

      POP: begin
        gpr_w_enable     = 1;
        gpr_w_addr       = arg_a[3:0];
        gpr_w_data       = stack_pop_data;

        stack_pop_enable = 1;
      end

      JMP: begin
        gpr_r_addr_a    = GPRJ;
        rom_jump_enable = 1;
        rom_jump_data   = gpr_r_data_a;
      end

      JMR: begin
        rom_jump_enable = 1;
        rom_jump_data   = arg_a;
      end

      JMI: begin
        if (
          (arg_a == Z && flags_z) ||
          (arg_a == NZ && !flags_z) || 
          (arg_a == C && flags_c) || 
          (arg_a == NZ && !flags_z)
        ) begin
          gpr_r_addr_a    = GPRJ;
          rom_jump_enable = 1;
          rom_jump_data   = gpr_r_data_a;
        end
      end

      COM: begin
        gpr_r_addr_a   = arg_a[3:0];
        gpr_r_addr_b   = arg_b[3:0];

        flags_w_enable = 1;

        alu_A          = gpr_r_data_a;
        alu_B          = gpr_r_data_b;

        alu_operation  = substraction;
      end

      CAL: begin
        stack_push_enable = 1;
        stack_push_data   = rom_pc + 1;

        rom_jump_enable   = 1;
        rom_jump_data     = arg_a;
      end

      RTN: begin
        stack_pop_enable = 1;

        rom_jump_enable  = 1;
        rom_jump_data    = stack_pop_data;
      end
    endcase
  end
endmodule
