NOP
LDR RB1IE, 1
&while_true:
JMP @while_true

&handle_button_interrupt:
LDR R0, 1
COM R0, RLD
JZ @turn_off
JNZ @turn_on

&turn_on:
LDR RLD, 1
CIS

&turn_off:
LDR RLD, 0
CIS

[0x3E8]
JMP @handle_button_interrupt