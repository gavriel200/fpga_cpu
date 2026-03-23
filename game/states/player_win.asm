&state_player_win:
CAL @clean_text

CAL @draw_victory
CAL @draw_again

CAL @wait_for_button_click

WD state_addr, e_state_init

&state_player_win_done:
RTN

// ===============================
// ===============================

&draw_victory:
WD draw_symbol.v.param_pixel_color_addr, color_green
WD draw_symbol.v.param_y_axis_addr, 13

WD draw_symbol.v.param_x_axis_addr, 6
WD draw_symbol.v.param_symbol_key, symbol_V
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 11
WD draw_symbol.v.param_symbol_key, symbol_I
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 16
WD draw_symbol.v.param_symbol_key, symbol_C
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 21
WD draw_symbol.v.param_symbol_key, symbol_T
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 26
WD draw_symbol.v.param_symbol_key, symbol_O
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 31
WD draw_symbol.v.param_symbol_key, symbol_R
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 36
WD draw_symbol.v.param_symbol_key, symbol_Y
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 41
WD draw_symbol.v.param_symbol_key, symbol_!
CAL @draw_symbol

&draw_victory_done:
RTN
