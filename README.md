# Custom 8-bit CPU — Project README

A custom 8-bit CPU implemented in Verilog, synthesized on a **Tang Nano 9K FPGA**. Comes with a Python assembler, a pixel LCD display pipeline, and peripherals (buttons, timer, random, interrupts). The game (Blackjack) runs on top of it — see `README_game.md` for that.

---

## Architecture Overview

The CPU is a simple **single-cycle, non-pipelined** design. Each clock tick executes one instruction. RAM reads take two cycles (a stall is inserted automatically).

```
clk ──► ROM (PC counter) ──► Decoder ──► ALU / Registers / RAM / Stack
                                 │
                         Peripherals: Timer, Buttons, Random, LCD
```

### Components

**ROM** — Instruction memory. 1024 lines, each 22 bits wide (6-bit opcode + two 8-bit args). Loaded from `src/main.bin` at synthesis time. The PC increments every clock unless stalled or jumped. Interrupt jumps save the current PC and force execution to address `0x3E8` (line 1000).

**Decoder** — Combinational logic that reads the current instruction from ROM and drives all other modules. Every signal defaults to 0 at the start of each cycle — no latches.

**ALU** — 8-bit arithmetic and logic unit. Operations: add, subtract, increment, decrement, AND, OR, XOR, XNOR. Sets a zero flag (`Z`) and a carry/borrow flag (`C`) after each operation.

**Registers** — 40 registers, each 8-bit. Addresses 0–7 are general-purpose (`R0`–`R7`). Addresses 8–31 are mapped to peripherals (read/write). Addresses 32–38 are read-only peripheral outputs.

**RAM** — 256 bytes of block RAM. Addressed by an 8-bit value. Reads take two clock cycles (the decoder stalls the PC for one cycle on a read instruction).

**Stack** — 32-deep × 8-bit value stack. Used with `PSH` / `POP`. Separate from the call stack.

**PC Stack** — 32-deep call stack. Used by `CAL` / `RTN`. On `CAL`, saves the return address **and** the current state of R0–R7 (first 64 bits of registers). On `RTN`, restores both.

**Flags** — Two 1-bit flags: `Z` (zero) and `C` (carry). Updated by ALU instructions and `COM`. Read by conditional jumps.

**Interrupt controller** — Aggregates interrupt signals from the timer and three buttons. When an interrupt fires, the PC jumps to address 1000. The `CIS` instruction clears interrupt status and returns to the pre-interrupt PC.

**Timer** — Counts down milliseconds from a 16-bit value loaded into `RTM0` (low byte) and `RTM1` (high byte). Started by writing `1` then `0` to `RTMS`. The `RTMD` register reads `1` when done. Can fire an interrupt when `RTIE` is set.

**Button** — Each of the three buttons has debounce logic (~250ms hold required). Outputs a stable `1` when held. Can fire an interrupt when `RB1IE` / `RB2IE` / `RB3IE` is set.

**Random** — LFSR-based 8-bit random generator running every clock. Write a seed to `RNDSEED` and set `RNDWE=1` to seed it. Read `RNDRAW` for the raw value. Set `RNDMIN` and `RNDMAX` then read `RNDRANGE` for a value in `[min, max]`.

**Framebuffer + LCD** — 60×32 pixel grid, 4 bits per pixel (16 colours). The CPU writes pixels via registers `RFBX`, `RFBY`, `RFBD` (data), `RFBE` (enable). The LCD driver (SPI, 1.14" 240×135 display) continuously scans the framebuffer and pushes it to the screen. Writing `1` to `RLCDU` triggers an update; `RLCDR` reads `1` when the LCD is ready.

---

## Instruction Set

Every instruction is 22 bits: `[21:16]` opcode, `[15:8]` arg_a, `[7:0]` arg_b.

### Data

| Instruction | Syntax | Description |
|---|---|---|
| `NOP` | `NOP` | No operation |
| `LDR` | `LDR R0, 42` | Load immediate value into register |
| `LD` | `LD R0, R1` | Copy register to register |
| `CLR` | `CLR R0` | Set register to 0x00 |
| `FIL` | `FIL R0` | Set register to 0xFF |

```asm
LDR R0, 10       // R0 = 10
LDR R1, 5        // R1 = 5
LD  R2, R0       // R2 = R0 = 10
CLR R3           // R3 = 0
FIL R4           // R4 = 255
```

### Arithmetic & Logic

All of these update the `Z` and `C` flags. Results are stored back in arg_a.

| Instruction | Syntax | Description |
|---|---|---|
| `ADD` | `ADD R0, R1` | R0 = R0 + R1 |
| `SUB` | `SUB R0, R1` | R0 = R0 - R1 |
| `INC` | `INC R0` | R0 = R0 + 1 |
| `DEC` | `DEC R0` | R0 = R0 - 1 |
| `AND` | `AND R0, R1` | R0 = R0 & R1 |
| `OR`  | `OR R0, R1` | R0 = R0 \| R1 |
| `XOR` | `XOR R0, R1` | R0 = R0 ^ R1 |
| `XNR` | `XNR R0, R1` | R0 = R0 ~^ R1 |
| `COM` | `COM R0, R1` | Compare R0 and R1. Sets flags, does NOT write result |

```asm
LDR R0, 200
LDR R1, 100
ADD R0, R1       // R0 = 44 (overflow), C flag set
SUB R0, R1       // R0 = 200 - 100 = 100
INC R0           // R0 = 101
DEC R0           // R0 = 100

COM R0, R1       // compare 100 vs 100 → Z=1, C=0
JZ  @equal       // jumps because Z=1
```

**Carry flag on subtraction** is the NOT of the borrow bit — so `C=1` means no borrow (result is non-negative), `C=0` means borrow (underflow). After `COM R0, R1`:
- `Z=1` → R0 == R1
- `C=1, Z=0` → R0 > R1
- `C=0` → R0 < R1

### Stack

| Instruction | Syntax | Description |
|---|---|---|
| `PSH` | `PSH R0` | Push R0 onto the value stack |
| `POP` | `POP R0` | Pop top of value stack into R0 |

The value stack is 32 entries deep. It is separate from the call stack. Used for passing arguments to subroutines.

```asm
LDR R0, 42
PSH R0          // stack: [42]
LDR R0, 7
PSH R0          // stack: [42, 7]
POP R1          // R1 = 7, stack: [42]
POP R2          // R2 = 42, stack: []
```

### Jumps & Calls

Jump addresses are 11-bit (max address 0x3FF = 1023). Use labels (`&label:` to define, `@label` to reference) — the assembler resolves them.

| Instruction | Syntax | Description |
|---|---|---|
| `JMP` | `JMP @label` | Unconditional jump |
| `JZ` | `JZ @label` | Jump if Z=1 |
| `JNZ` | `JNZ @label` | Jump if Z=0 |
| `JC` | `JC @label` | Jump if C=1 |
| `JNC` | `JNC @label` | Jump if C=0 |
| `CAL` | `CAL @label` | Call subroutine (saves PC + R0–R7) |
| `RTN` | `RTN` | Return from subroutine (restores PC + R0–R7) |

```asm
LDR R0, 5
LDR R1, 5
COM R0, R1
JZ  @they_are_equal     // jump taken

LDR R0, 10
LDR R1, 3
COM R0, R1
JC  @r0_greater         // jump taken (10 > 3, C=1)
JNC @r1_greater         // not taken

&they_are_equal:
NOP

&r0_greater:
NOP
```

Calling a subroutine saves the return address and R0–R7 so the caller's registers are safe:

```asm
LDR R0, 42
CAL @my_func    // saves return address and R0–R7
// R0 is still 42 here after return

&my_func:
LDR R0, 99     // this change is local to the call
RTN            // restores R0 = 42 on return
```

### RAM

The RAM is 256 bytes. Reads require a stall (they take 2 cycles automatically).

| Instruction | Syntax | Description |
|---|---|---|
| `WD` | `WD addr, value` | Write immediate value to fixed address |
| `WR` | `WR addr, Rx` | Write register value to fixed address |
| `RR` | `RR Rx, addr` | Read from fixed address into register |
| `RWD` | `RWD Rx, value` | Write immediate value to address stored in Rx |
| `RWR` | `RWR Rx, Ry` | Write Ry to address stored in Rx |
| `RRR` | `RRR Rx, Ry` | Read from address stored in Ry into Rx |

```asm
// fixed address operations
WD 10, 255       // RAM[10] = 255
WD 11, 100       // RAM[11] = 100
RR R0, 10        // R0 = RAM[10] = 255
RR R1, 11        // R1 = RAM[11] = 100

// indirect (register holds the address)
LDR R2, 50       // R2 = 50 (used as address)
RWD R2, 42       // RAM[50] = 42
RRR R3, R2       // R3 = RAM[50] = 42

LDR R4, 7
RWR R2, R4       // RAM[50] = 7
```

### Interrupts

| Instruction | Syntax | Description |
|---|---|---|
| `CIS` | `CIS` | Clear interrupt status and return to pre-interrupt PC |

When an interrupt fires, the CPU jumps to address 1000 (0x3E8). The interrupt handler must call `CIS` to clear the status and resume. The `RIS` register contains a bitmask: bit 0 = timer, bit 1 = button 1, bit 2 = button 2, bit 3 = button 3.

```asm
// enable button 1 interrupt
LDR RB1IE, 1

// interrupt handler lives at address 1000:
[1000]
LD  R0, RIS      // read which interrupt fired
CIS              // clear and return
```

---

## Registers Reference

### General Purpose (R/W)
`R0`–`R7` — 8 general-purpose 8-bit registers. Saved/restored across `CAL`/`RTN`.

### Peripheral (R/W, addresses 10–27)
| Name | Addr | Description |
|---|---|---|
| `RNDMIN` | 10 | Random range minimum |
| `RNDMAX` | 11 | Random range maximum |
| `RNDSEED` | 12 | Seed value to write |
| `RNDWE` | 13 | Write `1` to apply seed |
| `RLD` | 14 | LED outputs (bits 0–4) |
| `RTM0` | 15 | Timer milliseconds low byte |
| `RTM1` | 16 | Timer milliseconds high byte |
| `RTMS` | 17 | Write `1` then `0` to start timer |
| `RTIE` | 18 | Timer interrupt enable |
| `RIS` | 19 | Interrupt status (bitmask) |
| `RFBX` | 20 | Framebuffer X coordinate |
| `RFBY` | 21 | Framebuffer Y coordinate |
| `RFBD` | 22 | Framebuffer pixel data (4-bit colour) |
| `RFBE` | 23 | Write `1` then `0` to commit pixel |
| `RLCDU` | 24 | Write `1` to trigger LCD update |
| `RB1IE` | 25 | Button 1 interrupt enable |
| `RB2IE` | 26 | Button 2 interrupt enable |
| `RB3IE` | 27 | Button 3 interrupt enable |

### Peripheral (Read Only, addresses 32–38)
| Name | Addr | Description |
|---|---|---|
| `RNDRAW` | 32 | Raw LFSR random value |
| `RNDRANGE` | 33 | Random value in [RNDMIN, RNDMAX] |
| `RTMD` | 34 | Timer done flag (`1` = done) |
| `RLCDR` | 35 | LCD ready flag |
| `RBO1` | 36 | Button 1 state (debounced) |
| `RBO2` | 37 | Button 2 state |
| `RBO3` | 38 | Button 3 state |

---

## Assembler

The assembler is a Python script. Run it from the project root:

```bash
python -m assembler path/to/program.asm
```

It writes `src/main.bin` (binary for synthesis) and `assembler/debug_file_asm` (human-readable annotated listing).

### Labels

Define a label with `&name:`. Jump to it with `@name`. Labels must be unique.

```asm
&loop:
INC R0
LDR R1, 100
COM R0, R1
JNZ @loop
```

### Parameters (`$`)

Parameters are text substitutions resolved before assembly. They make code readable without any runtime cost.

```asm
$score_addr=50
$max_score=21

WD score_addr, 0      // assembles as: WD 50, 0
LDR R0, max_score     // assembles as: LDR R0, 21
```

### Fixed Memory Placement

Use `[address]` on its own line to force the next instruction to land at that address. The address must be equal to or greater than the current PC.

```asm
// interrupt handler must live at address 1000
[1000]
LD  R0, RIS
CIS
```

### Imports

Use `import path/to/file.asm` to inline another file. The path is relative to the working directory. Imported files can define their own labels and parameters.

```asm
import game/sleep.asm
import game/draw_symbol.asm

CAL @sleep
CAL @draw_symbol
```

### Numbers

The assembler accepts decimal (`42`), hex (`0x2A`), and simple expressions (`6 * 8`).

---

## Drawing to the LCD

The framebuffer is 60 columns × 32 rows. Each pixel is 4 bits (16 colours). To draw a pixel:

```asm
LDR RFBX, 10     // x = 10
LDR RFBY, 5      // y = 5
LDR RFBD, 3      // colour index 3
LDR RFBE, 1      // commit
LDR RFBE, 0      // release enable

LDR RLCDU, 1     // trigger LCD push
```

Wait for the LCD to finish before drawing again:

```asm
&wait_lcd:
LD  R0, RLCDR    // read ready
LDR R1, 1
COM R0, R1
JNZ @wait_lcd    // loop until ready
```

---

## Timer Example

Sleep for 500ms:

```asm
LDR RTM0, 0xF4   // 500 = 0x01F4, low byte = 0xF4
LDR RTM1, 0x01   // high byte = 0x01
LDR RTMS, 1      // start
LDR RTMS, 0

&wait:
LD  R0, RTMD
LDR R1, 1
COM R0, R1
JNZ @wait        // loop until done
```

---

## Random Example

Get a random card index from 1–52:

```asm
LDR RNDMIN, 1
LDR RNDMAX, 52
LD  R0, RNDRANGE   // R0 = random number in [1, 52]
```

Seed the generator (optional):

```asm
LDR RNDSEED, 0xAB
LDR RNDWE, 1       // apply seed
LDR RNDWE, 0
```