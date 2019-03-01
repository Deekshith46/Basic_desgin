# ####################################################################

#  Created by Genus(TM) Synthesis Solution 17.22-s017_1 on Wed Feb 20 05:59:39 IST 2019

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design booth_radix4_multiplier_32

create_clock -name "VCLK" -period 1.333 -waveform {0.0 0.666} 
group_path -weight 1.000000 -name I2O -from [list \
  [get_ports {A[31]}]  \
  [get_ports {A[30]}]  \
  [get_ports {A[29]}]  \
  [get_ports {A[28]}]  \
  [get_ports {A[27]}]  \
  [get_ports {A[26]}]  \
  [get_ports {A[25]}]  \
  [get_ports {A[24]}]  \
  [get_ports {A[23]}]  \
  [get_ports {A[22]}]  \
  [get_ports {A[21]}]  \
  [get_ports {A[20]}]  \
  [get_ports {A[19]}]  \
  [get_ports {A[18]}]  \
  [get_ports {A[17]}]  \
  [get_ports {A[16]}]  \
  [get_ports {A[15]}]  \
  [get_ports {A[14]}]  \
  [get_ports {A[13]}]  \
  [get_ports {A[12]}]  \
  [get_ports {A[11]}]  \
  [get_ports {A[10]}]  \
  [get_ports {A[9]}]  \
  [get_ports {A[8]}]  \
  [get_ports {A[7]}]  \
  [get_ports {A[6]}]  \
  [get_ports {A[5]}]  \
  [get_ports {A[4]}]  \
  [get_ports {A[3]}]  \
  [get_ports {A[2]}]  \
  [get_ports {A[1]}]  \
  [get_ports {A[0]}]  \
  [get_ports {B[31]}]  \
  [get_ports {B[30]}]  \
  [get_ports {B[29]}]  \
  [get_ports {B[28]}]  \
  [get_ports {B[27]}]  \
  [get_ports {B[26]}]  \
  [get_ports {B[25]}]  \
  [get_ports {B[24]}]  \
  [get_ports {B[23]}]  \
  [get_ports {B[22]}]  \
  [get_ports {B[21]}]  \
  [get_ports {B[20]}]  \
  [get_ports {B[19]}]  \
  [get_ports {B[18]}]  \
  [get_ports {B[17]}]  \
  [get_ports {B[16]}]  \
  [get_ports {B[15]}]  \
  [get_ports {B[14]}]  \
  [get_ports {B[13]}]  \
  [get_ports {B[12]}]  \
  [get_ports {B[11]}]  \
  [get_ports {B[10]}]  \
  [get_ports {B[9]}]  \
  [get_ports {B[8]}]  \
  [get_ports {B[7]}]  \
  [get_ports {B[6]}]  \
  [get_ports {B[5]}]  \
  [get_ports {B[4]}]  \
  [get_ports {B[3]}]  \
  [get_ports {B[2]}]  \
  [get_ports {B[1]}]  \
  [get_ports {B[0]}] ] -to [list \
  [get_ports {P[63]}]  \
  [get_ports {P[62]}]  \
  [get_ports {P[61]}]  \
  [get_ports {P[60]}]  \
  [get_ports {P[59]}]  \
  [get_ports {P[58]}]  \
  [get_ports {P[57]}]  \
  [get_ports {P[56]}]  \
  [get_ports {P[55]}]  \
  [get_ports {P[54]}]  \
  [get_ports {P[53]}]  \
  [get_ports {P[52]}]  \
  [get_ports {P[51]}]  \
  [get_ports {P[50]}]  \
  [get_ports {P[49]}]  \
  [get_ports {P[48]}]  \
  [get_ports {P[47]}]  \
  [get_ports {P[46]}]  \
  [get_ports {P[45]}]  \
  [get_ports {P[44]}]  \
  [get_ports {P[43]}]  \
  [get_ports {P[42]}]  \
  [get_ports {P[41]}]  \
  [get_ports {P[40]}]  \
  [get_ports {P[39]}]  \
  [get_ports {P[38]}]  \
  [get_ports {P[37]}]  \
  [get_ports {P[36]}]  \
  [get_ports {P[35]}]  \
  [get_ports {P[34]}]  \
  [get_ports {P[33]}]  \
  [get_ports {P[32]}]  \
  [get_ports {P[31]}]  \
  [get_ports {P[30]}]  \
  [get_ports {P[29]}]  \
  [get_ports {P[28]}]  \
  [get_ports {P[27]}]  \
  [get_ports {P[26]}]  \
  [get_ports {P[25]}]  \
  [get_ports {P[24]}]  \
  [get_ports {P[23]}]  \
  [get_ports {P[22]}]  \
  [get_ports {P[21]}]  \
  [get_ports {P[20]}]  \
  [get_ports {P[19]}]  \
  [get_ports {P[18]}]  \
  [get_ports {P[17]}]  \
  [get_ports {P[16]}]  \
  [get_ports {P[15]}]  \
  [get_ports {P[14]}]  \
  [get_ports {P[13]}]  \
  [get_ports {P[12]}]  \
  [get_ports {P[11]}]  \
  [get_ports {P[10]}]  \
  [get_ports {P[9]}]  \
  [get_ports {P[8]}]  \
  [get_ports {P[7]}]  \
  [get_ports {P[6]}]  \
  [get_ports {P[5]}]  \
  [get_ports {P[4]}]  \
  [get_ports {P[3]}]  \
  [get_ports {P[2]}]  \
  [get_ports {P[1]}]  \
  [get_ports {P[0]}] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[31]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[30]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[29]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[28]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[27]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[26]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[25]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[24]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[23]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[22]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[21]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[20]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[19]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[18]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[17]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[16]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[15]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[14]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[13]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[12]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[11]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[10]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[9]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[8]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[7]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[6]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[5]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[4]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[3]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[2]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[1]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {A[0]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[31]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[30]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[29]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[28]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[27]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[26]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[25]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[24]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[23]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[22]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[21]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[20]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[19]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[18]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[17]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[16]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[15]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[14]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[13]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[12]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[11]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[10]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[9]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[8]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[7]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[6]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[5]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[4]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[3]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[2]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[1]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -max 0.5332 [get_ports {B[0]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[31]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[30]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[29]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[28]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[27]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[26]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[25]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[24]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[23]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[22]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[21]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[20]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[19]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[18]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[17]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[16]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[15]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[14]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[13]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[12]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[11]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[10]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[9]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[8]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[7]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[6]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[5]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[4]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[3]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[2]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[1]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {A[0]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[31]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[30]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[29]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[28]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[27]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[26]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[25]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[24]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[23]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[22]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[21]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[20]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[19]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[18]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[17]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[16]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[15]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[14]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[13]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[12]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[11]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[10]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[9]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[8]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[7]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[6]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[5]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[4]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[3]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[2]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[1]}]
set_input_delay -clock [get_clocks VCLK] -add_delay -min 0.2666 [get_ports {B[0]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[63]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[62]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[61]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[60]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[59]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[58]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[57]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[56]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[55]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[54]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[53]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[52]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[51]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[50]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[49]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[48]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[47]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[46]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[45]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[44]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[43]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[42]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[41]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[40]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[39]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[38]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[37]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[36]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[35]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[34]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[33]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[32]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[31]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[30]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[29]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[28]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[27]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[26]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[25]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[24]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[23]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[22]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[21]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[20]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[19]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[18]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[17]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[16]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[15]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[14]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[13]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[12]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[11]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[10]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[9]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[8]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[7]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[6]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[5]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[4]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[3]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[2]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[1]}]
set_output_delay -clock [get_clocks VCLK] -add_delay -max 0.1333 [get_ports {P[0]}]
set_max_fanout 30.000 [current_design]
set_wire_load_mode "enclosed"
set_dont_use [get_lib_cells fast_vdd1v0/HOLDX1]
