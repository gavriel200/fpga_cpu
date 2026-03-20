NOP

$state_addr=189
$e_state_init=0
$e_state_player_turn=1
$e_state_hit=2
$e_state_dealer_hit=3
$e_state_player_win=4
$e_state_dealer_win=5
$e_state_draw=6

WD state_addr, e_state_init

&game_loop:
CAL @sleep
$game.r.current_state=R0
$game.r.com=R1

RR game.r.current_state, state_addr

// init
LDR game.r.com, e_state_init
COM game.r.com, game.r.current_state
JZ @case_init

LDR game.r.com, e_state_player_turn
COM game.r.com, game.r.current_state
JZ @case_player_turn

LDR game.r.com, e_state_hit
COM game.r.com, game.r.current_state
JZ @case_hit

LDR game.r.com, e_state_dealer_hit
COM game.r.com, game.r.current_state
JZ @case_dealer_hit

LDR game.r.com, e_state_player_win
COM game.r.com, game.r.current_state
JZ @case_player_win

LDR game.r.com, e_state_dealer_win
COM game.r.com, game.r.current_state
JZ @case_dealer_win

LDR game.r.com, e_state_draw
COM game.r.com, game.r.current_state
JZ @case_draw


&case_init:
CAL @state_init
JMP @game_loop

&case_player_turn:
CAL @state_player_turn
JMP @game_loop

&case_hit:
CAL @state_hit
JMP @game_loop

&case_dealer_hit:
CAL @state_dealer_hit
JMP @game_loop

&case_player_win:
CAL @state_player_win
JMP @game_loop

&case_dealer_win:
CAL @state_dealer_win
JMP @game_loop

&case_draw:
CAL @state_draw
JMP @game_loop

JMP @done

import game/global_params.asm

import game/init/clean_ram.asm
import game/init/suits.asm
import game/init/cards.asm
import game/init/symbols.asm
import game/init/random.asm

import game/states/init.asm
import game/states/player_turn.asm
import game/states/hit.asm
import game/states/dealer_hit.asm
import game/states/player_win.asm
import game/states/dealer_win.asm
import game/states/draw.asm

import game/deal.asm
import game/draw_symbol.asm
import game/screen.asm
import game/sleep.asm

&done: