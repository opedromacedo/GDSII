############################################################
# Inicialização dos caminhos
############################################################
set_db init_lib_search_path ../lib/
set_db init_hdl_search_path ../rtl/

############################################################
# Leitura da biblioteca e RTL
############################################################
read_libs slow_vdd1v0_basicCells.lib
read_hdl -sv opdiv_correct.sv
elaborate

############################################################
# Restrições de temporização
############################################################
read_sdc ../constraints/constraints_top.sdc

############################################################
# Configuração DFT
############################################################
set_db dft_scan_style muxed_scan
set_db dft_prefix dft_

# Cria o Scan Enable
define_shift_enable -name SE -active high -create_port SE

check_dft_rules

############################################################
# Síntese genérica
############################################################
set_db syn_generic_effort medium
syn_generic

############################################################
# Mapeamento tecnológico
############################################################
set_db syn_map_effort medium
syn_map

############################################################
# >>> INSERÇÃO DE SCAN (VERSÃO CORRETA) <<<
############################################################
set_db dft_insert_scan true

############################################################
# Definição e conexão das Scan Chains
############################################################
define_scan_chain \
  -name top_chain \
  -sdi scan_in \
  -sdo scan_out \
  -create_ports

connect_scan_chains -auto_create_chains

############################################################
# Otimização final com scan
############################################################
set_db syn_opt_effort medium
syn_opt -incremental

############################################################
# Relatórios DFT
############################################################
check_dft_rules
report_scan_chains

############################################################
# Escrita dos artefatos
############################################################
write_hdl > outputs/opdiv_correct_netlist_dft.v
write_sdc > outputs/opdiv_correct_sdc_dft.sdc

write_sdf \
  -nonegchecks \
  -edges check_edge \
  -timescale ns \
  -recrem split \
  -setuphold split \
  > outputs/opdiv_correct_dft_delays.sdf

write_scandef > outputs/opdiv_correct_scanDEF.scandef

# Para Modus ATPG
write_dft_atpg -library ../lib/slow_vdd1v0_basiccells.v
