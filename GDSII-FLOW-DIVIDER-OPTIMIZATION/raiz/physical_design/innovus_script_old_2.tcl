
# Otimizando
#set_db init_read_netlist_files ../sim/outputs_genus/opdiv_x_netlist.v ../physical_design/pads.v ../physical_design/chip.v 
#Inicializando o ambiente e bibliotecas
set LEF_PATH $env(HOME)/PDK/gsclib045/lef
set LEF_PATH_IO_PAD $env(HOME)/PDK/giolib045/lef
#set_db init_lib_search_path [list $LEF_PATH $LEF_PATH_IO_PAD]
set_db init_lef_files {gsclib045_tech.lef gsclib045_macro.lef giolib045.lef}
set QRC_PATH $env(HOME)/PDK/gsclib045/qrc/qx

# Definição de redes de alimentação
set_db init_power_nets VDD
set_db init_ground_nets VSS

# Leitura de restrições temporais (MMMC)
#read_netlist ../sim/output_files/opdiv_x_netli'st.v
read_mmmc opdiv_correct.view

# Leitura do design físico e lógico
#read_physical -lefs $LEF_PATH/gsclib045_tech.lef  $LEF_PATH/gsclib045_macro.lef $LEF_PATH_IO_PAD/giolib045.lef ../physical_design/pdkIO.lef
read_physical -lefs $LEF_PATH/gsclib045_tech.lef  $LEF_PATH/gsclib045_macro.lef
read_netlist \
  ../synthesis/outputs/opdiv_correct_netlist.v

# read_netlist \
#   ../synthesis/outputs/opdiv_correct_netlist.v \
#   ../physical_design/pads.v \
#   ../physical_design/chip.v \
#   -top chip

# Iniciar desginer físico

init_design

# Definição de IOS
#read_io_file {../physical_design/opdiv_x_pins_io_pad.io}

# Floorplan 
source ../physical_design/power.tcl
# source power.tcl
#---------------------------------------------------------------------------------
# Experimental
set_io_flow_flag 0
#create_floorplan -site CoreSite -core_density_size 1 0.75
#create_floorplan -site CoreSite -core_density_size 1 0.70
#create_floorplan -site CoreSite -core_density_size 0.998002350176 0.70

## Distribuição de energia
add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top Metal1 bottom Metal1 left Metal2 right Metal2} -width {top 0.7 bottom 0.7 left 0.7 right 0.7} -spacing {top 0.2 bottom 0.2 left 0.2 right 0.2} -offset {top 0.5 bottom 0.5 left 0.5 right 0.5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
add_stripes -nets {VDD VSS} -layer Metal10 -direction vertical -width 0.22 -spacing 0.2 -set_to_set_distance 5 -start_from left -start_offset 1 -stop_offset 0 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit Metal11 -pad_core_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid none
set_db route_special_via_connect_to_shape { noshape }
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { Metal1(1) Metal11(11) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal11(11) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { Metal1(1) Metal11(11) }
write_def ../physical_design/opdiv_correct.scandef 
read_def ../physical_design/opdiv_correct.scandef 
set_db reorder_scan_comp_logic true
set_db place_design_floorplan_mode true

## Placement
place_design 

## Adicionando TIE CELLS
add_tieoffs -lib_cell {TIEHI TIELO} -prefix LTIE -create_hport true -post_mask true

## Pre-placement
set_db place_design_floorplan_mode false
place_design -no_pre_place_opt -incremental
write_io_file -template opdiv_x_pins_io.io
read_io_file opdiv_x_pins_io.io
set_layer_preference Metal10 -is_visible 0

## Placement
place_design
#create_scan_chain –name scanChain1 -start IOPADS_INST/Pscanin1ip/C -stop IOPADS_INST/Pscanout1op/I
place_opt_design
add_fillers -base_cells FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1 DECAP10 DECAP9 DECAP8 DECAP7 DECAP6 DECAP5 DECAP4 DECAP3 DECAP2 -prefix FILLER
write_db ../physical_design/placeOpt

#Problemas
create_clock_tree_spec  
ccopt_design
write_db postCTSopt
#Listando os piores casos de slack
#time_design -post_cts -path_report -drv_report -slack_report -num_paths 50 -report_prefix core_postCTS -report_dir timingReports 

## Route
egui_pan -13.85850 154.64850
set_db route_design_with_timing_driven true
set_db route_design_with_si_driven true
route_design -global_detail
#create_floorplan -site CoreSite -core_density_size 0..4 0.598807 350.0 350.17 350.0 350.17
#add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top Metal11 bottom Metal11 left Metal10 right Metal10} -width {top 0.7 bottom 0.7 left 0.7 right 0.7} -spacing {top 0.2 bottom 0.2 left 0.2 right 0.2} -offset {top 0.5 bottom 0.5 left 0.5 right 0.5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
#-----------------------------------------------------------------------------------------------
## Rc timming
write_db postCTSoptreset_parasitics 
write_db postCTSoptPerforming RC Extraction
write_db postCTSoptset
set_db timing_analysis_type ocv

## Extração, timing e check
time_design -post_route 
time_design -post_route -hold
set_db check_drc_disable_rules {} ; set_db check_drc_ndr_spacing auto ; set_db check_drc_check_only default ; set_db check_drc_inside_via_def true ; set_db check_drc_exclude_pg_net false ; set_db check_drc_ignore_trial_route false ; set_db check_drc_ignore_cell_blockage false ; set_db check_drc_use_min_spacing_on_block_obs auto ; set_db check_drc_report core.drc.rpt ; set_db check_drc_limit 1000
check_drc 
set_db check_drc_area {0 0 0 0}
check_connectivity -type all -error 1000 -warning 50
set_power_analysis_mode -reset
set_power_analysis_mode -method static -analysis_view wc -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true

# Power analysis static
source ../physical_design/power.tcl
set_power_output_dir -reset
set_power_output_dir ../physical_design/run1
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
set_power -reset
set_powerup_analysis -reset
set_dynamic_power_simulation -reset

## Report potencia
report_power -rail_analysis_format VS -outfile ../physical_design/run1/core.rpt
report_power -rail_analysis_format VS -out_file ../physical_design/run1/core.rpt
gui_show

############################################################
# REPORTS FINAIS – SIGNOFF (POST-ROUTE)
############################################################

# Diretório de reports
file mkdir ../physical_design/reports

########################
# CONSTRAINTS
########################
report_constraint -all \
  > ../physical_design/reports/constraints.rpt

########################
# POWER – DESIGN LEVEL
########################
report_power -design \
  -outfile ../physical_design/reports/power_design.rpt

########################
# TIMING
########################
report_timing \
  -max_paths 50 \
  -path_type full_clock \
  > ../physical_design/reports/timing.rpt

########################
# ANALYSIS COVERAGE
########################
report_analysis_coverage \
  > ../physical_design/reports/analysis_coverage.rpt

########################
# AREA
########################
report_area \
  > ../physical_design/reports/area.rpt

########################
# PIN DENSITY
########################
report_pin_density \
  > ../physical_design/reports/pin_density.rpt

########################
# DRC CHECK (FINAL)
########################
set_db check_drc_report ../physical_design/reports/check_drc.rpt
check_drc

############################################################
# FIM DOS REPORTS
############################################################
# #set_db init_read_netlist_files ../sim/outputs_genus/opdiv_x_netlist.v ../physical_design/pads.v ../physical_design/chip.v 
# #Inicializando o ambiente e bibliotecas
# set LEF_PATH $env(HOME)/PDK/gsclib045/lef
# set LEF_PATH_IO_PAD $env(HOME)/PDK/giolib045/lef
# #set_db init_lib_search_path [list $LEF_PATH $LEF_PATH_IO_PAD]
# set_db init_lef_files {gsclib045_tech.lef gsclib045_macro.lef giolib045.lef}
# set QRC_PATH $env(HOME)/PDK/gsclib045/qrc/qx

# # Definição de redes de alimentação
# set_db init_power_nets VDD
# set_db init_ground_nets VSS

# # Leitura de restrições temporais (MMMC)
# #read_netlist ../sim/output_files/opdiv_x_netli'st.v
# read_mmmc opdiv_correct.view

# # Leitura do design físico e lógico
# #read_physical -lefs $LEF_PATH/gsclib045_tech.lef  $LEF_PATH/gsclib045_macro.lef $LEF_PATH_IO_PAD/giolib045.lef ../physical_design/pdkIO.lef
# read_physical -lefs $LEF_PATH/gsclib045_tech.lef  $LEF_PATH/gsclib045_macro.lef
# read_netlist \
#   ../synthesis/outputs/opdiv_correct_netlist.v

# # read_netlist \
# #   ../synthesis/outputs/opdiv_correct_netlist.v \
# #   ../physical_design/pads.v \
# #   ../physical_design/chip.v \
# #   -top chip
# # Iniciar desginer físico

# init_design

# # Definição de IOS
# #read_io_file {../physical_design/opdiv_x_pins_io_pad.io}

# # Floorplan 
# source ../physical_design/power.tcl
# # source power.tcl
# #---------------------------------------------------------------------------------
# # Experimental
# set_io_flow_flag 0
# create_floorplan -site CoreSite -core_density_size 1 0.75
# #create_floorplan -site CoreSite -core_density_size 1 0.70
# #create_floorplan -site CoreSite -core_density_size 0.998002350176 0.70

# ## Distribuição de energia
# add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top Metal1 bottom Metal1 left Metal2 right Metal2} -width {top 0.7 bottom 0.7 left 0.7 right 0.7} -spacing {top 0.2 bottom 0.2 left 0.2 right 0.2} -offset {top 0.5 bottom 0.5 left 0.5 right 0.5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
# add_stripes -nets {VDD VSS} -layer Metal10 -direction vertical -width 0.22 -spacing 0.2 -set_to_set_distance 5 -start_from left -start_offset 1 -stop_offset 0 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit Metal11 -pad_core_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid none
# set_db route_special_via_connect_to_shape { noshape }
# route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { Metal1(1) Metal11(11) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal11(11) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { Metal1(1) Metal11(11) }
# write_def ../physical_design/opdiv_correct.scandef 
# read_def ../physical_design/opdiv_correct.scandef 
# set_db reorder_scan_comp_logic true
# set_db place_design_floorplan_mode true

# ## Placement
# place_design 

# ## Adicionando TIE CELLS
# add_tieoffs -lib_cell {TIEHI TIELO} -prefix LTIE -create_hport true -post_mask true

# ## Pre-placement
# set_db place_design_floorplan_mode false
# place_design -no_pre_place_opt -incremental
# write_io_file -template opdiv_x_pins_io.io
# read_io_file opdiv_x_pins_io.io
# set_layer_preference Metal10 -is_visible 0

# ## Placement
# place_design
# #create_scan_chain –name scanChain1 -start IOPADS_INST/Pscanin1ip/C -stop IOPADS_INST/Pscanout1op/I
# place_opt_design
# add_fillers -base_cells FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1 DECAP10 DECAP9 DECAP8 DECAP7 DECAP6 DECAP5 DECAP4 DECAP3 DECAP2 -prefix FILLER
# write_db ../physical_design/placeOpt

# #Problemas
# create_clock_tree_spec  
# ccopt_design
# write_db postCTSopt
# #Listando os piores casos de slack
# #time_design -post_cts -path_report -drv_report -slack_report -num_paths 50 -report_prefix core_postCTS -report_dir timingReports 

# ## Route
# egui_pan -13.85850 154.64850
# set_db route_design_with_timing_driven true
# set_db route_design_with_si_driven true
# route_design -global_detail
# #create_floorplan -site CoreSite -core_density_size 0..4 0.598807 350.0 350.17 350.0 350.17
# #add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top Metal11 bottom Metal11 left Metal10 right Metal10} -width {top 0.7 bottom 0.7 left 0.7 right 0.7} -spacing {top 0.2 bottom 0.2 left 0.2 right 0.2} -offset {top 0.5 bottom 0.5 left 0.5 right 0.5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
# #-----------------------------------------------------------------------------------------------
# ## Rc timming
# write_db postCTSoptreset_parasitics 
# write_db postCTSoptPerforming RC Extraction
# write_db postCTSoptset
# set_db timing_analysis_type ocv

# ## Extração, timing e check
# time_design -post_route 
# time_design -post_route -hold
# set_db check_drc_disable_rules {} ; set_db check_drc_ndr_spacing auto ; set_db check_drc_check_only default ; set_db check_drc_inside_via_def true ; set_db check_drc_exclude_pg_net false ; set_db check_drc_ignore_trial_route false ; set_db check_drc_ignore_cell_blockage false ; set_db check_drc_use_min_spacing_on_block_obs auto ; set_db check_drc_report core.drc.rpt ; set_db check_drc_limit 1000
# check_drc 
# set_db check_drc_area {0 0 0 0}
# check_connectivity -type all -error 1000 -warning 50
# set_power_analysis_mode -reset
# set_power_analysis_mode -method static -analysis_view wc -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true

# # Power analysis static
# source ../physical_design/power.tcl
# set_power_output_dir -reset
# set_power_output_dir ../physical_design/run1
# set_default_switching_activity -reset
# set_default_switching_activity -input_activity 0.2 -period 10.0
# read_activity_file -reset
# set_power -reset
# set_powerup_analysis -reset
# set_dynamic_power_simulation -reset

# ## Report potencia
# report_power -rail_analysis_format VS -outfile ../physical_design/run1/core.rpt
# report_power -rail_analysis_format VS -out_file ../physical_design/run1/core.rpt
# gui_show

# ############################################################
# # REPORTS FINAIS – SIGNOFF (POST-ROUTE)
# ############################################################

# # Diretório de reports
# file mkdir ../physical_design/reports

# ########################
# # CONSTRAINTS
# ########################
# report_constraint -all \
#   > ../physical_design/reports/constraints.rpt

# ########################
# # POWER – DESIGN LEVEL
# ########################
# report_power -design \
#   -outfile ../physical_design/reports/power_design.rpt

# ########################
# # TIMING
# ########################
# report_timing \
#   -max_paths 50 \
#   -path_type full_clock \
#   > ../physical_design/reports/timing.rpt

# ########################
# # ANALYSIS COVERAGE
# ########################
# report_analysis_coverage \
#   > ../physical_design/reports/analysis_coverage.rpt

# ########################
# # AREA
# ########################
# report_area \
#   > ../physical_design/reports/area.rpt

# ########################
# # PIN DENSITY
# ########################
# report_pin_density \
#   > ../physical_design/reports/pin_density.rpt

# ########################
# # DRC CHECK (FINAL)
# ########################
# set_db check_drc_report ../physical_design/reports/check_drc.rpt
# check_drc

# ############################################################
# # FIM DOS REPORTS
# ############################################################