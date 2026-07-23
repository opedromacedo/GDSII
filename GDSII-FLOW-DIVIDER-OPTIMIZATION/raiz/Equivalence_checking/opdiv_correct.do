set log file opdiv_correct_lec.log -replace
read library ../lib/slow_vdd1v0_basiccells.v -verilog -both
read design ../rtl/opdiv_correct.sv -sv -golden
read design ../synthesis/outputs/opdiv_netlist.v -verilog -revised
report module
add pin constraints 0 SE -revised
add ignored inputs scan_in -revised
add ignored outputs scan_out -revised
set flatten model -seq_constant
remodel -seq_constant -repeat -golden
set system mode lec
add compared point -all
compare
report_verification
set gui
