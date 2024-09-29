# Harvard Architecture CPU Project

## Overview

This project implements a simplified Harvard architecture CPU using Verilog. The CPU is designed to execute basic instructions, manage data in memory, and demonstrate fundamental concepts in digital design and computer architecture.

## Features

- **Instruction Set**: Supports a basic instruction set including:
  - Load Immediate
  - Load from Memory
  - Store to Memory
  - Add
  - Subtract
- **Register File**: Contains 8 registers for data storage.
- **ALU**: Performs arithmetic and logic operations.
- **Memory**: Separate instruction and data memory.
- **Control Unit**: Decodes instructions and controls the CPU's operation.
- **Debug Outputs**: Provides information about the program counter, current instruction, and accumulator state.

## Modules

### cpu
The top-level module that integrates all components, including the control unit, ALU, register file, instruction memory, and data memory.

### control_unit
Handles instruction decoding and manages control signals for memory operations, ALU operations, and register file access.

### alu
Performs arithmetic and logic operations based on the control signals provided by the control unit.

### register_file
Manages the storage and retrieval of data in the CPU's registers.

### instruction_memory
Stores the instructions to be executed by the CPU and provides them based on the program counter.

### data_memory
Handles data storage and retrieval operations, supporting memory read and write functions.
