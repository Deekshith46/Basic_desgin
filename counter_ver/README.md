
# Counter Design and Testbench

This repository contains the Verilog implementation of an up/down counter along with its testbench for functional verification. The project demonstrates a simple yet effective way to design and verify a 3-bit counter using RTL and testbench methodologies.

---

## Overview

The up/down counter is a 3-bit design that increments or decrements its count value based on a mode control signal (`mod`). The design supports asynchronous reset and is tested using a testbench that compares the RTL output with a scoreboard-based expected value.

### Features:
- **3-bit counter** with values ranging from 0 to 7.
- **Mode control (`mod`)**: 
  - `mod = 1`: Counter increments (up mode).
  - `mod = 0`: Counter decrements (down mode).
- **Reset (`rst`)**: Asynchronous reset to initialize the counter to 0.
- **Clock-driven operation**.
- **Functional verification** using a testbench:
  - **Scoreboard mechanism** to compute expected outputs.
  - **Mismatch detection** to verify correctness.

---

## File Structure

```
counter_ver/
├── counter.v          # RTL design of the 3-bit up/down counter
├── counter_tb.sv      # Testbench for functional verification
├── wave.shm           # Simulation waveforms (tool-specific)
└── README.md          # Project documentation (this file)
```

---

## Design Details

### RTL Design: `counter.v`

The RTL design implements the following behavior:

- **Inputs**:
  - `clk` (Clock): Drives the counter updates.
  - `mod` (Mode): Determines whether the counter increments or decrements.
  - `rst` (Reset): Initializes the counter to 0 asynchronously.
- **Output**:
  - `count`: 3-bit counter output.

#### Logic:

- On a positive edge of the clock:
  - If `rst = 1`, the counter is reset to 0.
  - If `mod = 1`, the counter increments by 1.
  - If `mod = 0`, the counter decrements by 1.

---

### Testbench: `counter_tb.sv`

The testbench verifies the functionality of the counter design using a scoreboard mechanism.

#### Features:
1. **Clock Generation**:
   - A clock signal with a 10-time unit period is generated.
2. **Stimulus**:
   - Asserts `rst` to initialize the counter.
   - Switches `mod` between 1 (increment) and 0 (decrement).
3. **Scoreboard**:
   - Tracks the expected output based on `mod` and `rst`.
   - Compares the RTL output (`count`) with the expected value.
4. **Mismatch Detection**:
   - Displays match or mismatch messages during simulation.
   - Stops the simulation upon detecting a mismatch.

---

## Simulation Instructions

### Prerequisites:
- A Verilog simulator like Cadence Incisive (NC-Verilog), Synopsys VCS, or ModelSim.

### Steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/Deekshith46/Basic_desgin.git
   cd Basic_desgin/counter_ver
   ```

2. Run the simulation:
   - For Cadence:
     ```bash
     irun -sv counter.v counter_tb.sv
     ```
   - For Synopsys VCS:
     ```bash
     vcs -sverilog counter.v counter_tb.sv -o simv
     ./simv
     ```
   - For ModelSim:
     ```bash
     vlog counter.v counter_tb.sv
     vsim -c testbench -do "run -all; quit"
     ```

3. View the output:
   - Check the simulation logs for **MATCH** or **MISMATCH** messages.
   - View the waveforms in your simulator using `wave.shm` or equivalent.

---

## Example Output

### Log Snippet:
```
MATCH at time 50: RTL output = 1, Scoreboard output = 1
MATCH at time 60: RTL output = 2, Scoreboard output = 2
MISMATCH at time 70: RTL output = 3, Scoreboard output = 4
```

### Waveform:
Open the generated waveforms to visualize the counter behavior under different stimuli.

---

## Known Issues
- Ensure tool compatibility with `$shm_open` and `$shm_probe`. Replace with tool-specific waveform dumping commands if necessary.
- The testbench assumes proper initialization of the DUT inputs (`rst` and `mod`).

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Contributing
Feel free to fork this repository, submit issues, or create pull requests to enhance the design or testbench.

---

## Author
[Deekshith46](https://github.com/Deekshith46)