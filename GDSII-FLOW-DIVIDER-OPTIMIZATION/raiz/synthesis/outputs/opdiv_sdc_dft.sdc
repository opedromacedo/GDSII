# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.19-s055_1 on Tue Dec 02 18:08:28 -03 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design opdiv

create_clock -name "clock" -period 10.0 -waveform {0.0 5.0} [get_ports clock]
set_clock_transition 0.1 [get_clocks clock]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports nreset]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[31]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[30]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[29]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[28]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[27]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[26]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[25]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[24]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[23]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[22]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[21]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[20]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[19]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[18]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[17]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[16]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[15]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[14]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[13]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[12]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[11]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[10]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[9]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[8]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[7]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[6]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[5]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[4]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[3]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[2]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[1]}]
set_output_delay -clock [get_clocks clock] -add_delay -max 1.0 [get_ports {c[0]}]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.01 [get_ports clock]
set_clock_uncertainty -hold 0.01 [get_ports clock]
