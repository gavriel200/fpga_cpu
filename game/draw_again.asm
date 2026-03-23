&draw_again:
WD draw_symbol.v.param_pixel_color_addr, color_green
WD draw_symbol.v.param_y_axis_addr, 13

WD draw_symbol.v.param_x_axis_addr, 46
WD draw_symbol.v.param_symbol_key, symbol_->0
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 51
WD draw_symbol.v.param_symbol_key, symbol_->1
CAL @draw_symbol

&draw_again_done:
RTN
