
#set_db init_read_netlist_files ../sim/outputs_genus/opdiv_x_netlist.v ../physical_design/pads.v ../physical_design/chip.v 

#~/PDK/xfab_xh018/xh018/diglibs/IO_CELLS_FC1V8/v1_1/LEF/v1_1_1/xh018_xx43_MET4_METMID_METTHK_IO_CELLS_FC1V8.lef
set DESIGN_PATH     $env(HOME)/PDK/xfab_xh018/xh018
set TECHNOLOGY_LEF  $DESIGN_PATH/cadence/v8_0/techLEF/v8_0_1_1
set D_CELL_LEF      $DESIGN_PATH/diglibs/D_CELLS_HD/v3_0/LEF/v3_0_0
set TIME            $DESIGN_PATH/diglibs/D_CELLS_HD/v3_0/liberty_LPMOS/v3_0_1/PVT_1_80V_range
set LEF_PATH_IO_PAD $DESIGN_PATH/diglibs/IO_CELLS_FC1V8/v1_1/LEF/v1_1_1
set CAPTABLE        $DESIGN_PATH/cadence/v8_0/capTbl/v8_0_1
set QRC_PATH        $DESIGN_PATH/cadence/v8_1/QRC_assura/v8_1_1/XH018_1143/QRC-Max/qrcTechFile

#set LEF_PATH $env(HOME)/PDK/gsclib045/lef
#set LEF_PATH_IO_PAD $env(HOME)/PDK/giolib045/lef
#set_db init_lib_search_path [list $LEF_PATH $LEF_PATH_IO_PAD]
#set_db init_lef_files {xh018_D_CELLS_HD.lef xh018_xx43_HD_MET4_METMID_METTHK.lef giolib045.lef xh018_xx43_MET4_METMID_METTHK_IO_CELLS_FC1V8.lef}
#set QRC_PATH $env(HOME)/PDK/gsclib045/qrc/qx
#set IO_LEF         "${DESIGN_PATH}/xh018/diglibs/IO_CELLS_FC1V8/v1_1/LEF/v1_1_1/xh018_xx43_MET4_METMID_METTHK_IO_CELLS_FC1V8.lef"

set_db init_power_nets VDD
set_db init_ground_nets VSS

#read_netlist ../sim/output_files/opdiv_x_netlist.v

set_db init_mmmc_files ../physical_design/opdiv_x.view
read_mmmc ../physical_design/opdiv_x.view


read_physical -lefs $TECHNOLOGY_LEF/xh018_xx43_HD_MET4_METMID_METTHK.lef  $D_CELL_LEF/xh018_D_CELLS_HD.lef $LEF_PATH_IO_PAD/xh018_xx43_MET4_METMID_METTHK_IO_CELLS_FC1V8.lef

read_netlist ../sim/outputs_genus/opdiv_x_netlist.v ../physical_design/pads.v ../physical_design/chip.v -top chip

init_design
# read_io_file {../physical_design/opdiv_x_pins_io_pad.io}
source ../physical_design/power.tcl

#---------------------------------------------------------------------------------
# Experimental#
#set_floorplan_row_spacing_and_type 150 2
set_io_flow_flag 0
create_floorplan -site core_hd -core_density_size 1.02763368858 1 500 500 500 500

#set_db add_rings_target default ; set_db add_rings_extend_over_row 0 ; set_db add_rings_ignore_rows 0 ; set_db add_rings_avoid_short 0 ; set_db add_rings_skip_shared_inner_ring none ; set_db add_rings_stacked_via_top_layer METTPL ; set_db add_rings_stacked_via_bottom_layer MET1 ; set_db add_rings_via_using_exact_crossover_size 1 ; set_db add_rings_orthogonal_only true ; set_db add_rings_skip_via_on_pin {  standardcell } ; set_db add_rings_skip_via_on_wire_shape {  noshape }

add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top MET1 bottom MET1 left MET2 right MET2} -width {top 30 bottom 30 left 30 right 30} -spacing {top 20 bottom 20 left 20 right 20} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
#set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape none ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer METTPL ; set_db add_stripes_stacked_via_bottom_layer MET1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  noshape   }
add_stripes -nets {VDD VSS} -layer MET1 -direction vertical -width 20 -spacing 20 -set_to_set_distance 200 -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit METTPL -pad_core_ring_bottom_layer_limit MET1 -block_ring_top_layer_limit METTPL -block_ring_bottom_layer_limit MET1 -use_wire_group 0 -snap_wire_center_to_grid none
#set_db route_special_via_connect_to_shape { noshape }
route_special -connect {core_pin} -layer_change_range { MET1(1) METTPL(6) } -block_pin_target {nearest_target} -core_pin_target {first_after_row_end} -allow_jogging 1 -crossover_via_layer_range { MET1(1) METTPL(6) } -nets { VDD VSS } -allow_layer_change 1 -target_via_layer_range { MET1(1) METTPL(6) }





#add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top Metal1 bottom Metal1 left Metal2 right Metal2} -width {top 0.7 bottom 0.7 left 0.7 right 0.7} -spacing {top 0.2 bottom 0.2 left 0.2 right 0.2} -offset {top 0.5 bottom 0.5 left 0.5 right 0.5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
#add_stripes -nets {VDD VSS} -layer Metal10 -direction vertical -width 0.22 -spacing 0.2 -set_to_set_distance 5 -start_from left -start_offset 1 -stop_offset 0 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit Metal11 -pad_core_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid none

#set_db route_special_via_connect_to_shape { noshape }
#route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { Metal1(1) Metal11(11) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal11(11) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { Metal1(1) Metal11(11) }
write_def ../physical_design/opdiv_x.scandef 
read_def ../physical_design/opdiv_x.scandef 
set_db reorder_scan_comp_logic true
set_db place_design_floorplan_mode true
place_design 
#Adicionando TIE CELLS
#add_tieoffs -lib_cell {TIEHI TIELO} -prefix LTIE -create_hport true -post_mask true pdk generico
add_tieoffs -lib_cell {LOGIC1HD LOGIC0HD} -prefix LTIE -create_hport true -post_mask true
#Pre placement
set_db place_design_floorplan_mode false
place_design -no_pre_place_opt -incremental
write_io_file -template opdiv_x_pins_io.io
read_io_file opdiv_x_pins_io.io
set_layer_preference Metal10 -is_visible 0
#Placement
place_design
#create_scan_chain –name scanChain1 -start IOPADS_INST/Pscanin1ip/C -stop IOPADS_INST/Pscanout1op/I

# 
place_opt_design
#add_fillers -base_cells FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1 DECAP10 DECAP9 DECAP8 DECAP7 DECAP6 DECAP5 DECAP4 DECAP3 DECAP2 -prefix FILLER -fill_gap -mark_fixed
add_fillers -base_cells FEED7HD FEED5HD FEED3HD FEED2HD FEED25HD FEED1HD FEED15HD FEED10HD FCNED9HD FCNED8HD FCNED7HD FCNED6HD FCNED5HD -prefix FILLER -fill_gap -mark_fixed
write_db ../physical_design/placeOpt

#probelmas
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
##rc timming
write_db postCTSoptreset_parasitics 
write_db postCTSoptPerforming RC Extraction
write_db postCTSoptset

set_db timing_analysis_type ocv
time_design -post_route 
time_design -post_route -hold
set_db check_drc_disable_rules {} ; set_db check_drc_ndr_spacing auto ; set_db check_drc_check_only default ; set_db check_drc_inside_via_def true ; set_db check_drc_exclude_pg_net false ; set_db check_drc_ignore_trial_route false ; set_db check_drc_ignore_cell_blockage false ; set_db check_drc_use_min_spacing_on_block_obs auto ; set_db check_drc_report core.drc.rpt ; set_db check_drc_limit 1000
check_drc 
set_db check_drc_area {0 0 0 0}
check_connectivity -type all -error 1000 -warning 50
set_power_analysis_mode -reset
set_power_analysis_mode -method static -analysis_view wc -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
#power analysis static
source ../physical_design/power.tcl
set_power_output_dir -reset
set_power_output_dir ../physical_design/run1
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
set_power -reset
set_powerup_analysis -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -outfile ../physical_design/run1/core.rpt
report_power -rail_analysis_format VS -out_file ../physical_design/run1/core.rpt
gui_show