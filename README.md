# Dual Core MIPS32 Processor with Shared RAM and Memory Arbiter

This repository contains a Verilog implementation of a dual-core MIPS32 processor system. Both cores share a single RAM module, with a memory arbiter ensuring safe and efficient access. The design demonstrates multicore processor operation, shared memory management, and arbitration logic in hardware.


## Project Origin

**This project is an extension of my [Single Cycle MIPS32 Processor project](https://github.com/JayaKushal24/Dual-Core-MIPS32-Processor-with-Memory-Arbiter) on GitHub.**  
The dual-core design builds upon the original single-cycle MIPS32 core, adding a second core and a memory arbiter to enable safe shared memory access and true multicore operation.


## Features

- **Two MIPS32-compatible CPU cores:** Each core executes its own instruction stream.
- **Shared RAM:** Both cores access a single data memory.
- **Memory Arbiter:** Handles simultaneous memory requests, granting access to one core at a time using a round-robin/fairness scheme.
- **Stall Logic:** Each core stalls if its memory request is denied, ensuring correct program execution.
- **Testbench included:** Simulates and verifies multicore operation and memory sharing.
- **Simple, modular Verilog design:** Easy to extend or integrate into larger systems.


## Dual Core Architecture

![Dual Core MIPS32 Architecture](./Dual-core%20Architecture.png)

*Figure: Block diagram of the dual-core processor system with shared RAM and memory arbiter.*



## Architecture Overview


- **Cores:** `MIPS32_core0` and `MIPS32_core1` each fetch, decode, and execute instructions independently.
- **Instruction Memories:** Each core has its own instruction memory, preloaded with test instructions.
- **Shared Data Memory:** A single `data_memory` module is accessed by both cores.
- **Memory Arbiter:** The `memory_arbiter` module manages requests from both cores, granting access to one at a time and preventing data hazards or corruption.
- **Stall Logic:** If a core's memory request is denied, it stalls (halts PC and register updates) until access is granted.
- **Testbench:** The `dual_core_tb` module automates clock and reset, running the dual-core system for simulation.

## Stalling in Dual Core Operation

When both cores request access to shared RAM at the same time, only one can be granted access to prevent data conflicts. The other core must "stall," meaning it temporarily pauses execution until the memory becomes available.

**How Stalling is Handled:**  
In this project, stalling is managed by the memory arbiter. If a core's memory request is denied, the arbiter asserts a stall signal for that core. This causes the core to hold its program counter and pipeline registers in place, effectively pausing instruction execution until memory access is granted. This mechanism ensures safe, correct, and fair operation when both cores share memory.
