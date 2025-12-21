NOP
// register to com
LDR R0, 1
// load timer ms
// 1000 - 00000011 11101000
LDR RTM0, 0xe8
LDR RTM1, 0x03
// enable timer interrupt
LDR RTIE, 1

&start:
INC RLD
// register for timer done
LDR R1,   0 
LDR RTMS, 1
LDR RTMS, 0
LDR RJ, @check_timer_done
&check_timer_done:
COM R1, R0
// jump to check
JMI NZ
// timer done
JMR @start

&handle_interrupt:
LDR R1, 1
LD  R2, RIS
CIS

[240]
NOP
NOP
JMR @handle_interrupt
NOP