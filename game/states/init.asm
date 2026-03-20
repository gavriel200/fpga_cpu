// init all the stuff
// draw the start
// wait for any button press
// clean screen
// deal 2 cards to player
// deal 1 cards to dealer
// sleep 1 sec
// state = player turn


&state_init:
CAL @clean_ram
CAL @clean_screen

CAL @init_suits
CAL @init_cards

CAL @init_card_select

CAL @init_draw

CAL @draw_start

CAL @wait_for_button_click

CAL @clean_screen

CAL @deal_init_cards

WD state_addr, e_state_player_turn

&state_init_done:
RTN

// ===============================
// ===============================

&draw_start:
WD draw_symbol.r.param_pixel_color_addr, color_black
WD draw_symbol.r.param_y_axis_addr, 10

WD draw_symbol.r.param_x_axis_addr, 20
WD draw_symbol.r.param_symbol_key, symbol_S
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 25
WD draw_symbol.r.param_symbol_key, symbol_T
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 30
WD draw_symbol.r.param_symbol_key, symbol_A
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 35
WD draw_symbol.r.param_symbol_key, symbol_R
CAL @draw_symbol

WD draw_symbol.r.param_x_axis_addr, 40
WD draw_symbol.r.param_symbol_key, symbol_T
CAL @draw_symbol

&draw_start_done:
RTN

// ===============================
// ===============================

&wait_for_button_click:
LDR R0, 1
COM R0, RBO1
JZ @wait_for_button_click_done
COM R0, RBO2
JZ @wait_for_button_click_done
COM R0, RBO3
JZ @wait_for_button_click_done
JMP @wait_for_button_click

&wait_for_button_click_done:
RTN

// ===============================
// ===============================

&deal_init_cards:
LDR R0, 0
PSH R0
CAL @deal

LDR R0, 0
PSH R0
CAL @deal

LDR R0, 1
PSH R0
CAL @deal

&deal_init_cards_done:
RTN