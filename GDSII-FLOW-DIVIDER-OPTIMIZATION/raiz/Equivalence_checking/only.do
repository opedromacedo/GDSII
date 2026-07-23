tclmode
set_dofile_abort exit
set_screen_display -noprogress

########################################
# Libraries
########################################
read_library -verilog ../lib/slow_vdd1v0_basiccells.v -both

########################################
# Read GOLDEN (RTL)
########################################
add_search_path ../rtl -design -golden
read_design -sv09 ../rtl/opdiv_correct.sv -golden
elaborate_design -golden -root opdiv

########################################
# Read REVISED (Netlist)
########################################
add_search_path fv/opdiv -design -revised
read_design -verilog ../synthesis/fv/opdiv/fv_map.v.gz -revised
elaborate_design -revised -root opdiv

########################################
# Basic alignment
########################################
set_undriven_signal 0 -golden
set_undriven_signal 0 -revised

set_flatten_model -seq_constant
set_flatten_model -balanced_modeling

########################################
# Compare ONLY LOGIC
########################################
set_system_mode setup
remove_compared_points -all
add_compared_points -primary_outputs

########################################
# Run LEC
########################################
set_system_mode lec
compare

########################################
# Reports
########################################
report_compare_result
report_unmapped_points -summary

puts "Compare points = [get_compare_points -count]"
puts "Diff points    = [get_compare_points -nonEquivalent -count]"

exit -f
