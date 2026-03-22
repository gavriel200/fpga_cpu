&state_draw:
CAL @clean_screen

CAL @draw_draw
CAL @draw_again

CAL @wait_for_button_click

WD state_addr, e_state_init

&state_draw_done:
RTN

// ===============================
// ===============================

&draw_draw:
WD draw_symbol.v.param_pixel_color_addr, color_green
WD draw_symbol.v.param_y_axis_addr, 10

WD draw_symbol.v.param_x_axis_addr, 25
WD draw_symbol.v.param_symbol_key, symbol_T
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 30
WD draw_symbol.v.param_symbol_key, symbol_I
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 35
WD draw_symbol.v.param_symbol_key, symbol_E
CAL @draw_symbol

&draw_draw_done:
RTN
