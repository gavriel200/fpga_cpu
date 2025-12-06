
NOP
LDR R0, 31
LDR R1, 1
// load timer ms
// 1000 - 00000011 11101000
LDR RTM0, 0xe8
LDR RTM1, 0x03

&start:
INC RLD
LDR RTMS, 1
LDR RTMS, 0
LDR RJ, @check_timer_done
&check_timer_done:
COM R1, RTMD
// jump to check
JMI NZ
// timer done
JMR @start
