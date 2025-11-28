# simple loop the increments untill the R0 value is equal R1
NOP
LDR R0, 5
LDR R1, 10
LDR RJ, @test
&test:
INC R0
COM R0, R1
JMI NZ
NOP
NOP
NOP
