// draw symbol

$draw_symbol.r.param_symbol_key=56
$draw_symbol.r.param_x_axis_addr=57
$draw_symbol.r.param_y_axis_addr=58
$draw_symbol.r.param_pixel_color_addr=59

$draw_symbol.r.current_byte=R0
$draw_symbol.r.current_byte_addr=R1
$draw_symbol.r.current_and_logic=R2
$draw_symbol.r.current_and_logic_addr=R3

$draw_symbol.r.byte_counter=R4
$draw_symbol.r.row_counter=R5
$draw_symbol.r.col_counter=R6

$draw_symbol.r.com=R7



// input params:
// symbol key (index)
// x axis addr
// y axis addr
// pixel color

&draw_symbol:

RR clean_screen.r.y_axis, draw_symbol.r.param_y_axis_addr
DEC clean_screen.r.y_axis

RR draw_symbol.r.current_byte_addr, draw_symbol.r.param_symbol_key

RR clean_screen.r.pixel_color, draw_symbol.r.param_pixel_color_addr

RR draw_symbol.r.current_byte_addr, draw_symbol.r.param_symbol_key
LD draw_symbol.r.com, draw_symbol.r.current_byte_addr
// symbol * 3 + 60 - 3
ADD draw_symbol.r.current_byte_addr, draw_symbol.r.com
ADD draw_symbol.r.current_byte_addr, draw_symbol.r.com
LDR draw_symbol.r.com, 60 - 3
ADD draw_symbol.r.current_byte_addr, draw_symbol.r.com

LDR draw_symbol.r.com, 0

LDR draw_symbol.r.byte_counter, 3

&byte_loop:
COM draw_symbol.r.byte_counter, draw_symbol.r.com
JZ @draw_symbol_done

LDR draw_symbol.r.row_counter, 2
RRR draw_symbol.r.current_byte, draw_symbol.r.current_byte_addr
LDR draw_symbol.r.current_and_logic_addr, draw_and_logic_addr

INC draw_symbol.r.current_byte_addr
DEC draw_symbol.r.byte_counter

&row_loop:
COM draw_symbol.r.row_counter, draw_symbol.r.com
JZ @byte_loop

LDR draw_symbol.r.col_counter, 4
RR clean_screen.r.x_axis, draw_symbol.r.param_x_axis_addr
INC clean_screen.r.x_axis

DEC draw_symbol.r.row_counter

&col_loop:
COM draw_symbol.r.col_counter, draw_symbol.r.com
JZ @row_loop

RRR draw_symbol.r.current_and_logic, draw_symbol.r.current_and_logic_addr

// check if and
AND draw_symbol.r.current_and_logic, draw_symbol.r.current_byte
JZ @continue

LDR clean_screen.r.framebuffer_e, 1
LDR clean_screen.r.framebuffer_e, 0

&continue:
INC draw_symbol.r.current_and_logic_addr
INC clean_screen.r.x_axis

DEC draw_symbol.r.col_counter
JMP @col_loop

&draw_symbol_done:
CAL @update_screen
RTN