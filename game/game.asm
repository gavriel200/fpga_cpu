NOP
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
$r_card_pointer=R0
$r_suit_pointer=R1

$r_card_holder=R2
$r_suit_holder=R3
$r_card_value_holder=R4

$r_counter_cards_per_suit=R5
$r_counter_suits=R6


LDR r_card_pointer, cards_addr
LDR r_suit_pointer, hearts_addr - 1

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


&clean_screen:
$r_y_axis=RFBY
$r_x_axis=RFBX

// on inc will loop over
$y_axis=0xff 
$x_axis=60

$r_x_axis_com=R0
LDR r_x_axis_com, 0

$r_y_axis_com=R1
LDR r_y_axis_com, 32

$r_pixel_color=RFBD
$pixel_color=8

$r_framebuffer_e=RFBE

$r_lcd_update_e=RLCDU

LDR r_pixel_color, pixel_color

LDR r_y_axis, y_axis

&next_row:
INC r_y_axis
COM r_y_axis_com, r_y_axis
JZ @clean_screen_done

LDR r_x_axis, x_axis

&next_col:
DEC r_x_axis

// update pixel
LDR r_framebuffer_e, 1
LDR r_framebuffer_e, 0

JZ @next_row
JMP @next_col

&clean_screen_done:
CAL @update_screen


&update_screen:
LDR r_lcd_update_e, 1
LDR r_lcd_update_e, 0
RTN



// init for the drawing
// load all the symbols:
$draw_base_addr=59
// 1
WD draw_base_addr, 34
WD draw_base_addr + 1, 34
WD draw_base_addr + 2, 34 
// 2
WD draw_base_addr + 3, 249
WD draw_base_addr + 4, 36
WD draw_base_addr + 5, 143
// 3
WD draw_base_addr + 6, 241
WD draw_base_addr + 7, 241
WD draw_base_addr + 8, 31
// 4
WD draw_base_addr + 9, 153
WD draw_base_addr + 10, 241
WD draw_base_addr + 11, 17
// 5
WD draw_base_addr + 12, 248
WD draw_base_addr + 13, 113
WD draw_base_addr + 14, 159
// 6
WD draw_base_addr + 15, 248
WD draw_base_addr + 16, 249
WD draw_base_addr + 17, 159
// 7
WD draw_base_addr + 18, 241
WD draw_base_addr + 19, 36
WD draw_base_addr + 20, 68
// 8
WD draw_base_addr + 21, 249
WD draw_base_addr + 22, 249
WD draw_base_addr + 23, 159
// 9
WD draw_base_addr + 24, 249
WD draw_base_addr + 25, 241
WD draw_base_addr + 26, 17
// 10
WD draw_base_addr + 27, 187
WD draw_base_addr + 28, 187
WD draw_base_addr + 29, 187
// J
WD draw_base_addr + 30, 242
WD draw_base_addr + 31, 42
WD draw_base_addr + 32, 175
// Q
WD draw_base_addr + 33, 234
WD draw_base_addr + 34, 170
WD draw_base_addr + 35, 175
// K
WD draw_base_addr + 36, 153
WD draw_base_addr + 37, 233
WD draw_base_addr + 38, 153
// diamond
WD draw_base_addr + 39, 90
WD draw_base_addr + 40, 90
WD draw_base_addr + 41, 90
// heart
WD draw_base_addr + 42, 95
WD draw_base_addr + 43, 255
WD draw_base_addr + 44, 114
// club
WD draw_base_addr + 45, 39
WD draw_base_addr + 46, 247
WD draw_base_addr + 47, 34
// spade
WD draw_base_addr + 48, 90
WD draw_base_addr + 49, 90
WD draw_base_addr + 50, 90







