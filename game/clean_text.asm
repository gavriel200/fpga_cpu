// clean the text row

$clean_text.r.x_axis=R0
$clean_text.r.adder=R1
$clean_text.r.com=R2

&clean_text:
LDR clean_text.r.x_axis, 1
LDR clean_text.r.adder, 5
LDR clean_text.r.com, 56

WD draw_symbol.v.param_pixel_color_addr, color_white
WD draw_symbol.v.param_symbol_key, symbol_none
WD draw_symbol.v.param_y_axis_addr, 13

&clean_text_loop:
WR draw_symbol.v.param_x_axis_addr, clean_text.r.x_axis
CAL @draw_symbol

COM clean_text.r.com, clean_text.r.x_axis
JZ @clean_text_done

ADD clean_text.r.x_axis, clean_text.r.adder
JMP @clean_text_loop

&clean_text_done:
RTN