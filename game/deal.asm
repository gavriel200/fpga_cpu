$player_len_addr=158
$player_cards_addr=159
$player_value_addr=171

$dealer_len_addr=172
$dealer_cards_addr=173
$dealer_value_addr=185

// ===============================
// ===============================

$deal.r.card=R0
$deal.r.player_or_dealer=R1
$deal.r.len_addr=R2
$deal.r.len=R3
$deal.r.cards_addr=R4
$deal.r.value_addr=R5
$deal.r.value=R6
$deal.r.value_current=R7

$deal.v.player_y_axis=16
$deal.v.dealer_y_axis=1

// input param (player or dealer)
// player = 0
// dealer = 1

&deal:
POP deal.r.player_or_dealer
DEC deal.r.player_or_dealer
LDR deal.r.len_addr, dealer_len_addr
LDR deal.r.cards_addr, dealer_cards_addr
LDR deal.r.value_addr, dealer_value_addr
WD draw_symbol.r.param_y_axis_addr, deal.v.dealer_y_axis
JZ @dealer
LDR deal.r.len_addr, player_len_addr
LDR deal.r.cards_addr, player_cards_addr
LDR deal.r.value_addr, player_value_addr
WD draw_symbol.r.param_y_axis_addr, deal.v.player_y_axis
&dealer:

CAL @get_random_card
POP deal.r.card

RRR deal.r.len, deal.r.len_addr
RRR deal.r.value_addr, deal.r.value

ADD deal.r.cards_addr, deal.r.len
RWR deal.r.cards_addr, deal.r.card

INC deal.r.len
RWR deal.r.len_addr, deal.r.len

PSH deal.r.card
CAL @get_card_value
POP deal.r.value

RRR deal.r.value_current, deal.r.value_addr
ADD deal.r.value, deal.r.value_current
RWR deal.r.value_addr, deal.r.value

PSH deal.r.card
PSH deal.r.len
CAL @draw_card

&deal_done:
RTN

// ===============================
// ===============================

$get_random_card.r.random_value=RNDRANGE

$get_random_card.r.index=R0
$get_random_card.r.value=R1
$get_random_card.r.taken_card=R2
$get_random_card.r.taken_or=R3


// 10000000
$get_random_card.v.taken=128 

// return card

&get_random_card:
LDR get_random_card.r.taken_card, get_random_card.v.taken

LD get_random_card.r.index, get_random_card.r.random_value
DEC get_random_card.r.index

RRR get_random_card.r.value, get_random_card.r.index

AND get_random_card.r.taken_card, get_random_card.r.value
JNZ @get_random_card

// set to taken
LDR get_random_card.r.taken_or, get_random_card.v.taken
OR get_random_card.r.value, get_random_card.r.taken_or

// update cards in ram
RWR get_random_card.r.index, get_random_card.r.value

// return value
PSH get_random_card.r.value
&get_random_card_done:
RTN

// ===============================
// ===============================

$get_card_value.r.card=R0
$get_card_value.r.card_value_and=R1
$get_card_value.r.10=R2

// after 10 should return 10
$get_card_value.v.10=10
// 00001111
$get_card_value.v.card_value_and=15


// input param card
// return int value

&get_card_value:
POP get_card_value.r.card

LDR get_card_value.r.10, get_card_value.v.10
LDR get_card_value.r.card_value_and, get_card_value.v.card_value_and

// get only the number on card no suit
AND get_card_value.r.card, get_card_value.r.card_value_and

COM get_card_value.r.card, get_card_value.r.10
JNC @more_then_10
PSH get_card_value.r.card
JMP @get_card_value_done

&more_then_10:
PSH get_card_value.r.10
JMP @get_card_value_done

&get_card_value_done:
RTN


// ===============================
// ===============================

$draw_card.r.len=R0
$draw_card.r.card=R1
$draw_card.r.value=R2
$draw_card.r.suit=R3

$draw_card.r.value_and=R4
// 00001111
$draw_card.v.value_and=15

$draw_card.r.suit_and=R5
// 01100000
$draw_card.v.suit_and=96

$draw_card.r.suit_find=R6

// 00000000
$draw_card.v.heart=0
// 00100000
$draw_card.v.spade=32
// 01000000
$draw_card.v.diamond=64
// 01100000
$draw_card.v.club=96

// input param len
// input param card

&draw_card:
POP draw_card.r.len
POP draw_card.r.card

LDR draw_card.r.value_and, draw_card.v.value_and
AND draw_card.r.value_and, draw_card.r.card

LD draw_card.r.value, draw_card.r.value_and

LDR draw_card.r.suit_and, draw_card.v.suit_and
AND draw_card.r.suit_and, draw_card.r.card

LD draw_card.r.suit, draw_card.r.suit_and

// set x axis for the suit
PSH draw_card.r.len
CAL @set_suit_x_axis

LDR draw_card.r.suit_find, draw_card.v.heart
COM draw_card.r.suit_find, draw_card.r.suit
JZ @draw_heart_symbol

LDR draw_card.r.suit_find, draw_card.v.spade
COM draw_card.r.suit_find, draw_card.r.suit
JZ @draw_spade_symbol

LDR draw_card.r.suit_find, draw_card.v.diamond
COM draw_card.r.suit_find, draw_card.r.suit
JZ @draw_diamond_symbol

LDR draw_card.r.suit_find, draw_card.v.club
COM draw_card.r.suit_find, draw_card.r.suit
JZ @draw_club_symbol

// ==================================

&draw_heart_symbol:
WD draw_symbol.r.param_symbol_key, symbol_heart
WD draw_symbol.r.param_pixel_color_addr, color_red
CAL @draw_symbol
JMP @draw_card_symbol

&draw_spade_symbol:
WD draw_symbol.r.param_symbol_key, symbol_spade
WD draw_symbol.r.param_pixel_color_addr, color_black
CAL @draw_symbol
JMP @draw_card_symbol

&draw_diamond_symbol:
WD draw_symbol.r.param_symbol_key, symbol_diamond
WD draw_symbol.r.param_pixel_color_addr, color_red
CAL @draw_symbol
JMP @draw_card_symbol

&draw_club_symbol:
WD draw_symbol.r.param_symbol_key, symbol_club
WD draw_symbol.r.param_pixel_color_addr, color_black
CAL @draw_symbol
JMP @draw_card_symbol

// ==================================

&draw_card_symbol:
// set x axis for the card
PSH draw_card.r.len
CAL @set_card_x_axis

WR draw_symbol.r.param_symbol_key, draw_card.r.value
WD draw_symbol.r.param_pixel_color_addr, color_black
CAL @draw_symbol

&draw_card_done:
RTN 

// ===============================
// ===============================

$set_suit_x_axis.r.multi_result=R0
$set_suit_x_axis.r.adder=R1

// x=1+10(n−1)

&set_suit_x_axis:
CAL @len_times_10
POP set_suit_x_axis.r.multi_result
LDR set_suit_x_axis.r.adder, 1
ADD set_suit_x_axis.r.multi_result, set_suit_x_axis.r.adder
WR draw_symbol.r.param_x_axis_addr, set_suit_x_axis.r.multi_result

&set_suit_x_axis_done:
RTN

// ===============================
// ===============================

$set_card_x_axis.r.multi_result=R0
$set_card_x_axis.r.adder=R1

// x=6+10(n−1)

&set_card_x_axis:
CAL @len_times_10
POP set_card_x_axis.r.multi_result
LDR set_card_x_axis.r.adder, 6
ADD set_card_x_axis.r.multi_result, set_card_x_axis.r.adder
WR draw_symbol.r.param_x_axis_addr, set_card_x_axis.r.multi_result

&set_card_x_axis_done:
RTN

// ===============================
// ===============================

$len_times_10.r.len=R0
$len_times_10.r.multiplier=R1

&len_times_10:
POP len_times_10.r.len
DEC len_times_10.r.len

LD len_times_10.r.multiplier, len_times_10.r.len

ADD len_times_10.r.len, len_times_10.r.multiplier
ADD len_times_10.r.len, len_times_10.r.multiplier
ADD len_times_10.r.len, len_times_10.r.multiplier
ADD len_times_10.r.len, len_times_10.r.multiplier
ADD len_times_10.r.len, len_times_10.r.multiplier
ADD len_times_10.r.len, len_times_10.r.multiplier
ADD len_times_10.r.len, len_times_10.r.multiplier
ADD len_times_10.r.len, len_times_10.r.multiplier
ADD len_times_10.r.len, len_times_10.r.multiplier

PSH len_times_10.r.len
&len_times_10_done:
RTN

// ===============================
// ===============================
