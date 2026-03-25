`ifndef GLOBAL_PARAMS_VH
`define GLOBAL_PARAMS_VH

// instructions
localparam NOP = 6'd0;
localparam LD  = 6'd1;
localparam LDR = 6'd2;
localparam ADD = 6'd3;
localparam SUB = 6'd4;
localparam INC = 6'd5;
localparam DEC = 6'd6;
localparam CLR = 6'd7;
localparam FIL = 6'd8;
localparam PSH = 6'd9;
localparam POP = 6'd10;
localparam JMP = 6'd11;
localparam JZ  = 6'd12;
localparam JNZ = 6'd13;
localparam JC  = 6'd14;
localparam JNC = 6'd15;
localparam COM = 6'd16;
localparam CAL = 6'd17;
localparam RTN = 6'd18;
localparam WR  = 6'd19; // write register to addr
localparam WD  = 6'd20; // write data to addr
localparam RR  = 6'd21; // read to register from addr
localparam RWR  = 6'd22; // write register to addr that is read from register
localparam RWD  = 6'd23; // write data to addr that is read from register
localparam RRR  = 6'd24; // read to register from addr that is read from register
localparam CIS = 6'd25; // clear interrupt status
localparam AND = 6'd26; // and
localparam OR  = 6'd27; // or
localparam XOR = 6'd28; //xor
localparam XNR = 6'd29; // xnor

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
// localparam RM = 4'd8;  // ram addr 0
// localparam RM1 = 4'd9;  // ram addr 1
localparam RNDMIN = 8'd10;  // random min
localparam RNDMAX = 8'd11;  // random max
localparam RNDSEED = 8'd12;  // random seed
localparam RNDWE = 8'd13;  // random write seed enable
localparam RLD = 8'd14;  // leds 
localparam RTM0 = 8'd15;  // timer value low byte
localparam RTM1 = 8'd16;  // timer value high byte
localparam RTMS = 8'd17;  // timer start
localparam RTIE = 8'd18; // timer interrupt enable
localparam RIS = 8'd19; // interrupt status
localparam RFBX = 8'd20; // frame buffer x
localparam RFBY = 8'd21; // frame buffer y
localparam RFBD = 8'd22; // frame buffer data
localparam RFBE = 8'd23; // frame buffer enable
localparam RLCDU = 8'd24; // lcd update
localparam RB1IE = 8'd25; // button 1 interrupt enable
localparam RB2IE = 8'd26; // button 2 interrupt enable
localparam RB3IE = 8'd27; // button 3 interrupt enable

// till 31
// ro
localparam RNDRAW = 8'd32;  // random raw value
localparam RNDRANGE = 8'd33;  // random between min and max
localparam RTMD = 8'd34;  // timer done
localparam RLCDR = 8'd35; // lcd ready
localparam RBO1 = 8'd36; // button 1 output
localparam RBO2 = 8'd37; // button 2 output
localparam RBO3 = 8'd38; // button 3 output


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
