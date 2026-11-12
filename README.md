\# APB Master–Slave System (VHDL)



\## Project Overview

This project implements a complete AMBA APB (Advanced Peripheral Bus) communication system using VHDL. It connects an APB Master controller to an APB Slave containing four 32-bit registers.



The APB Master controls read and write transactions using a finite state machine (FSM). The APB Slave responds to the master's requests.



\## Architecture



The system consists of three main modules:



\- \*\*APB Master:\*\* Generates APB control signals and manages transactions.

\- \*\*APB Slave:\*\* Implements four 32-bit memory-mapped registers.

\- \*\*APB Top:\*\* Connects the master and slave modules.



\### APB Master FSM



The master uses three states:



1\. \*\*IDLE:\*\* Waits for a transaction request (`start`).

2\. \*\*SETUP:\*\* Selects the slave and presents the address and control signals.

3\. \*\*APB\_ACCESS:\*\* Enables the access phase and waits for `PREADY`.



When the transaction completes, the master asserts `done`. For read operations, it captures the returned data. It also captures the slave error response.



\## Slave Register Map



| Address | Register |

|---|---|

| 0x00 | Register 0 |

| 0x04 | Register 1 |

| 0x08 | Register 2 |

| 0x0C | Register 3 |



Each register is 32 bits wide.



\## Verification



The VHDL testbench (`apb\_system\_tb.vhd`) verifies the integrated master–slave system.



Test scenarios include:



\- Writing data to register 0.

\- Reading back and checking the stored data.

\- Detecting an invalid-address write.

\- Verifying that an invalid write does not corrupt valid register data.



\*\*Simulation result:\*\* All test scenarios passed. The testbench reported:



`APB Master-Slave System tests completed!`



No assertion errors were reported.



\## FPGA Implementation



\*\*Target device:\*\* Artix-7 `xc7a35tcpg236-1`  

\*\*Tool:\*\* AMD Xilinx Vivado 2024.1  

\*\*HDL:\*\* VHDL  

\*\*Clock constraint:\*\* 10 ns (100 MHz)



\### Resource Utilization



| Resource | Used |

|---|---:|

| Slice LUTs | 57 |

| Slice Registers | 206 |

| BUFGCTRL | 1 |



\### Timing Summary



| Timing Metric | Result |

|---|---:|

| Clock Frequency | 100 MHz |

| Clock Period | 10 ns |

| WNS | +5.676 ns |

| TNS | 0 ns |

| WHS | +0.164 ns |

| THS | 0 ns |

| Setup Violations | 0 |

| Hold Violations | 0 |



The implemented design met the user-specified timing constraints. External input and output delay constraints were not specified, so the reported timing results should not be interpreted as complete external interface timing closure.



\## Project Structure



```text

APB\_Master\_Slave\_System/

│

├── rtl/

│   ├── apb\_master.vhd

│   ├── apb\_slave.vhd

│   └── apb\_top.vhd

│

├── testbench/

│   └── apb\_system\_tb.vhd

│

├── constraints/

│   └── apb\_master\_slave\_constraints.xdc

│

├── reports/

│   ├── apb\_master\_slave\_timing\_summary.rpt

│   ├── apb\_master\_slave\_check\_timing.rpt

│   └── apb\_master\_slave\_utilization.rpt

│

└── screenshots/

&#x20;   ├── apb\_master\_slave\_simulation.png

&#x20;   ├── apb\_master\_slave\_timing\_summary.png

&#x20;   ├── apb\_master\_slave\_synthesized\_schematic.png

&#x20;   └── apb\_master\_slave\_implemented\_schematic.png

```



## Simulation Waveform

![APB Master-Slave Simulation](./screenshots/apb_master_slave_simulation.png)

## Synthesized Schematic

![Synthesized Schematic](./screenshots/apb_master_slave_synthesized_schematic.png)

## Implemented Schematic

![Implemented Schematic](./screenshots/apb_master_slave_implemented_schematic.png)

## Timing Summary

![Timing Summary](./screenshots/apb_master_slave_timing_summary.png)
\## Key Learning Outcomes



\- Designed an APB Master FSM in VHDL.

\- Integrated an APB Master and Slave.

\- Implemented memory-mapped registers.

\- Verified read and write transactions using a VHDL testbench.

\- Tested invalid-address error handling.

\- Performed synthesis, implementation, and timing analysis using Vivado.



\## Author



Padma Shree Kondrahalli Byra Reddy



\## Tools Used



\- AMD Xilinx Vivado 2024.1

\- VHDL

\- XSim Simulator

\- Artix-7 FPGA



