############################################################
# LEC DFT — NETLIST DFT vs NETLIST FINAL
############################################################

set log file opdiv_correct_lec_dft.log -replace

read library ../lib/slow_vdd1v0_basiccells.v -verilog -both

read design ../synthesis/outputs/opdiv_correct_netlist_dft.v -verilog -golden
read design ../synthesis/outputs/opdiv_netlist.v -verilog -revised

############################################################
# Ignorar lógica de scan
############################################################

add ignored inputs  scan_in  -both
add ignored outputs scan_out -both
add pin constraints 0 SE -both

############################################################
# Modo LEC
############################################################
set system mode lec

add compared point -all
compare

report verification
