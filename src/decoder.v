`include "global_params.vh"

module decoder (
    // rom
    input      [23:0] rom_data,
    input      [ 7:0] rom_pc,
    output reg        rom_jump_enable,
    output reg [ 7:0] rom_jump_data,

    // registers
    output reg       registers_w_enable,
    output reg [5:0] registers_w_addr,
    output reg [7:0] registers_w_data,
    output reg [5:0] registers_r_addr_a,
    output reg [5:0] registers_r_addr_b,
    input      [7:0] registers_r_data_a,
    input      [7:0] registers_r_data_b,

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
    input      [7:0] stack_pop_data,

    // ram
    input      [7:0] ram_r_data,
    output reg       ram_w_enable,
    output reg [7:0] ram_w_data
);

  wire [7:0] instruction = rom_data[23:16];
  wire [7:0] arg_a = rom_data[15:8];
  wire [7:0] arg_b = rom_data[7:0];

  always @(*) begin
    // default values (avoid latches)
    rom_jump_enable = 0;
    rom_jump_data = 0;
    registers_w_enable = 0;
    registers_w_addr = 0;
    registers_w_data = 0;
    registers_r_addr_a = 0;
    registers_r_addr_b = 0;
    flags_w_enable = 0;
    alu_operation = 0;
    alu_A = 0;
    alu_B = 0;
    stack_push_enable = 0;
    stack_push_data = 0;
    stack_pop_enable = 0;
    ram_w_enable = 0;
    ram_w_data = 0;

    case (instruction)
      NOP: begin
        registers_w_enable = 0;
      end

      LD: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];
        registers_r_addr_a = arg_b[5:0];
        registers_w_data   = registers_r_data_a;
      end

      LDR: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];
        registers_w_data   = arg_b;
      end

      ADD: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];

        registers_r_addr_a = arg_a[5:0];
        registers_r_addr_b = arg_b[5:0];

        flags_w_enable     = 1;

        alu_A              = registers_r_data_a;
        alu_B              = registers_r_data_b;

        alu_operation      = addition;
        registers_w_data   = alu_C;
      end

      SUB: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];

        registers_r_addr_a = arg_a[5:0];
        registers_r_addr_b = arg_b[5:0];

        flags_w_enable     = 1;

        alu_A              = registers_r_data_a;
        alu_B              = registers_r_data_b;

        alu_operation      = substraction;
        registers_w_data   = alu_C;
      end

      INC: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];

        registers_r_addr_a = arg_a[5:0];

        flags_w_enable     = 1;

        alu_A              = registers_r_data_a;

        alu_operation      = increment;
        registers_w_data   = alu_C;
      end

      DEC: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];

        registers_r_addr_a = arg_a[5:0];

        flags_w_enable     = 1;

        alu_A              = registers_r_data_a;

        alu_operation      = decrement;
        registers_w_data   = alu_C;
      end

      CLR: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];
        registers_w_data   = 8'h00;
      end

      FIL: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];
        registers_w_data   = 8'hFF;
      end

      PSH: begin
        registers_r_addr_a = arg_a[5:0];
        stack_push_enable  = 1;
        stack_push_data    = registers_r_data_a;
      end

      POP: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];
        registers_w_data   = stack_pop_data;

        stack_pop_enable   = 1;
      end

      JMP: begin
        registers_r_addr_a    = RJ;
        rom_jump_enable = 1;
        rom_jump_data   = registers_r_data_a;
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
          registers_r_addr_a    = RJ;
          rom_jump_enable = 1;
          rom_jump_data   = registers_r_data_a;
        end
      end

      COM: begin
        registers_r_addr_a = arg_a[5:0];
        registers_r_addr_b = arg_b[5:0];

        flags_w_enable     = 1;

        alu_A              = registers_r_data_a;
        alu_B              = registers_r_data_b;

        alu_operation      = substraction;
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

      WR: begin
        registers_r_addr_a = arg_a[5:0];

        ram_w_enable = 1;
        ram_w_data = registers_r_data_a;
      end

      RD: begin
        registers_w_enable = 1;
        registers_w_addr   = arg_a[5:0];

        registers_w_data   = ram_r_data;
      end
    endcase
  end
endmodule
