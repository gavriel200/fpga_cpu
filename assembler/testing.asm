NOP
LDR R0, 6
LDR R1, 5
LDR R2, 6
LDR R3, 7


// 6 - 5 = 1
// C = 1, Z = 0
COM R0, R1
// 6 - 6 = 0
// C = 1, Z = 1
COM R0, R2
// 6 - 7 = -1 
// C = 0, Z = 0
COM R0, R3
