// colors
$color_white=0 
$color_black=1 
$color_yellow=2 
$color_green=3 
$color_turkiz=4 
$color_blue=5 
$color_purple=6 
$color_pink=7 
$color_red=8 
$color_orange=9 
$color_light_blue=10
$color_light_grey=11
$color_dark_grey=12
$color_light_green=13
$color_light_red=14


&draw_symbol:
$p_symbol_addr=56
$p_x_axis_addr=57
$p_y_axis_addr=58
$p_pixel_color_addr=59

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

RR r_pixel_color, p_pixel_color_addr

RR r_current_byte_addr, p_symbol_addr
LD r_com, r_current_byte_addr
// symbol * 3 + 60 - 3
ADD r_current_byte_addr, r_com
ADD r_current_byte_addr, r_com
LDR r_com, 60 - 3
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