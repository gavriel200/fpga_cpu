module top (
    input clk,

    input  rst_btn,
    output rst_led
);
  wire rst;
  reset(
      .clk(clk), .rst_btn(rst_btn), .rst(rst)
  );

  assign rst_led = !rst;

  reg            rom_enable = 1;
  wire [8*3-1:0] rom_data;
  wire [    7:0] rom_pc;
  wire           rom_jump_enable;
  wire [    7:0] rom_jump_data;
  rom(
      .clk(clk),
      .rst(rst),
      .enable(rom_enable),
      .data(rom_data),
      .pc(rom_pc),
      .jump_enable(rom_jump_enable),
      .jump_data(rom_jump_data)
  );

  wire        gpr_w_enable;
  wire [ 3:0] gpr_w_addr;
  wire [ 7:0] gpr_w_data;
  wire [ 3:0] gpr_r_addr_a;
  wire [ 3:0] gpr_r_addr_b;
  wire [ 7:0] gpr_r_data_a;
  wire [ 7:0] gpr_r_data_b;
  wire [11:0] gpr_ram_addr;
  gpr(
      .clk(clk),
      .rst(rst),
      .w_enable(gpr_w_enable),
      .w_addr(gpr_w_addr),
      .w_data(gpr_w_data),
      .r_addr_a(gpr_r_addr_a),
      .r_addr_b(gpr_r_addr_b),
      .r_data_a(gpr_r_data_a),
      .r_data_b(gpr_r_data_b),
      .ram_addr(gpr_ram_addr)
  );

  wire flags_w_enable;
  wire flags_z_val;
  wire flags_z;
  wire flags_c_val;
  wire flags_c;
  flags(
      .clk(clk),
      .rst(rst),
      .w_enable(flags_w_enable),
      .z_val(flags_z_val),
      .z(flags_z),
      .c_val(flags_c_val),
      .c(flags_c)
  );


  wire [4:0] alu_operation;
  wire [7:0] alu_A;
  wire [7:0] alu_B;
  wire [7:0] alu_C;
  alu(
      .operation(alu_operation),
      .A(alu_A),
      .B(alu_B),
      .C(alu_C),
      .flags_z_val(flags_z_val),
      .flags_c_val(flags_c_val)
  );


  wire stack_push_enable;
  wire [7:0] stack_push_data;
  wire stack_pop_enable;
  wire [7:0] stack_pop_data;
  stack(
      .clk(clk),
      .rst(rst),
      .push_enable(stack_push_enable),
      .push_data(stack_push_data),
      .pop_enable(stack_pop_enable),
      .pop_data(stack_pop_data)
  );

  wire       ram_w_enable;
  wire [7:0] ram_w_data;
  wire [7:0] ram_r_data;
  ram(
      .clk(clk),
      .rst(rst),
      .addr(gpr_ram_addr),
      .w_enable(ram_w_enable),
      .w_data(ram_w_data),
      .r_data(ram_r_data)
  );

  //
  decoder(
      .rom_data(rom_data),
      .rom_pc(rom_pc),
      .rom_jump_enable(rom_jump_enable),
      .rom_jump_data(rom_jump_data),
      .gpr_w_enable(gpr_w_enable),
      .gpr_w_addr(gpr_w_addr),
      .gpr_w_data(gpr_w_data),
      .gpr_r_addr_a(gpr_r_addr_a),
      .gpr_r_addr_b(gpr_r_addr_b),
      .gpr_r_data_a(gpr_r_data_a),
      .gpr_r_data_b(gpr_r_data_b),
      .alu_operation(alu_operation),
      .flags_w_enable(flags_w_enable),
      .alu_A(alu_A),
      .alu_B(alu_B),
      .alu_C(alu_C),
      .flags_z(flags_z),
      .flags_c(flags_c),
      .stack_push_enable(stack_push_enable),
      .stack_push_data(stack_push_data),
      .stack_pop_enable(stack_pop_enable),
      .stack_pop_data(stack_pop_data),
      .ram_w_enable(ram_w_enable),
      .ram_w_data(ram_w_data),
      .ram_r_data(ram_r_data)
  );

endmodule

