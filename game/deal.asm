$player_len_addr=158
$player_cards_addr=159
$player_value_addr=171

$dealer_len_addr=172
$dealer_cards_addr=173
$dealer_value_addr=185

===============================
===============================

$r_deal_card=R0
$r_deal_player_or_dealer=R1
$r_deal_len_addr=R2
$r_deal_len=R3
$r_deal_cards_addr=R4
$r_deal_value_addr=R5
$r_deal_value=R6

// input param (player or dealer)
// player = 0
// dealer = 1

&deal:
POP r_deal_player_or_dealer
DEC r_deal_player_or_dealer
LDR r_deal_len_addr, dealer_len_addr
LDR r_deal_cards_addr, dealer_cards_addr
LDR r_deal_value_addr, dealer_value_addr
JZ @dealer
LDR r_deal_len_addr, player_len_addr
LDR r_deal_cards_addr, player_cards_addr
LDR r_deal_value_addr, player_value_addr
&dealer:

CAL @get_random_card
POP r_deal_card

RRR r_deal_len, r_deal_len_addr
RRR r_deal_value_addr, r_deal_value

ADD r_deal_cards_addr, r_deal_len
RWR r_deal_cards_addr, r_deal_card

INC r_deal_len
RWR r_deal_len_addr, r_deal_len

PSH r_deal_card
CAL @get_card_value
POP r_deal_value

RWR r_deal_value_addr, r_deal_value

INC r_deal_player_or_dealer
PSH r_deal_player_or_dealer
CAL @draw_card

&deal_done:
RTN

===============================
===============================

$r_get_random_random_value=RNDRANGE

$r_get_random_card_index=R0
$r_get_random_card_value=R1
$r_get_random_card_taken_card=R2

// return card

&get_random_card:
LDR r_get_random_card_taken_card, taken

LD r_get_random_card_index, r_get_random_random_value
DEC r_get_random_card_index

RRR r_get_random_card_value, r_get_random_card_index

AND r_get_random_card_taken_card, r_get_random_card_value
JNZ @get_random_card

// set to taken
OR r_get_random_card_value, taken

// update cards in ram
RWR r_get_random_card_index, r_get_random_card_value

// return value
PSH r_get_random_card_value
&get_random_card_done:
RTN

===============================
===============================

// input param card
// return int value

&get_card_value:


&get_card_value_done:
RTN


===============================
===============================

// input param (player or dealer)
&draw_card:

&draw_card_done:
RTN


