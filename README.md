# 🚀 RISC-V Processor Implementation on FPGA

This repository contains the design and implementation of a **32-bit RISC-V (RV32I) Processor** tailored for FPGA platforms, specifically the PYNQ-Z2.

[![Status](https://img.shields.io/badge/Status-Designing--Single--Cycle-orange)]()
[![ISA](https://img.shields.io/badge/ISA-RV32I-blue)]()
[![Target](https://img.shields.io/badge/Target-PYNQ--Z2-red)]()

---

## 🏗 Architecture
The project focuses on building a complete **Single-Cycle Processor** microarchitecture from scratch.

### Single-Cycle Block Diagram
<p align="center">
  <img width="80%" alt="Single Cycle Block Diagram" src="https://github.com/user-attachments/assets/1b40b4ae-1ac3-4ec9-81eb-6ac1c49bcb1f" />
</p>

---

## 🛠 Specifications

| Category | Details |
| :--- | :--- |
| **Instruction Set** | RISC-V RV32I (Base Integer) |
| **Microarchitecture** | Evolutionary Design (Single-Cycle → Multi-Cycle → Pipelined) |
| **Features** | Hazard Handling, Performance Benchmarking, Cache Integration (TBD) |
| **Target Hardware** | PYNQ-Z2 (Xilinx Zynq-7000 SoC) |
| **Hardware Language** | Verilog HDL |
| **EDA Tool** | Xilinx Vivado 2025.2 |
| **Software Toolchain** | **TBD** (e.g., RISC-V GNU Toolchain) |

---

## 📈 Project Roadmap & Progress

This project is structured in phases, moving from a basic functional processor to an optimized pipelined architecture with performance benchmarking.

### Phase 1: Single-Cycle Processor
- [x] Fundamental Architecture & Datapath Design
- [x] Core RV32I Module Implementation (ALU, RegFile, ImmGen)
- [x] Control Unit & Instruction Decoding Logic
- [x] Functional Verification via Simulation (Vivado XSim)
<img width="1280" height="300" alt="image" src="https://github.com/user-attachments/assets/f9ddfaee-111c-47b2-8504-687932222bfe" />

### Phase 2: Multi-Cycle Processor (⭐Current Focus⭐)
- [ ] State Machine Based Control Unit Design
- [ ] Resource Sharing Optimization (Shared ALU/Memory)
- [ ] Multi-cycle Instruction Timing Verification

### Phase 3: Pipelined Processor
- [ ] 5-Stage Pipeline Implementation (IF, ID, EX, MEM, WB)
- [ ] Hazard Detection & Forwarding Unit (Data/Control Hazard Handling)
- [ ] Branch Prediction Logic Implementation

### Phase 4: Performance Analysis & Optimization
- [ ] **Benchmark Testing**: Running Dhrystone/CoreMark on FPGA
- [ ] **CPI Analysis**: Cycles Per Instruction (CPI) measurement and comparison
- [ ] **Timing & Resource Optimization**: FPGA Synthesis/Implementation tuning
- [ ] **Memory System Enhancement**: Cache memory (L1) integration

---

## 🔄 Development Workflow
The project follows a structured hardware design cycle for reliable implementation and verification.

<p align="center">
  <img width="80%" alt="Workflow Diagram" src="https://github.com/user-attachments/assets/1b09abf6-b97a-452e-acef-3794223c4844" />
</p>

1. **RTL Coding**: Modular design using Verilog HDL.
2. **Functional Simulation**: Verification using Vivado Simulator (XSim).
3. **Synthesis & Implementation**: Mapping logic to FPGA resources and timing analysis.
4. **On-Board Testing**: Final validation on the PYNQ-Z2 board.

---

## 📚 References
This project is inspired by and references the following resources:

* **Course**: [RISC-V Processor Design Course](https://www.youtube.com/watch?v=izPdo7n1u1I) by Marco Spaziani Brunella
* **Specification**: [Official RISC-V Instruction Set Manual](https://riscv.org/technical/specifications/)

