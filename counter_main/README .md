
# Counter Design and Verification Project

This repository contains the design, verification, and coverage analysis of a simple counter module implemented in Verilog. The project demonstrates a complete design verification flow using SystemVerilog, including testbench development, simulation, and coverage analysis.

---

## 📂 Project Structure

```
counter_main/
├── counter.v            # Verilog design file for the counter
├── tes3.sv              # SystemVerilog testbench for simulation
├── cov_report.txt       # Coverage report generated from the simulation
```

---

## ✨ Features

- **Synchronous Operation**: All operations are synchronized to the clock.
- **Reset Functionality**: Supports asynchronous or synchronous resets.
- **Modular Counting**: Parameterizable counting logic for scalable designs.
- **Scalable Design**: Easily adaptable for different bit-widths.

---

## 🔍 Working of SystemVerilog in the Verification Environment

The testbench leverages advanced SystemVerilog features to ensure robust and reusable verification.

### 1️⃣ Testbench Architecture

- **Interface**: Groups related signals for easier management.
- **Clocking Blocks**: Ensures synchronous sampling and driving of signals.
- **Randomization**: Generates inputs to test edge cases and achieve coverage goals.

### 2️⃣ Key Features Used

- **Assertions**: Validates critical properties (e.g., reset behavior, counter increment logic).
- **Constrained Random Testing**: Randomizes input signals (`mod`, `rst`) to simulate real-world scenarios.
- **Coverage-Driven Verification**: Tracks functional aspects like reset triggers and signal transitions.

### 3️⃣ Workflow

- **Driver**: Sends input signals (`clk`, `rst`, `mod`) to the DUT.
- **Monitor**: Observes and logs DUT outputs (`count`).
- **Scoreboard**: Compares DUT outputs with a reference model.
- **Coverage Analysis**: Collects metrics to assess test completeness.

---

## 💻 Simulation Environment

- **Simulator**: Cadence Xcelium (`irun`)
- **Languages**: Verilog (design) and SystemVerilog (testbench)
- **Coverage Analysis**: Run with `-access +rwc`

### 🚀 Running the Simulation

1. Open a terminal and navigate to the project directory.
2. Use the following command to compile, simulate, and generate coverage:

   ```bash
   irun -access +rwc counter.v tes3.sv
   ```

3. View the coverage report in `cov_report.txt`.

---

## 🧪 Testbench and Verification Methodology

### Test Scenarios

1. **Default Operation**: Validates normal counting behavior.
2. **Reset Tests**: Verifies counter reset functionality.
3. **Edge Cases**: Tests for counter overflow/underflow and modular counting.
4. **Randomized Tests**: Achieves broader test coverage using randomization.

### Key Assertions

- Reset clears the counter (`count == 0`).
- Counter increments correctly on each clock cycle when enabled.
- Modular counting logic works as expected.

---

## 📊 Coverage Analysis

### Achievements

- **100% Code Coverage**: Block, expression, and toggle analysis included.

### Gaps

- Minor toggle coverage gaps observed for `mod` and `rst`.

---

## 🚀 Future Enhancements

1. **Expand Randomized Scenarios**: Add complex constraints for `mod` and `rst`.
2. **FSM Analysis**: Validate state transitions, if applicable.
3. **UVM Integration**: Upgrade to Universal Verification Methodology for scalability.

---

## ⚡ Advanced Use Cases

### Design Scaling

- Supports larger counters with parameterized bit-widths.
- Integrates seamlessly into digital designs like timers and frequency counters.

### FPGA/ASIC Compatibility

- Synthesizable design, ready for real-time applications.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request to enhance the project.

---

## 📜 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
