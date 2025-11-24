cpu project:

1. create the essembly code
    - create list of instructions to support
    - write script to compile the "essembly" into a bit stream into a verilog file, have the verilog file be in the `.gitignore` and be generated before compiling and all
    - should be able in the "essembly" to place instruciton in specific places + function and routiens should be handeled by the script 
2. build the CPU
    - think of all the modules needed connect all the relevant parts.
        - ALU
        - timer
        - ram
        - rom
        - interrupts
        - special registers
        - and more... (have a full list and plan all)
    - connect IO such as some pins and some leds to the memory

how does the insturcion look:

-------------------------------------------------------
| 8 bit insturcion | 8 bit arg1 | 8 bit optional arg2 |
-------------------------------------------------------

# list of instructions:

## memory

- copy value from one register to another.

- write raw value to regsiter.

- load from memory address to register.

- write to memory address from register.

| now for read and write to memory there are 2 ways using another register as pointer (special register for that)
| or using manual address. so maybe have both options.

- maybe speacial read write to IO to from register.

- push/pop on/from the stack from/to a register.

- push to stack specific value

- set/unset specific bits in a register:

| R16, 0b00001111
| R16, (1<<4)   ; Set bit 4 → R16 = 00011111

- clear register

- set register (all bits to 1)

- NOP (no operation)

## bitwise

- AND / OR / XOR and save into -> AND ax, bx -> ax = ax AND BX

- shift left/right

- rotate left/right (through carry)? maybe not need for now


## arithmetic

### here we also get to the flags

Z (Zero): Set if result == 0
C (Carry): Set if overflow beyond MSB
N (Negative): Set if MSB of result = 1
V (Overflow): Set if signed overflow
S (Sign): S = N ⊕ V

- add -> add ax, bx -> ax = ax + bx

- add with carry

- sub -> sub ax, bx -> ax = ax - bx

- sub with carry

- increment (+= 1)

- dncrement (-= 1)

- compair (no storing result just setting flags) compair just does a - b and sets flags with no save

- multiply -> saves into another registers (since can be more then 8 bits result)

- divide (same)


## logic

- jump to address in rom
| here maybe the compiler needs to have some logic with function names to jump to that specific place in rom
| logic with jumping to subroutine saving the counter location and returning.

- jump if condition using the flags.

- call (function) push to stack the current instruction pointer then jumps somewhere then have insturtion to come back.

- return - return to where the call was from.

- return from interrupts - restore state

- clean interrupt


# memory plan

for the stack lets have the first 255 bits or the start of them be reserved for any special logic for exmaple
the registers for the 

stack is on the sram itself but its pointer is a speacial register


sram:
10 bit addresses 
[0x000 - 0x3ff] 1024 bytes - full memory
[0x000 - 0x07f] 128 bit long stack
[0x07f - 0x0bf] 64 IO registers - connect to pins/leds/buttons etc
[0x0bf - 0x0ff] 64 direct memory (can be written directly using address)
[0x0ff - 0x3ff] 768 indirect memory (uses the address registers 2 8-bit registers)

special registers:

- general purpose 8 registers [rw]
- status [ro]
- PC (pointer to instructions) [wo] (jump instrutions)
- stack pointer [rw]
- 2 registers used for indirect memory write [rw]
- interrupt status [rw] (read the status that is set by insterrupt + clear)
- interrupt mask which interrupts are enabled disabled
- what if multiple interrupts happen needs a mask of what interrupt happened + ack mechanisem and clean.

- registers to save state in case of interrupt to go back to (needs to check what exactly is saved only the PC or all the resiters)

# ROM

make larger
**Recommendation**: Use at least 2KB ROM (11-bit addressing) or 4KB (12-bit). 250 bytes is extremely limiting.


lets start with 255 instructions
[0x00 - 0xf9]
[0xfa - 0xff] interrupt table.

- start of program [0x00]
- interrupt table:
    - [0xfa] - software intrrupt using instruction INT\
    - [0xfb] - invalid instruction - div by 0 or unknonw instruction
    - [0xfc] - clock interrupt
    - [0xfd - 0xff] [3] - IO interrupts

