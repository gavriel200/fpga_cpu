NOP

CAL @init_suits
CAL @init_cards
CAL @clean_screen


WD p_symbol_addr, 59+3
WD p_x_axis_addr, 5
WD p_y_axis_addr, 5

CAL @draw_symbol
JMP @done

import game/cards.asm
import game/screen.asm
import game/draw.asm

&done: