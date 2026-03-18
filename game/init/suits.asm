$init_suits.v.hearts_addr=52
$init_suits.v.spades_addr=53
$init_suits.v.diamonds_addr=54
$init_suits.v.clubs_addr=55

// 00000000
$init_suits.v.hearts=0
// 00100000
$init_suits.v.spades=32
// 01000000
$init_suits.v.diamonds=64
// 01100000
$init_suits.v.clubs=96

&init_suits:
WD init_suits.v.hearts_addr,   init_suits.v.hearts
WD init_suits.v.spades_addr,   init_suits.v.spades
WD init_suits.v.diamonds_addr, init_suits.v.diamonds
WD init_suits.v.clubs_addr,    init_suits.v.clubs
&init_suits_done:
RTN
