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

CAL @clean_screen

CAL @deal_init_cards
CAL @draw_dealer_flipped_card

WD state_addr, e_state_player_turn

&state_init_done:
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

// ===============================
// ===============================

&draw_dealer_flipped_card:
WD draw_symbol.v.param_pixel_color_addr, color_turkiz
WD draw_symbol.v.param_y_axis_addr, 6
WD draw_symbol.v.param_x_axis_addr, 6
WD draw_symbol.v.param_symbol_key, symbol_flipped_card
CAL @draw_symbol
&draw_dealer_flipped_card_done:
RTN

// ===============================
// ===============================
