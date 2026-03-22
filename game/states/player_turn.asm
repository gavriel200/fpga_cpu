&state_player_turn:
CAL @draw_hit_stay

&wait_for_player_move:
LDR R0, 1
COM R0, RBO1
JZ @hit
COM R0, RBO2
JZ @stay
JMP @wait_for_player_move

&hit:
WD state_addr, e_state_hit
JMP @state_player_turn_done

&stay:
WD state_addr, e_state_dealer_hit
JMP @state_player_turn_done


&state_player_turn_done:
// clean buttons 
RTN


// ===============================
// ===============================


&draw_hit_stay:
WD draw_symbol.v.param_pixel_color_addr, color_black
WD draw_symbol.v.param_y_axis_addr, 10

WD draw_symbol.v.param_x_axis_addr, 10
WD draw_symbol.v.param_symbol_key, symbol_H
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 15
WD draw_symbol.v.param_symbol_key, symbol_I
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 20
WD draw_symbol.v.param_symbol_key, symbol_T
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 30
WD draw_symbol.v.param_symbol_key, symbol_S
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 35
WD draw_symbol.v.param_symbol_key, symbol_T
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 40
WD draw_symbol.v.param_symbol_key, symbol_A
CAL @draw_symbol

WD draw_symbol.v.param_x_axis_addr, 45
WD draw_symbol.v.param_symbol_key, symbol_Y
CAL @draw_symbol

&draw_hit_stay_done:
RTN