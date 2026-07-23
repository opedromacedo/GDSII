# Cadence Modus
#   Cadence(R) Modus(TM) DFT Software Solution, Version 23.11-s014_1, built Mar 14 2024 (linux26_64)
#   Date: Tuesday, December 02, 2025
build_model -workdir mydir -designsource counter.test_netlist.v -techlib ../../lib/slow_vdd1v0_basiccells.v -designtop opdiv
build_testmode -workdir mydir -testmode FULLSCAN -assignfile  opdiv.FULLSCAN.pinassign
build_testmode -workdir mydir -testmode FULLSCAN -assignfile  opdiv.FULLSCAN.pinassign
build_model -workdir mydir -designsource opdiv.test_netlist.v -techlib ../../lib/slow_vdd1v0_basiccells.v -designtop opdiv
build_testmode -workdir mydir -testmode FULLSCAN -assignfile  opdiv.FULLSCAN.pinassign
verify_test_structures -workdir mydir -testmode FULLSCAN
report_test_structures -workdir mydir -testmode FULLSCAN
build_faultmodel -workdir mydir -fullfault yes
create_scanchain_tests -workdir mydir -testmode FULLSCAN -experiment scan
create_logic_tests -workdir mydir -testmode FULLSCAN -experiment logic -effort high
write_vectors -workdir mydir -testmode FULLSCAN -inexperiment logic -language verilog -scanformat serial -outputfilename test_results
exit
