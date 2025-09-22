# Mas_te_RISC-V_Microprocessor_Project
## 📌 Overview
This project implements a simple **RISC-V microprocessor** in Verilog, designed and simulated using **Xilinx Vivado**.  
It supports arithmetic, logical, load/store, and branch instructions, and follows a **multicycle execution model**.

## 📂 Repository Structure
- `src/` → Verilog source code for processor modules (ALU, Register File, Control, etc.)
- `tb/` → Testbenches for verifying modules
- `programs/` → Example machine code / memory initialization files

## 🚀 Features
- Implements R, I, S, B, U, J type instructions
- Multicycle datapath (Fetch, Decode, Execute, Memory, Writeback)
- ALU with arithmetic and logical ops
- Register file with 32 registers
- Data and instruction memory
- Synthesizable on FPGA

## 🛠️ Tools Used
- Xilinx Vivado
- Verilog HDL
- ModelSim / Vivado Simulator

## ▶️ Simulation
Run testbenches in `tb/` to verify individual modules and full processor execution.
