$cards_addr=0
$cards_per_suit=13


&init_cards:
$r_card_pointer=R0
$r_suit_pointer=R1

$r_card_holder=R2
$r_suit_holder=R3
$r_card_value_holder=R4

$r_counter_cards_per_suit=R5
$r_counter_suits=R6

$init_cards.v.hearts_addr=52

LDR r_card_pointer, cards_addr
LDR r_suit_pointer, init_cards.v.hearts_addr - 1

LDR r_counter_suits, 4 + 1

&next_suit:
LDR r_counter_cards_per_suit, 13
DEC r_counter_suits
JZ @init_cards_done
INC r_suit_pointer
LDR r_card_holder, 1
RRR r_suit_holder, r_suit_pointer
OR r_card_holder, r_suit_holder
&next_card:
RWR r_card_pointer, r_card_holder
INC r_card_holder
INC r_card_pointer
DEC r_counter_cards_per_suit
JZ @next_suit
JMP @next_card

&init_cards_done:
RTN
