// loop over all the ram and set it to 0

$clean_ram.r.clean_ram_counter=R0
$clean_ram.v.clean_ram_counter=255
$clean_ram.r.clean_ram_com=R1

&clean_ram:

LDR clean_ram.r.clean_ram_com, 0
LDR clean_ram.r.clean_ram_counter, clean_ram.v.clean_ram_counter

&clean_ram_loop:
RWD clean_ram.r.clean_ram_counter, 0

DEC clean_ram.r.clean_ram_counter

COM clean_ram.r.clean_ram_counter, clean_ram.r.clean_ram_com
JNZ @clean_ram_loop

RWD clean_ram.r.clean_ram_counter, 0

&clean_ram_done:
RTN