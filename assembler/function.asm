NOP

LDR R0, 0
LDR R1, 5
CAL @increment_r0
CAL @increment_r0
CAL @increment_r0
CAL @increment_r0
CAL @increment_r0
JMR @done

&increment_r0:
INC R0
COM R0, R1
RTN

&done:
NOP