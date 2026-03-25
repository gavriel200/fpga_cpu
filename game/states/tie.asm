&state_tie:
CAL @clean_text

CAL @draw_tie
CAL @draw_again

CAL @wait_for_button_click

WD state_addr, e_state_init

&state_tie_done:
RTN

// ===============================
// ===============================

&draw_tie:
WD draw_symbol.v.param_pixel_color_addr, color_purple
WD draw_symbol.v.param_y_axis_addr, 13

WD draw_symbol.v.param_x_axis_addr, 21
WD draw_symbol.v.param_symbol_key, symbol_T
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 26
WD draw_symbol.v.param_symbol_key, symbol_I
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 31
WD draw_symbol.v.param_symbol_key, symbol_E
CAL @draw_symbol

&draw_tie_done:
RTN
