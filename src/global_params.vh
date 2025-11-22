`ifndef GLOBAL_PARAMS_VH
`define GLOBAL_PARAMS_VH

// instructions
localparam NOP = 8'd0;
localparam LD = 8'd1;
localparam LDR = 8'd2;
localparam ADD = 8'd3;
localparam SUB = 8'd4;
localparam INC = 8'd5;
localparam DEC = 8'd6;

// general purpose registers
// index
localparam GPR0 = 8'd0;
localparam GPR1 = 8'd1;
localparam GPR2 = 8'd2;
localparam GPR3 = 8'd3;
localparam GPR4 = 8'd4;
localparam GPR5 = 8'd5;
localparam GPR6 = 8'd6;
localparam GPR7 = 8'd7;

// ALU
localparam nop = 8'd0;
localparam addition = 8'd1;
localparam substraction = 8'd2;
localparam increment = 8'd3;
localparam decrement = 8'd4;

`endif
