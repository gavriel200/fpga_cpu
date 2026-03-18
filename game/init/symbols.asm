// init for the drawing
// load all the symbols:
$draw_base_addr=60
&init_draw:
// 1
$symbol_1=1
WD draw_base_addr, 34
WD draw_base_addr + 1, 34
WD draw_base_addr + 2, 34 
// 2
$symbol_2=2
WD draw_base_addr + 3, 249
WD draw_base_addr + 4, 36
WD draw_base_addr + 5, 143
// 3
$symbol_3=3
WD draw_base_addr + 6, 241
WD draw_base_addr + 7, 241
WD draw_base_addr + 8, 31
// 4
$symbol_4=4
WD draw_base_addr + 9, 153
WD draw_base_addr + 10, 241
WD draw_base_addr + 11, 17
// 5
$symbol_5=5
WD draw_base_addr + 12, 248
WD draw_base_addr + 13, 113
WD draw_base_addr + 14, 159
// 6
$symbol_6=6
WD draw_base_addr + 15, 248
WD draw_base_addr + 16, 249
WD draw_base_addr + 17, 159
// 7
$symbol_7=7
WD draw_base_addr + 18, 241
WD draw_base_addr + 19, 36
WD draw_base_addr + 20, 68
// 8
$symbol_8=8
WD draw_base_addr + 21, 249
WD draw_base_addr + 22, 249
WD draw_base_addr + 23, 159
// 9
$symbol_9=9
WD draw_base_addr + 24, 249
WD draw_base_addr + 25, 241
WD draw_base_addr + 26, 17
// 10
$symbol_10=10
WD draw_base_addr + 27, 187
WD draw_base_addr + 28, 187
WD draw_base_addr + 29, 187
// J
$symbol_J=11
WD draw_base_addr + 30, 242
WD draw_base_addr + 31, 42
WD draw_base_addr + 32, 174
// Q
$symbol_Q=12
WD draw_base_addr + 33, 234
WD draw_base_addr + 34, 170
WD draw_base_addr + 35, 175
// K
$symbol_K=13
WD draw_base_addr + 36, 153
WD draw_base_addr + 37, 233
WD draw_base_addr + 38, 153
// club
$symbol_club=14
WD draw_base_addr + 39, 39
WD draw_base_addr + 40, 247
WD draw_base_addr + 41, 34
// spade
$symbol_spade=15
WD draw_base_addr + 42, 90
WD draw_base_addr + 43, 90
WD draw_base_addr + 44, 90
// diamond
$symbol_diamond=16
WD draw_base_addr + 45, 90
WD draw_base_addr + 46, 90
WD draw_base_addr + 47, 90
// heart
$symbol_heart=17
WD draw_base_addr + 48, 95
WD draw_base_addr + 49, 255
WD draw_base_addr + 50, 114
// S
$symbol_S=18
WD draw_base_addr + 51, 105
WD draw_base_addr + 52, 66
WD draw_base_addr + 53, 150
// T
$symbol_T=19
WD draw_base_addr + 54, 242
WD draw_base_addr + 55, 34
WD draw_base_addr + 56, 34
// A
$symbol_A=20
WD draw_base_addr + 57, 37
WD draw_base_addr + 58, 89
WD draw_base_addr + 59, 249
// Y
$symbol_Y=21
WD draw_base_addr + 60, 149
WD draw_base_addr + 61, 34
WD draw_base_addr + 62, 34
// H
$symbol_H=22
WD draw_base_addr + 63, 153
WD draw_base_addr + 64, 249
WD draw_base_addr + 65, 153
// L
$symbol_L=23
WD draw_base_addr + 66, 136
WD draw_base_addr + 67, 249
WD draw_base_addr + 68, 153
// O
$symbol_O=24
WD draw_base_addr + 69, 105
WD draw_base_addr + 70, 153
WD draw_base_addr + 71, 150
// C
$symbol_C=25
WD draw_base_addr + 72, 105
WD draw_base_addr + 73, 136
WD draw_base_addr + 74, 150
// E
$symbol_E=26
WD draw_base_addr + 75, 248
WD draw_base_addr + 76, 142
WD draw_base_addr + 77, 134
// R
$symbol_R=27
WD draw_base_addr + 78, 233
WD draw_base_addr + 79, 158
WD draw_base_addr + 80, 153
// !
$symbol_!=28
WD draw_base_addr + 81, 34
WD draw_base_addr + 82, 34
WD draw_base_addr + 83, 2
// -> [0]
$symbol_->0=29
WD draw_base_addr + 84, 52
WD draw_base_addr + 85, 136
WD draw_base_addr + 86, 67
// -> [1]
$symbol_->1=30
WD draw_base_addr + 87, 149
WD draw_base_addr + 88, 63
WD draw_base_addr + 89, 12

// AND logic
$draw_and_logic_addr=150
WD draw_and_logic_addr, 128
WD draw_and_logic_addr + 1, 64
WD draw_and_logic_addr + 2, 32
WD draw_and_logic_addr + 3, 16
WD draw_and_logic_addr + 4, 8
WD draw_and_logic_addr + 5, 4
WD draw_and_logic_addr + 6, 2
WD draw_and_logic_addr + 7, 1
&init_draw_done:
RTN