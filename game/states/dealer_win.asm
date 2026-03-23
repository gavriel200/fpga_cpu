&state_dealer_win:
CAL @clean_screen

CAL @draw_lost
CAL @draw_again

CAL @wait_for_button_click

WD state_addr, e_state_init

&state_dealer_win_done:
RTN


// ===============================
// ===============================

&draw_lost:
WD draw_symbol.v.param_pixel_color_addr, color_black
WD draw_symbol.v.param_y_axis_addr, 13

WD draw_symbol.v.param_x_axis_addr, 21
WD draw_symbol.v.param_symbol_key, symbol_L
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 26
WD draw_symbol.v.param_symbol_key, symbol_O
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 31
WD draw_symbol.v.param_symbol_key, symbol_S
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 36
WD draw_symbol.v.param_symbol_key, symbol_T
CAL @draw_symbol

&draw_lost_done:
RTN


// ===============================
// ===============================

&draw_again:
WD draw_symbol.v.param_x_axis_addr, 45
WD draw_symbol.v.param_symbol_key, symbol_->0
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 49
WD draw_symbol.v.param_symbol_key, symbol_->1
CAL @draw_symbol

&draw_again_done:
RTN

// ===============================
// ===============================