&state_player_win:
CAL @clean_screen

CAL @draw_victory
CAL @draw_again

CAL @wait_for_button_click

WD state_addr, e_state_init

&state_player_win_done:
RTN

// ===============================
// ===============================

&draw_victory:
WD draw_symbol.r.param_pixel_color_addr, color_green
WD draw_symbol.r.param_y_axis_addr, 10

WD draw_symbol.r.param_x_axis_addr, 5
WD draw_symbol.r.param_symbol_key, symbol_V
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 10
WD draw_symbol.r.param_symbol_key, symbol_1
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 15
WD draw_symbol.r.param_symbol_key, symbol_C
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 20
WD draw_symbol.r.param_symbol_key, symbol_T
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 25
WD draw_symbol.r.param_symbol_key, symbol_O
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 30
WD draw_symbol.r.param_symbol_key, symbol_R
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 35
WD draw_symbol.r.param_symbol_key, symbol_Y
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 40
WD draw_symbol.r.param_symbol_key, symbol_!
CAL @draw_symbol

&draw_victory_done:
RTN
