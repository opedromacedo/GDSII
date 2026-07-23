# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.19-s055_1 on Tue Dec 02 16:59:42 -03 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design opdiv

set_clock_gating_check -setup 0.0 
set_wire_load_mode "enclosed"
