&clean_screen:
$r_y_axis=RFBY
$r_x_axis=RFBX

// on inc will loop over
$y_axis=0xff 
$x_axis=60

$r_x_axis_com=R0
LDR r_x_axis_com, 0

$r_y_axis_com=R1
LDR r_y_axis_com, 32

$r_pixel_color=RFBD
$pixel_color=0

$r_framebuffer_e=RFBE

$r_lcd_update_e=RLCDU

LDR r_pixel_color, pixel_color

LDR r_y_axis, y_axis

&next_row:
INC r_y_axis
COM r_y_axis_com, r_y_axis
JZ @clean_screen_done

LDR r_x_axis, x_axis

&next_col:
DEC r_x_axis

// update pixel
LDR r_framebuffer_e, 1
LDR r_framebuffer_e, 0

JZ @next_row
JMP @next_col

&clean_screen_done:
CAL @update_screen

&update_screen:
LDR r_lcd_update_e, 1
LDR r_lcd_update_e, 0
RTN
