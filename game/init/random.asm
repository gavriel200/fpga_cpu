$random_init.r.check_raw=R0
$random_init.r.max=RNDMAX
$random_init.r.min=RNDMIN
$random_init.r.write_enable=RNDWE
$random_init.r.raw=RNDRAW
$random_init.r.seed=RNDSEED
$random_init.v.seed=10

$random_init.v.cards_len=52

&init_card_select:
LDR random_init.r.check_raw, 0
COM random_init.r.check_raw, random_init.r.raw
JNZ @seed_already_set
LDR random_init.r.seed, random_init.v.seed
LDR random_init.r.write_enable, 1
LDR random_init.r.write_enable, 0

&seed_already_set:
LDR random_init.r.max, random_init.v.cards_len
LDR random_init.r.min, 1
// need to have min 1 because random will never be 0
// then just do -1 from the value of random to get index
&init_card_select_done:
RTN
