############################################################
# Conformal LEC – RTL vs Netlist (FUNCIONAL)
############################################################

set log file opdiv_correct_lec_functional.log -replace

# Library
read library ../lib/slow_vdd1v0_basiccells.v -verilog -both

# Designs
read design ../rtl/opdiv_correct.sv -sv -golden
read design ../synthesis/outputs/opdiv_correct_netlist.v -verilog -revised

############################################################
# MODELING OPTIONS (LEC-CORRECT)
############################################################

# Trata nets/pinos não dirigidos
set flatten model -seq_constant
set undriven signal 0

# Reduz problemas de X
set system mode setup
set compare effort high

############################################################
# LEC
############################################################
set system mode lec

remove compared point -all
add compared point -po
compare

report verification
