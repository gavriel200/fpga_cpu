`ifndef GLOBAL_PARAMS_VH
`define GLOBAL_PARAMS_VH

// instructions
localparam NOP = 8'd0;
localparam LD  = 8'd1;
localparam LDR = 8'd2;
localparam ADD = 8'd3;
localparam SUB = 8'd4;
localparam INC = 8'd5;
localparam DEC = 8'd6;
localparam CLR = 8'd7;
localparam FIL = 8'd8;
localparam PSH = 8'd9;
localparam POP = 8'd10;
localparam JMP = 8'd11;
localparam JZ  = 8'd12;
localparam JNZ = 8'd13;
localparam JC  = 8'd14;
localparam JNC = 8'd15;
localparam COM = 8'd16;
localparam CAL = 8'd17;
localparam RTN = 8'd18;
localparam WR  = 8'd19;
localparam RD  = 8'd20;
localparam CIS = 8'd21; // clear interrupt status
localparam AND = 8'd22; // and
localparam OR = 8'd23; // or
localparam XOR = 8'd24; //xor
localparam XNR = 8'd25; // xnor

// registers
// rw
localparam GPR0 = 4'd0;
localparam GPR1 = 4'd1;
localparam GPR2 = 4'd2;
localparam GPR3 = 4'd3;
localparam GPR4 = 4'd4;
localparam GPR5 = 4'd5;
localparam GPR6 = 4'd6;
localparam GPR7 = 4'd7;
localparam RM = 4'd8;  // ram addr 0
// localparam RM1 = 4'd9;  // ram addr 1
localparam RNDMIN = 8'd10;  // random min
localparam RNDMAX = 8'd11;  // random max
localparam RNDSEED = 8'd12;  // random seed
localparam RNDWE = 8'd13;  // random write seed enable
localparam RLD = 8'd14;  // leds 
localparam RTM0 = 8'd15;  // timer value 0
localparam RTM1 = 8'd16;  // timer value 0
localparam RTMS = 8'd17;  // timer value 0
localparam RTIE = 8'd18; // timer interrupt enable
localparam RIS = 8'd19; // interrupt status
localparam RFBX = 8'd20; // frame buffer x
localparam RFBY = 8'd21; // frame buffer y
localparam RFBD = 8'd22; // frame buffer data
localparam RFBE = 8'd23; // frame buffer enable
localparam RLCDU = 8'd24; // lcd update

// till 31
// ro
localparam RNDRAW = 8'd32;  // random raw value
localparam RNDRANGE = 8'd33;  // random between min and max
localparam RTMD = 8'd34;  // timer done
localparam RLCDR = 8'd35; // lcd ready

// ALU
localparam addition = 3'd0;
localparam subtraction = 3'd1;
localparam increment = 3'd2;
localparam decrement = 3'd3;
localparam bitwise_and = 3'd4;
localparam bitwise_or = 3'd5;
localparam bitwise_xor = 3'd6;
localparam bitwise_xnor = 3'd7;

`endif
