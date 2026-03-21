&sleep:
LDR R0, 1
// load timer ms
// 1000 - 00000011 11101000
LDR RTM0, 0xe8
LDR RTM1, 0x03

LDR RTMS, 1
LDR RTMS, 0

&check_timer_done:
COM R0, RTMD
JNZ @check_timer_done

&sleep_done:
RTN