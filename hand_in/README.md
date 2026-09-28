# GCD Modules

- **`gcd_top.sv` — `gcd_top`**: Board-facing top-level module. It debounces the request input and connects the resulting request, operand bus, and clock/reset to `gcd`. The file also contains `gcd_top_reference`, a simulation-oriented behavioral specification.
- **`gcd.sv` — `gcd`**: FSMD-style GCD implementation. Its controller states load A and B, repeatedly subtract the smaller operand from the larger, and assert `ack` with the result once the operands match.
- **`gcd.sv` — `gcd_optimized`**: Alternative FSMD implementation that shares a subtractor and comparator through selected operands.
- **`gcd.sv` — `gcd_structural`**: Structural implementation that connects the separate `fsm` and `datapath` modules.
- **`fsm.sv` — `fsm`**: Controller for the structural design. It sequences operand loading and subtraction, selects ALU operations, and generates register enables and handshake outputs.
- **`datapath.sv` — `datapath`**: Structural data path containing the operand-selection mux, A and B registers, and ALU. It provides the ALU flags to the FSM and drives the result output.
- **`comp.sv` — `c_buf`, `c_mux`, `c_reg`, `c_alu`**: Parameterized components used by the structural datapath: a buffer, 2-to-1 mux, enabled register, and ALU. The ALU supports both subtraction directions, operand pass-through, and zero/negative flags.
- **`debounce.sv` — `debounce`**: Synchronizes and filters the mechanical request button signal before it reaches the GCD circuit. Its counter parameter can be reduced for simulation.
- **`gcd_tb.sv` — `gcd_tb`**: Simulation testbench. It generates a clock, applies operand pairs through the handshake, and checks the expected GCD results.
- **`Nexys4DDR_gcd.xdc`**: Vivado pin constraints mapping the top-level clock, reset, request, operand inputs, acknowledgement, and result to Nexys4DDR board pins.

> **Disclaimer:** This summary was written with the assistance of AI.
