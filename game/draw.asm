
// init for the drawing
// load all the symbols:
$draw_base_addr=59
&init_draw:
// 1
WD draw_base_addr, 34
WD draw_base_addr + 1, 34
WD draw_base_addr + 2, 34 
// 2
WD draw_base_addr + 3, 249
WD draw_base_addr + 4, 36
WD draw_base_addr + 5, 143
// 3
WD draw_base_addr + 6, 241
WD draw_base_addr + 7, 241
WD draw_base_addr + 8, 31
// 4
WD draw_base_addr + 9, 153
WD draw_base_addr + 10, 241
WD draw_base_addr + 11, 17
// 5
WD draw_base_addr + 12, 248
WD draw_base_addr + 13, 113
WD draw_base_addr + 14, 159
// 6
WD draw_base_addr + 15, 248
WD draw_base_addr + 16, 249
WD draw_base_addr + 17, 159
// 7
WD draw_base_addr + 18, 241
WD draw_base_addr + 19, 36
WD draw_base_addr + 20, 68
// 8
WD draw_base_addr + 21, 249
WD draw_base_addr + 22, 249
WD draw_base_addr + 23, 159
// 9
WD draw_base_addr + 24, 249
WD draw_base_addr + 25, 241
WD draw_base_addr + 26, 17
// 10
WD draw_base_addr + 27, 187
WD draw_base_addr + 28, 187
WD draw_base_addr + 29, 187
// J
WD draw_base_addr + 30, 242
WD draw_base_addr + 31, 42
WD draw_base_addr + 32, 175
// Q
WD draw_base_addr + 33, 234
WD draw_base_addr + 34, 170
WD draw_base_addr + 35, 175
// K
WD draw_base_addr + 36, 153
WD draw_base_addr + 37, 233
WD draw_base_addr + 38, 153
// club
WD draw_base_addr + 39, 39
WD draw_base_addr + 40, 247
WD draw_base_addr + 41, 34
// spade
WD draw_base_addr + 42, 90
WD draw_base_addr + 43, 90
WD draw_base_addr + 44, 90
// diamond
WD draw_base_addr + 45, 90
WD draw_base_addr + 46, 90
WD draw_base_addr + 47, 90
// heart
WD draw_base_addr + 48, 95
WD draw_base_addr + 49, 255
WD draw_base_addr + 50, 114

// AND logic
$draw_and_logic_addr=110
WD draw_and_logic_addr, 128
WD draw_and_logic_addr + 1, 64
WD draw_and_logic_addr + 2, 32
WD draw_and_logic_addr + 3, 16
WD draw_and_logic_addr + 4, 8
WD draw_and_logic_addr + 5, 4
WD draw_and_logic_addr + 6, 2
WD draw_and_logic_addr + 7, 1
RTN


&draw_symbol:
$p_symbol_addr=56
$p_x_axis_addr=57
$p_y_axis_addr=58



$r_current_byte=R0
$r_current_byte_addr=R1
$r_current_and_logic=R2
$r_current_and_logic_addr=R3

$r_byte_counter=R4
$r_row_counter=R5
$r_col_counter=R6

$r_com=R7

RR r_y_axis, p_y_axis_addr
DEC r_y_axis

RR r_current_byte_addr, p_symbol_addr

LDR r_com, 16
SUB r_current_byte_addr, r_com
LDR r_pixel_color, 8
JC @color_red
LDR r_pixel_color, 1
&color_red:

RR r_current_byte_addr, p_symbol_addr
LD r_com, r_current_byte_addr
// symbol * 3 + 59 - 3
ADD r_current_byte_addr, r_com
ADD r_current_byte_addr, r_com
LDR r_com, 59 - 3
ADD r_current_byte_addr, r_com

LDR r_com, 0

LDR r_byte_counter, 3

&byte_loop:
COM r_byte_counter, r_com
JZ @draw_symbol_done

LDR r_row_counter, 2
RRR r_current_byte, r_current_byte_addr
LDR r_current_and_logic_addr, draw_and_logic_addr

INC r_current_byte_addr
DEC r_byte_counter

&row_loop:
COM r_row_counter, r_com
JZ @byte_loop

LDR r_col_counter, 4
RR r_x_axis, p_x_axis_addr
INC r_y_axis

DEC r_row_counter

&col_loop:
COM r_col_counter, r_com
JZ @row_loop

RRR r_current_and_logic, r_current_and_logic_addr

// check if and
AND r_current_and_logic, r_current_byte
JZ @continue

LDR r_framebuffer_e, 1
LDR r_framebuffer_e, 0

&continue:
INC r_current_and_logic_addr
INC r_x_axis

DEC r_col_counter
JMP @col_loop

&draw_symbol_done:
CAL @update_screen
RTN