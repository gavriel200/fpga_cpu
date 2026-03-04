$cards_addr=0
$cards_len=52

// 00000000
$hearts=0
// 00100000
$spades=32
// 01000000
$diamonds=64
// 01100000
$clubs=96

$hearts_addr=52
$spades_addr=53
$diamonds_addr=54
$clubs_addr=55

// 0000000
$not_take=0
// 10000000
$taken=128 

$cards_per_suit=13

&init_suits:
WD hearts_addr, hearts
WD spades_addr, spades
WD diamonds_addr, diamonds
WD clubs_addr, clubs

&init_cards:
// addr=0
// for suit in suits:
//     for i in range(13):
//         ram[addr] = i | suit
//         addr ++
$r_card_pointer=R0
$r_suit_pointer=R1

$r_card_holder=R2
$r_suit_holder=R3
$r_card_value_holder=R4

$r_counter_cards_per_suit=R4
$r_counter_suits=R5

LDR r_counter_cards_per_suit, 13
LDR r_counter_suits, 4

LDR r_card_pointer, cards_addr
LDR r_suit_pointer, hearts_addr

// load card
LDR r_card_holder, 1
RRR r_suit_holder, r_suit_pointer

OR r_card_value_holder, r_card_holder
OR r_card_value_holder, r_suit_holder














