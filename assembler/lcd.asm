NOP

// load timer value
// load timer ms
// 1000 - 00000011 11101000
LDR RTM0, 0xe8
LDR RTM1, 0x03

// wait for init lcd
CAL @wait_for_lcd_ready

// clean frame buffer
CAL @clean_frame_buffer

// init frame buffer
LDR RFBX, 0
LDR RFBY, 0
LDR RFBD, 7
LDR RFBE, 1
LDR RFBE, 0

&update_pixel:
CAL @wait_1_sec
LDR RLCDU, 1
LDR RLCDU, 0
CAL @wait_for_lcd_ready
INC RFBX
INC RFBY
LDR RFBE, 1
LDR RFBE, 0
JMR @update_pixel

&wait_1_sec:
LDR R0, 1
LDR RTMS, 1
LDR RTMS, 0
LDR RJ, @check_timer_done
&check_timer_done:
COM R0, RTMD
JMI NZ
RTN

&wait_for_lcd_ready:
LDR R0, 1
LDR RJ, @check_lcd_ready
&check_lcd_ready:
COM R0, RLCDR
JMI NZ
RTN

&clean_frame_buffer:
LDR RFBD, 0
CAL @loop_y
RTN

&loop_y:
LDR RFBY, 0
LDR R0, 32
&y_target:
CAL @loop_x
LDR RJ, @y_target
LDR RFBE, 1
LDR RFBE, 0
INC RFBY
COM RFBY, R0
JMI NZ
RTN

&loop_x:
LDR RFBX, 0
LDR R1, 60
&x_target:
LDR RJ, @x_target
LDR RFBE, 1
LDR RFBE, 0
INC RFBX
COM RFBX, R1
JMI NZ
RTN
