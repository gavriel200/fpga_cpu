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
localparam CLR = 8'd7;
localparam FIL = 8'd8;

// general purpose registers
// index
localparam GPR0 = 3'd0;
localparam GPR1 = 3'd1;
localparam GPR2 = 3'd2;
localparam GPR3 = 3'd3;
localparam GPR4 = 3'd4;
localparam GPR5 = 3'd5;
localparam GPR6 = 3'd6;
localparam GPR7 = 3'd7;

// ALU
localparam addition = 5'd0;
localparam substraction = 5'd1;
localparam increment = 5'd2;
localparam decrement = 5'd3;

`endif
