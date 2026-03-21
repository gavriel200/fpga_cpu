// deal card to dealer

// if more then 21
// go to player win

// if 16 or less
// got to dealer hit

// if more then player
// go to dealer win

// if less then player
// go to player win

// go to draw

&state_dealer_hit:
LDR R0, 1
PSH R0
CAL @deal

RR R1, dealer_value_addr
RR R2, player_value_addr

LDR R3, 21
LDR R4, 16

COM R3, R1
JNC @dealer_more_then_21
COM R4, R1
JC @dealer_has_16_or_less
COM R1, R2
JZ @dealer_equal_player
JC @dealer_more_then_player
JNC @dealer_less_then_player

&dealer_more_then_21:
WD state_addr, e_state_player_win
JMP @state_dealer_hit_done

&dealer_has_16_or_less:
WD state_addr, e_state_dealer_hit
JMP @state_dealer_hit_done

&dealer_equal_player:
WD state_addr, e_state_draw
CAL @sleep
JMP @state_dealer_hit_done

&dealer_more_then_player:
WD state_addr, e_state_dealer_win
CAL @sleep
JMP @state_dealer_hit_done

&dealer_less_then_player:
WD state_addr, e_state_player_win
CAL @sleep
JMP @state_dealer_hit_done

&state_dealer_hit_done:
RTN