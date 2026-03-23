// deal card to player

// check if more then 21
// go to dealer win

// check if 21
// go to dealer hit

// else go to player turn

&state_hit:
LDR R0, 0
PSH R0
CAL @deal

RR R1, player_value_addr

LDR R2, 21
COM R2, R1
JZ @player_exactly_21
JC @player_less_then_21
JNC @player_more_then_21

&player_less_then_21:
WD state_addr, e_state_player_turn
JMP @state_hit_done

&player_more_then_21:
WD state_addr, e_state_dealer_win
JMP @state_hit_done

&player_exactly_21:
WD state_addr, e_state_dealer_hit
JMP @state_hit_done

&state_hit_done:
RTN