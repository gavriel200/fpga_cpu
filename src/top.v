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

  reg rom_enable = 1;
  wire [8*3-1:0] rom_data;
  rom(
      .clk(clk), .rst(rst), .enable(rom_enable), .data(rom_data)
  );

  wire gpr_w_enable;
  wire [2:0] gpr_w_addr;
  wire [7:0] gpr_w_data;
  wire [2:0] gpr_r_addr_a;
  wire [2:0] gpr_r_addr_b;
  wire [7:0] gpr_r_data_a;
  wire [7:0] gpr_r_data_b;
  gpr(
      .clk(clk),
      .rst(rst),
      .w_enable(gpr_w_enable),
      .w_addr(gpr_w_addr),
      .w_data(gpr_w_data),
      .r_addr_a(gpr_r_addr_a),
      .r_addr_b(gpr_r_addr_b),
      .r_data_a(gpr_r_data_a),
      .r_data_b(gpr_r_data_b)
  );

  wire [4:0] alu_operation;
  wire [7:0] alu_A;
  wire [7:0] alu_B;
  wire [7:0] alu_C;
  alu(
      .operation(alu_operation), .A(alu_A), .B(alu_B), .C(alu_C)
  );
  //
  decoder(
      .rom_data(rom_data),
      .gpr_w_enable(gpr_w_enable),
      .gpr_w_addr(gpr_w_addr),
      .gpr_w_data(gpr_w_data),
      .gpr_r_addr_a(gpr_r_addr_a),
      .gpr_r_addr_b(gpr_r_addr_b),
      .gpr_r_data_a(gpr_r_data_a),
      .gpr_r_data_b(gpr_r_data_b),
      .alu_operation(alu_operation),
      .alu_A(alu_A),
      .alu_B(alu_B),
      .alu_C(alu_C)
  );

endmodule

