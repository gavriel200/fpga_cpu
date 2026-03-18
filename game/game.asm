NOP

CAL @clean_ram
CAL @clean_screen

CAL @init_suits
CAL @init_cards

CAL @init_card_select

CAL @init_draw

&start:
LDR R0, 0
PSH R0
CAL @deal

LDR R0, 0
PSH R0
CAL @deal

LDR R0, 1
PSH R0
CAL @deal

LDR R0, 1
PSH R0
CAL @deal


JMP @done

import game/global_params.asm

import game/init/clean_ram.asm
import game/init/suits.asm
import game/init/cards.asm
import game/init/symbols.asm
import game/init/random.asm


import game/deal.asm
import game/draw_symbol.asm
import game/screen.asm

&done: