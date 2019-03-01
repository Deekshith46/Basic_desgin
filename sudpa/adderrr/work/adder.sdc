create_clock -name clk -period 26
set_input_delay 7.8 -clock clk [all_inputs]
set_output_delay 7.8 -clock clk [all_outputs]
