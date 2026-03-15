NOP

CAL @clean_ram
CAL @init_suits
CAL @init_cards
CAL @clean_screen
CAL @init_draw
CAL @init_card_select


WD p_symbol_addr, symbol_K
WD p_x_axis_addr, 5
WD p_y_axis_addr, 5
WD p_pixel_color_addr, color_red
CAL @draw_symbol

WD p_symbol_addr, symbol_J
WD p_x_axis_addr, 10
WD p_pixel_color_addr, color_red
CAL @draw_symbol

WD p_symbol_addr, symbol_Y
WD p_x_axis_addr, 15
WD p_pixel_color_addr, color_turkiz
CAL @draw_symbol


WD p_symbol_addr, symbol_->0
WD p_x_axis_addr, 1
WD p_y_axis_addr, 12
WD p_pixel_color_addr, color_green
CAL @draw_symbol


WD p_symbol_addr, symbol_->1
WD p_x_axis_addr, 5
WD p_y_axis_addr, 12
WD p_pixel_color_addr, color_green
CAL @draw_symbol

JMP @done

import game/clean_ram.asm
import game/cards.asm
import game/screen.asm
import game/draw.asm
import game/card_select.asm

&done: