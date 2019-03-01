set sdc_version 2.0
current_design d_ff
set_unit -capacitance 1000.00fF
set_units -time 1000.00ps
create_clock -name clk -period 1.333 -waveform {0 0.666} [get_ports clk ]
create_clock -name VCLK -period 1.333 -waveform {0 0.666}

set_clock_uncertainty -setup  0.0626 [get_ports clk ]


set_input_delay -clock VCLK -max 0.5332 [all_inputs] ;#40%
set_input_delay -clock VCLK -min 0.2666 [all_inputs] ;#20%
set_output_delay -clock VCLK -max 0.3999 [all_output] ;#30%
set_output_delay -clock VCLK -max 0.1333 [all_output] ;#10%

set_max_fanout 30.00 [current_design]
