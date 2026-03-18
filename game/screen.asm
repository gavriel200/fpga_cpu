// loop over screen and set all pixels white

$clean_screen.r.y_axis=RFBY
$clean_screen.r.x_axis=RFBX
$clean_screen.r.pixel_color=RFBD
$clean_screen.r.framebuffer_e=RFBE

$clean_screen.v.y_axis=0xff
$clean_screen.v.x_axis=60

$clean_screen.r.x_axis_com=R0
$clean_screen.r.y_axis_com=R1

&clean_screen:

LDR clean_screen.r.x_axis_com,  0
LDR clean_screen.r.y_axis_com,  32
LDR clean_screen.r.pixel_color, color_white
LDR clean_screen.r.y_axis,      clean_screen.v.y_axis

&next_row:
INC clean_screen.r.y_axis
COM clean_screen.r.y_axis_com, clean_screen.r.y_axis
JZ @clean_screen_done

LDR clean_screen.r.x_axis, clean_screen.v.x_axis

&next_col:
DEC clean_screen.r.x_axis

// update pixel
LDR clean_screen.r.framebuffer_e, 1
LDR clean_screen.r.framebuffer_e, 0

JZ @next_row
JMP @next_col

&clean_screen_done:
CAL @update_screen
RTN

// ===============================
// ===============================

// update screen using the frame buffer

$update_screen.r.lcd_update_e=RLCDU

&update_screen:
LDR update_screen.r.lcd_update_e, 1
LDR update_screen.r.lcd_update_e, 0
RTN
