&state_dealer_win:
CAL @clean_screen

CAL @draw_lost
CAL @draw_again

CAL @wait_for_button_click

WD state_addr, e_state_init

&state_dealer_win_done:


// ===============================
// ===============================

&draw_lost:
WD draw_symbol.r.param_pixel_color_addr, color_black
WD draw_symbol.r.param_y_axis_addr, 10

WD draw_symbol.r.param_x_axis_addr, 20
WD draw_symbol.r.param_symbol_key, symbol_L
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 25
WD draw_symbol.r.param_symbol_key, symbol_O
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 30
WD draw_symbol.r.param_symbol_key, symbol_S
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 35
WD draw_symbol.r.param_symbol_key, symbol_T
CAL @draw_symbol

&draw_lost_done:
RTN


// ===============================
// ===============================

&draw_again:
WD draw_symbol.r.param_x_axis_addr, 45
WD draw_symbol.r.param_symbol_key, symbol_->0
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 49
WD draw_symbol.r.param_symbol_key, symbol_->1
CAL @draw_symbol

&draw_again_done:
RTN

// ===============================
// ===============================