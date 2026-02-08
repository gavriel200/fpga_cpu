Below is a **single, consolidated, deep-technical reference document** for the **ST7789-based 1.14″ (135×240) SPI TFT LCD module**, written from a **low-level, pin-centric, no-code perspective**.

This is meant to be something you could:

* Implement in **bare metal FPGA / CPU**
* Debug with a **logic analyzer**
* Use to **write your own driver from scratch**
* Understand **what libraries hide**

I will be **thorough**, structured, and explicit.

---

# ST7789 1.14″ TFT LCD

## Complete Low-Level Command, Init, and Pixel Reference

*(SPI, MSB-first, RGB565, 135×240)*

---

## 1. Absolute Fundamentals (Lock These In)

### 1.1 Physical Reality

* The LCD module contains:

  * **TFT glass panel**
  * **ST7789 display controller**
  * **Backlight LEDs**
* You never drive pixels directly.
* You **command the ST7789**, which:

  * Stores pixel data in internal RAM
  * Scans the panel continuously

---

## 2. Electrical & Signaling Model

### 2.1 SPI Interface (4-Wire)

| Signal     | Direction | Meaning                  |
| ---------- | --------- | ------------------------ |
| CS         | MCU → LCD | Chip select (active LOW) |
| SCL / SCK  | MCU → LCD | SPI clock                |
| SDA / MOSI | MCU → LCD | Serial data              |
| DC (D/CX)  | MCU → LCD | Command (0) / Data (1)   |
| RES        | MCU → LCD | Hardware reset           |
| BL         | MCU → LCD | Backlight enable         |
| VCC        | Power     | 3.3 V                    |
| GND        | Power     | Ground                   |

---

### 2.2 SPI Rules (Non-Negotiable)

* **Clock mode**: SPI Mode 0

  * Clock idle LOW
  * Sample on rising edge
* **Bit order**: **MSB FIRST**
* **Applies to**:

  * Commands
  * Data
  * Pixel bytes
* **DC pin** affects meaning, **not format**

---

## 3. Command vs Data (Critical Concept)

| DC Pin | Byte Meaning |
| ------ | ------------ |
| LOW    | Command byte |
| HIGH   | Data byte(s) |

The ST7789:

* Has **no framing**
* No packet structure
* Only reacts to:

  * DC state
  * Clock edges
  * Byte values

---

## 4. Pixel & Memory Model

### 4.1 Pixel Format (RGB565)

Each pixel = **16 bits**:

```
[15:11] Red   (5 bits)
[10:5]  Green (6 bits)
[4:0]   Blue  (5 bits)
```

Example:

* Red = 31
* Green = 0
* Blue = 0

→ `11111 000000 00000` → `0xF800`

---

### 4.2 Internal RAM (GRAM)

* Pixel RAM exists **inside ST7789**
* Addressed via:

  * Column address
  * Row address
* Auto-incremented during writes
* RAM is **volatile**

---

## 5. Command Set — Full Deep Dive

Below are **all relevant commands**, grouped by function.

---

## 6. System & Power Commands

### 6.1 `0x01` — Software Reset (SWRESET)

**Purpose**

* Resets controller logic
* Clears registers
* Enters sleep mode

**SPI**

```
DC=0 → 0x01
```

**Data**

* None

**Delay**

* ≥ 120 ms required

---

### 6.2 `0x11` — Sleep Out (SLPOUT)

**Purpose**

* Enables internal oscillator
* Powers internal blocks

**SPI**

```
DC=0 → 0x11
```

**Delay**

* ≥ 120 ms

**State after**

* Display OFF
* Ready for configuration

---

### 6.3 `0x10` — Sleep In (SLPIN)

**Purpose**

* Low-power mode
* RAM contents preserved

---

## 7. Display Control

### 7.1 `0x28` — Display OFF

Turns off scan output but keeps RAM.

---

### 7.2 `0x29` — Display ON

Enables pixel scanning to panel.

**Must come AFTER**

* SLPOUT
* COLMOD
* MADCTL

---

## 8. Pixel Format & Orientation

### 8.1 `0x3A` — COLMOD (Pixel Format)

**SPI**

```
DC=0 → 0x3A
DC=1 → format
```

**Formats**

| Value  | Meaning           |
| ------ | ----------------- |
| `0x55` | RGB565 (16-bit) ✅ |
| `0x66` | RGB666            |
| `0x77` | RGB888            |

---

### 8.2 `0x36` — MADCTL (Memory Access Control)

Controls:

* Rotation
* Mirroring
* RGB/BGR order

**Bit layout**

```
7 MY  (row order)
6 MX  (column order)
5 MV  (row/column swap)
4 ML  (vertical refresh)
3 RGB (0=RGB, 1=BGR)
2 MH  (horizontal refresh)
```

**Common values**

| Value   | Effect             |
| ------- | ------------------ |
| `0x00`  | Portrait           |
| `0x60`  | Landscape          |
| `0xC0`  | Portrait inverted  |
| `0xA0`  | Landscape inverted |
| `+0x08` | Switch RGB↔BGR     |

---

## 9. Address Windowing (Critical)

### 9.1 `0x2A` — CASET (Column Address Set)

Defines **X range**.

**SPI**

```
DC=0 → 0x2A
DC=1 → Xstart[15:8]
DC=1 → Xstart[7:0]
DC=1 → Xend[15:8]
DC=1 → Xend[7:0]
```

**Example (240 wide)**

```
Start: 0x0000
End:   0x00EF
```

---

### 9.2 `0x2B` — RASET (Row Address Set)

Defines **Y range**.

**Example (135 high)**

```
Start: 0x0000
End:   0x0086
```

---

## 10. RAM Access

### 10.1 `0x2C` — RAMWR (Memory Write)

**SPI**

```
DC=0 → 0x2C
DC=1 → pixel stream
```

**Rules**

* Pixel bytes MSB-first
* High byte then low byte
* Continues until:

  * Window filled OR
  * CS goes HIGH

---

## 11. Power, Timing & Panel Control

These tune panel behavior and stability.

---

### 11.1 `0xB2` — Porch Control

Controls:

* Front porch
* Back porch
* Frame timing

**Data**

* 5 bytes

---

### 11.2 `0xB7` — Gate Control

Adjusts scan voltage timing.

---

### 11.3 `0xBB` — VCOM

Controls common electrode voltage.

---

### 11.4 `0xC0`–`0xC6` — Power Control

Regulates:

* Internal DC-DC
* Voltage levels

---

## 12. Gamma Control (Color Accuracy)

### 12.1 `0xE0` — Positive Gamma

### 12.2 `0xE1` — Negative Gamma

**Each**

* 14 data bytes
* Panel-specific tuning

Affects:

* Brightness curve
* Color saturation
* Black levels

---

## 13. Initialization Sequences (No Code)

---

### 13.1 Minimal Safe Init

```
RES: LOW → HIGH

0x01         (SWRESET)
(wait 120 ms)

0x11         (SLPOUT)
(wait 120 ms)

0x3A → 0x55  (RGB565)
0x36 → 0x00  (orientation)

0x29         (DISPON)
```

---

### 13.2 Typical 1.14″ IPS Init

```
SWRESET
SLPOUT

MADCTL → 0x70   (landscape + BGR)
COLMOD → 0x55

CASET → 0000 → 00EF
RASET → 0000 → 0086

DISPON
```

---

### 13.3 Full Manufacturer-Style Init

```
SWRESET
SLPOUT

PORCH CONTROL
GATE CONTROL
VCOM
LCM CONTROL
VDV/VRH
POWER CONTROL
FRAMERATE

GAMMA+
GAMMA-

MADCTL
COLMOD

DISPON
```

---

## 14. Common Pitfalls (Very Important)

### ⚠ Address Offsets

Many 1.14″ panels:

* Do NOT start at (0,0)
* Require X/Y offset (e.g. X=40)

---

### ⚠ RGB vs BGR

Wrong MADCTL bit → wrong colors.

---

### ⚠ CS Ends RAMWR

Raising CS **terminates pixel stream**.

---

### ⚠ Backlight ≠ Display ON

You can have:

* BL ON
* Display OFF
* RAM filled but invisible

---

## 15. Mental Model Summary

* **Commands configure hardware**
* **CASET/RASET define where**
* **RAMWR streams raw pixel bits**
* **DC defines meaning**
* **SPI defines timing**
* **ST7789 scans forever**

---

## 16. What This Enables You To Do

After understanding this:

* Write a **bare-metal driver**
* Implement an **FPGA framebuffer**
* Debug with **logic analyzer**
* Design your **own display controller**

---

If you want next:

* 📐 **Cycle-accurate SPI timing diagrams**
* 🧠 **Why 135×240 panels have hidden offsets**
* 🧩 **Internal scan engine explanation**
* 🖥️ **Building a framebuffer on FPGA**

Just tell me where to go next.


2. Three update models (from worst → best)
❌ Model 1 — “Always stream the whole screen”

Controller continuously:

Read framebuffer → scale → send entire frame

Problems

Wastes SPI bandwidth

Wastes power

CPU changes one pixel → whole screen resends

Harder to pause updates

When this is OK

Very simple demo

Tiny screens

You don’t care about efficiency

⚠️ Model 2 — CPU tells controller “refresh now”

Controller:

Idle by default

On command: push full framebuffer once

Pros

Simple

CPU-controlled timing

Cons

Still redraws everything

CPU must remember to refresh

Slower perceived UI

This is OK, but not optimal.