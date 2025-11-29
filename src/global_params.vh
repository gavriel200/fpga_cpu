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
localparam PSH = 8'd9;  // maybe later change to PUSH
localparam POP = 8'd10;
localparam JMP = 8'd11;
localparam JMR = 8'd12;
localparam JMI = 8'd13;
localparam COM = 8'd14;
localparam CAL = 8'd15;
localparam RTN = 8'd16;

// general purpose registers
localparam GPR0 = 4'd0;
localparam GPR1 = 4'd1;
localparam GPR2 = 4'd2;
localparam GPR3 = 4'd3;
localparam GPR4 = 4'd4;
localparam GPR5 = 4'd5;
localparam GPR6 = 4'd6;
localparam GPR7 = 4'd7;
localparam GPRJ = 4'd8;

// ALU
localparam addition = 5'd0;
localparam substraction = 5'd1;
localparam increment = 5'd2;
localparam decrement = 5'd3;

// flags
localparam Z = 2'd0;
localparam NZ = 2'd1;
localparam C = 2'd2;
localparam NC = 2'd3;

`endif
