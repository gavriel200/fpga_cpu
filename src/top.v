module top (
    input clk,

    input  rst_btn,
    output led0,
    output led1,
    output led2,
    output led3,
    output led4,
    output rst_led,

    output lcd_data,
    output lcd_clk,

    output lcd_cs,
    output lcd_rs,
    output lcd_resetn
);
  wire rst;
  reset(
      .clk(clk), .rst_btn(rst_btn), .rst(rst)
  );

  assign rst_led = !rst;

  wire [5:0] framebuffer_x_update;
  wire [5:0] framebuffer_y_update;
  wire [3:0] framebuffer_data_update;
  wire framebuffer_enable_update;
  wire [5:0] framebuffer_x_output;
  wire [5:0] framebuffer_y_output;
  wire [3:0] framebuffer_frame;
  framebuffer(
      .clk(clk),
      .rst(rst),
      .x_update(framebuffer_x_update),
      .y_update(framebuffer_y_update),
      .data_update(framebuffer_data_update),
      .enable_update(framebuffer_enable_update),
      .x_output(framebuffer_x_output),
      .y_output(framebuffer_y_output),
      .frame(framebuffer_frame)
  );

  wire lcd_ready;
  wire lcd_update;
  lcd(
      .clk(clk),
      .rst(rst),

      .lcd_resetn(lcd_resetn),
      .lcd_clk(lcd_clk),
      .lcd_cs(lcd_cs),
      .lcd_rs(lcd_rs),
      .lcd_data(lcd_data),

      .framebuffer_x_output(framebuffer_x_output),
      .framebuffer_y_output(framebuffer_y_output),
      .framebuffer_frame(framebuffer_frame),

      .ready(lcd_ready),
      .update(lcd_update)
  );


  reg            rom_enable = 1;
  wire [8*3-1:0] rom_data;
  wire [   10:0] rom_pc;
  wire           rom_jump_enable;
  wire [   10:0] rom_jump_data;
  wire           interrupt_jump;
  wire           interrupt_clear_status;
  rom(
      .clk(clk),
      .rst(rst),
      .enable(rom_enable),
      .data(rom_data),
      .pc(rom_pc),
      .jump_enable(rom_jump_enable),
      .jump_data(rom_jump_data),
      .interrupt_jump(interrupt_jump),
      .interrupt_clear_status(interrupt_clear_status)
  );


  wire [10:0] registers_ram_addr;
  wire        ram_w_enable;
  wire [ 7:0] ram_w_data;
  wire [ 7:0] ram_r_data;
  ram(
      .clk(clk),
      .rst(rst),
      .addr(registers_ram_addr),
      .w_enable(ram_w_enable),
      .w_data(ram_w_data),
      .r_data(ram_r_data)
  );


  wire [7:0] random_min;
  wire [7:0] random_max;
  wire       random_w_enable;
  wire [7:0] random_seed;
  wire [7:0] random_raw;
  wire [7:0] random_range;
  random(
      .clk(clk),
      .rst(rst),
      .w_enable(random_w_enable),
      .seed(random_seed),
      .min(random_min),
      .max(random_max),
      .raw(random_raw),
      .range(random_range)
  );

  wire [15:0] timer_time_ms;
  wire timer_start;
  wire timer_interrupt_enable;
  wire timer_done;
  wire timer_interrupt;
  timer(
      .clk(clk),
      .rst(rst),
      .time_ms(timer_time_ms),
      .start(timer_start),
      .interrupt_enable(timer_interrupt_enable),
      .done(timer_done),
      .interrupt(timer_interrupt)
  );

  wire [7:0] interrupt_status;
  interrupt(
      .clk(clk),
      .rst(rst),
      .clear_status(interrupt_clear_status),
      .status(interrupt_status),
      .jump(interrupt_jump),
      .timer_interrupt(timer_interrupt)
  );

  wire       registers_w_enable;
  wire [5:0] registers_w_addr;
  wire [7:0] registers_w_data;
  wire [5:0] registers_r_addr_a;
  wire [5:0] registers_r_addr_b;
  wire [7:0] registers_r_data_a;
  wire [7:0] registers_r_data_b;
  wire [4:0] leds;
  assign led0 = !leds[0];
  assign led1 = !leds[1];
  assign led2 = !leds[2];
  assign led3 = !leds[3];
  assign led4 = !leds[4];
  registers(
      .clk(clk),
      .rst(rst),
      .w_enable(registers_w_enable),
      .w_addr(registers_w_addr),
      .w_data(registers_w_data),
      .r_addr_a(registers_r_addr_a),
      .r_addr_b(registers_r_addr_b),
      .r_data_a(registers_r_data_a),
      .r_data_b(registers_r_data_b),
      .ram_addr(registers_ram_addr),
      .random_min(random_min),
      .random_max(random_max),
      .random_w_enable(random_w_enable),
      .random_seed(random_seed),
      .random_raw(random_raw),
      .random_range(random_range),
      .leds(leds),
      .timer_time_ms(timer_time_ms),
      .timer_start(timer_start),
      .timer_done(timer_done),
      .timer_interrupt_enable(timer_interrupt_enable),
      .interrupt_status(interrupt_status),
      .framebuffer_x_update(framebuffer_x_update),
      .framebuffer_y_update(framebuffer_y_update),
      .framebuffer_data_update(framebuffer_data_update),
      .framebuffer_enable_update(framebuffer_enable_update),
      .lcd_ready(lcd_ready),
      .lcd_update(lcd_update)
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


  wire [2:0] alu_operation;
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


  wire pc_stack_push_enable;
  wire [10:0] pc_stack_push_data;
  wire pc_stack_pop_enable;
  wire [10:0] pc_stack_pop_data;
  pc_stack(
      .clk(clk),
      .rst(rst),
      .push_enable(pc_stack_push_enable),
      .push_data(pc_stack_push_data),
      .pop_enable(pc_stack_pop_enable),
      .pop_data(pc_stack_pop_data)
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

  //
  decoder(
      .rom_data(rom_data),
      .rom_pc(rom_pc),
      .rom_jump_enable(rom_jump_enable),
      .rom_jump_data(rom_jump_data),
      .registers_w_enable(registers_w_enable),
      .registers_w_addr(registers_w_addr),
      .registers_w_data(registers_w_data),
      .registers_r_addr_a(registers_r_addr_a),
      .registers_r_addr_b(registers_r_addr_b),
      .registers_r_data_a(registers_r_data_a),
      .registers_r_data_b(registers_r_data_b),
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
      .pc_stack_push_enable(pc_stack_push_enable),
      .pc_stack_push_data(pc_stack_push_data),
      .pc_stack_pop_enable(pc_stack_pop_enable),
      .pc_stack_pop_data(pc_stack_pop_data),
      .ram_w_enable(ram_w_enable),
      .ram_w_data(ram_w_data),
      .ram_r_data(ram_r_data),
      .interrupt_clear_status(interrupt_clear_status)
  );

endmodule

