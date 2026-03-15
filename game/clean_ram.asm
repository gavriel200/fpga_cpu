// loop over all the ram and set it to 0
&clean_ram:
$r_clean_ram_counter=R0
$v_clean_ram_counter=255
$r_clean_ram_com=R1

LDR r_clean_ram_com, 0
LDR r_clean_ram_counter, v_clean_ram_counter

&clean_ram_loop:
RWD r_clean_ram_counter, 0

DEC r_clean_ram_counter

COM r_clean_ram_counter, r_clean_ram_com
JNZ @clean_ram_loop

RWD r_clean_ram_counter, 0

&clean_ram_done:
RTN