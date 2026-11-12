# 🔐 Smart Password Lock Using Verilog HDL

<p align="center">
  <img src="https://img.shields.io/badge/Verilog-HDL-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Xilinx-Vivado%202020.1-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Simulation-32%2F32%20Passed-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/FPGA-Artix--7-purple?style=for-the-badge" />
</p>

<p align="center">
  <b>A simple digital security system designed using Verilog HDL.</b><br>
  Design • Simulate • Synthesize • Implement
</p>

---

## 📌 1. Project Introduction

The **Smart Password Lock** is a digital security system developed using Verilog HDL and Xilinx Vivado 2020.1.

It verifies entered passwords, controls access, supports password changes, and automatically locks the system after three incorrect attempts.

This project explores how digital logic can be used to build a practical security system.

## ✨ 2. Key Features

- 🔑 Password verification
- 🔄 Password changing functionality
- 🔓 Unlock indication for a correct password
- ❌ Error detection for an incorrect password
- 🔒 Automatic lockout after 3 incorrect attempts
- 🔢 Incorrect attempt counter
- ♻️ Reset functionality

## 🛠️ 3. Tools & Technologies

| Technology | Purpose |
|---|---|
| Verilog HDL | Digital logic design |
| Xilinx Vivado 2020.1 | Design and implementation |
| Behavioral Simulation | Functional verification |
| Artix-7 | Target FPGA device |

## 🏗️ 4. Project Architecture

```text
         Password Input
               |
               ▼
       Password Comparator
               |
         ┌─────┴─────┐
         │           │
      Correct     Incorrect
         │           │
         ▼           ▼
       UNLOCK       ERROR
                      |
                      ▼
                Attempt Counter
                      |
                      ▼
              3 Failed Attempts?
                      |
                      ▼
                    LOCKED

       Password Change & Reset
```

## 🧪 5. Simulation Results

The design was verified using a Verilog testbench.

<p align="center">
  <img src="https://img.shields.io/badge/Total%20Checks-32-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Passed-32-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Failed-0-red?style=for-the-badge" />
</p>

**Result:** All 32 checks passed with 0 failures.

Tested scenarios:

- Correct password verification
- Incorrect password detection
- Attempt counter operation
- Three-attempt lockout
- Password changing
- Unlocking with the updated password

## 📊 6. FPGA Resource Utilization

| Resource | Result |
|---|---:|
| LUTs | 13 |
| Flip-Flops | 21 |
| I/O Ports | 41 |

## ⏱️ 7. Timing & Power Analysis

**Timing Analysis**

| Parameter | Result |
|---|---:|
| Worst Negative Slack (WNS) | 5.876 ns |
| Total Negative Slack (TNS) | 0 ns |
| Failing Endpoints | 0 |

**Power Analysis**

| Parameter | Result |
|---|---:|
| Estimated On-Chip Power | 0.072 W |

*Note: Power is a Vivado estimate, not a measurement from physical hardware.*

## 📸 8. Project Screenshots

### 01. Project Overview
*Vivado project configuration and design summary.*

![Project Overview](./Project%20Overview.png)

---

### 02. RTL Schematic
*Generated RTL schematic showing the design logic.*

![RTL Schematic](./RTL%20Schematic.png)

---

### 03. Behavioral Simulation Waveform
*Waveform showing password inputs and output responses.*

![Behavioral Waveform](./Behavioral%20waveform.png)

---

### 04. Synthesis Utilization
*FPGA resource utilization after synthesis.*

![Synthesis Utilization](./Synthesis%20Utilization.png)

---

### 05. Timing Summary
*Timing analysis results after implementation.*

![Timing Summary](./Timing%20Summary.png)

---

### 06. Power Report
*Estimated on-chip power consumption.*

![Power Report](./Power%20Report.png)

---

### 07. Implementation Device View
*Implemented design on the selected FPGA device.*

![Implementation Device View](./Implementation%20Device%20View.png)

---

### 08. Tcl Console
*Simulation console showing test execution and completion.*

![Tcl Console](./Tcl%20Console.png)

---

## ⚠️ Hardware Testing Note

Simulation, synthesis, and implementation were completed using Vivado 2020.1.

Physical FPGA hardware testing was not performed because a physical FPGA board was not available.

## 👨‍💻 9. Author

**Narasimha Lakkimsetty**

🚀 Part of my **Verilog in Real Life** series.

Learning digital design by building practical projects.

<p align="center">
  <b>BUILD • SIMULATE • IMPLEMENT • LEARN</b>
</p>

<p align="center">
  ⭐ If you find this project useful, consider giving it a star!
</p>
