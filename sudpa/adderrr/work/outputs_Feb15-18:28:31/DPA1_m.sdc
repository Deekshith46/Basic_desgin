# ####################################################################

#  Created by Genus(TM) Synthesis Solution 17.22-s017_1 on Fri Feb 15 18:28:52 IST 2019

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design DPA1

set_clock_gating_check -setup 0.0 
set_wire_load_mode "enclosed"
set_dont_use [get_lib_cells fast_vdd1v0/HOLDX1]
