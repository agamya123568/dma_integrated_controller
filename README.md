# Simple DMA Controller (AMD 2940–Inspired)

This repository contains a simple, educational DMA controller written in Verilog,
inspired by the architecture of classic DMA controllers such as the AMD 2940.

---

## Overview
The design focuses on:
- Instruction-driven control
- Separate word and address counters
- Explicit commit-based handshaking
- Clean, synchronous DONE generation
- Modular, readable RTL suitable for learning and simulation

---

## Design Philosophy
This DMA controller avoids a centralized finite state machine and instead
uses explicit enable signals, counters, and handshaking to mirror the structure
of classic DMA hardware. This approach makes timing behavior easier to reason
about and debug in simulation.

---

## High-Level Architecture
The DMA controller is composed of the following major blocks:
- Instruction Decoder
- Control Register
- Address Counter
- Word Counter
- FIFO Interface (source / destination)
- DONE Logic
- Top-Level Integration (`dma_top`)

---

## Module Descriptions

### 1. `dma_top`
Top-level module that instantiates and connects all DMA submodules.
It does not generate control signals itself; it only wires modules together.

**Key signals**
- `instr`, `data_in` : configuration interface  
- `commit`          : transfer handshake  
- `done`            : transfer completion indicator  

---

### 2. `instr_decoder`
Decodes incoming instructions and generates control enables such as:
- `en_a` : address counter enable  
- `en_w` : word counter enable  
- `load_word`, `load_addr` : configuration loads  

---

### 3. `word_counter`
Maintains the remaining transfer count.
- Decrements on `(en_w && commit)`
- Exposes terminal count information to DONE logic

---

### 4. `address_counter`
Maintains the current transfer address.
- Updates on `(en_a && commit)`
- Supports increment/decrement modes

---

### 5. `done_logic`
Generates a synchronous DONE pulse when the final word transfer completes.
DONE is asserted based on terminal count conditions and handshake completion.

---

### 6. FIFO Interface Modules
Source and destination FIFO logic providing backpressure and flow control.

---

## DONE Signal Semantics
`DONE` is a registered, synchronous pulse indicating completion of the DMA transfer.

**Behavior**
- Word counter decrements to zero
- `DONE` asserts **one clock cycle after** the final transfer completes

This mirrors real DMA designs where DONE is a post-completion status signal.

---

## Timing Behavior
- All state updates occur on the rising edge of the clock
- Handshaking is performed using a `commit` signal
- No combinational feedback paths exist between counters and control logic

---

## Simulation
A self-checking testbench (`tb_dma_top`) is provided.  
Waveforms can be viewed using GTKWave or the Vivado simulator.

**Recommended signals to observe**
- `instr`
- `en_w`, `en_a`
- `commit`
- `word_count`
- `address`
- `done`

---

## Repository Structure

├── rtl/
│   ├── dma_top.v
│   ├── instr_decoder.v
│   ├── word_counter.v
│   ├── address_counter.v
│   ├── done_logic.v
│   └── fifo_*.v
│
├── tb/
│   └── tb_dma_top.v
│
├── diagrams/
│   ├── block_diagram.png
│   ├── timing_diagram.png
│
└── README.md


### Block Diagram


flowchart LR
    instr[instr,data] --> dec[instr_decoder]
    dec --> ctrl[control_reg]

    dec -->|en_a| addr[address_counter]
    dec -->|en_w| wc[word_counter]

    addr -->|address| src[src_fifo]
    src -->|data| dst[dst_fifo]

    wc -->|WCI| done[done_logic]
    dec -->|en_w| done
    commit --> addr
    commit --> wc
    commit --> done

---
### Timing Diagram
1. The clock (clk) runs continuously while the reset (rst) is asserted initially to initialize all control and counter registers.
2. After reset is deasserted, instruction inputs (instr[2:0]) along with data_in[7:0] are applied to configure the DMA controller.
3. The decoded instruction generates the load_w signal, which loads the initial value into the word counter.
4. The commit signal is asserted to indicate the start of the DMA transfer operation.
5. 5. While commit is active, the write enable signal (en_w) is asserted, causing the word counter to decrement on each clock cycle until it reaches zero, with WCI indicating an active transfer.

6. Once the word counter reaches zero, the done signal is asserted to indicate successful completion of the DMA transfer, and the controller returns to an idle state.

   <img width="1064" height="374" alt="timing_diagram" src="https://github.com/user-attachments/assets/9cf4b3b1-31b5-40e4-a6d8-538ec7ba02d4" />


## DONE Timing
Current behavior:
- Counters decrement synchronously to zero
- DONE asserts one clock cycle after the final transfer completes

## Future Improvements
- Burst transfers
- Interrupt generation
- Bus arbitration
- Parameterized data width



  

