set sdc_version 2.0
current_design pp_tree16x64
set_unit -capacitance 1000.00fF
set_units -time 1000.00ps
create_clock -name clk -period 1.3 -waveform {0 0.65} [get_ports clk ]
create_clock -name VCLK -period 1.3 -waveform {0 0.65}

set_clock_uncertainty -setup  0.47 [get_ports clk ]


set_input_delay -clock VCLK -max 0.5332 [all_inputs]
set_input_delay -clock VCLK -min 0.2666 [all_inputs]  
set_output_delay -clock VCLK -max 0.3999 [all_output] 
set_output_delay -clock VCLK -max 0.1333 [all_output] 

set_max_fanout 30.00 [current_design]
