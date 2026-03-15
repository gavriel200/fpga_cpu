// init the random
// try to get index
// if taken try again
// if found none take set to taken and push

$r_random_max=RNDMAX
$r_random_min=RNDMIN
$r_random_enable=RNDWE
$r_random_value=RNDRANGE

&init_card_select:
LDR r_random_max, cards_len
LDR r_random_min, 1
LDR r_random_enable, 1
// need to have min 1 because random will never be 0
// then just do -1 from the value of random to get index
RTN

&get_random_card:
$r_random_card_index=R0
$r_random_card_value=R1
$r_check_taken_card=R2

LDR r_check_taken_card, taken

LD r_random_card_index, r_random_value
DEC r_random_card_index

RRR r_random_card_value, r_random_card_index

AND r_check_taken_card, r_random_card_value
JNZ @get_random_card

PSH r_random_card_value
RTN