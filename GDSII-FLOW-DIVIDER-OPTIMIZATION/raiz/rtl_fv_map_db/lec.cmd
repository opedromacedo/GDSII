REAd IMplementation Information synthesis/fv/opdiv -revised fv_map
SET PARAllel Option -threads 1,4 -norelease_license
SET COmpare Options -threads 1,4
SET MUltiplier Implementation boothrca -both
SET UNDEfined Cell black_box -noascend -both
ADD SEarch Path ../lib/ -library -both
REAd LIbrary -liberty -both /home/xmen/Desktop/divider_optimization/synthesis/../lib/slow_vdd1v0_basicCells.lib\
   /home/xmen/Desktop/divider_optimization/synthesis/../lib/slow_vdd1v0_basicCells.lib
SET UNDRiven Signal 0 -golden
SET NAming Style genus -golden
SET NAming Rule %s[%d] -instance_array -golden
SET NAming Rule %s_reg -register -golden
SET NAming Rule %L.%s %L[%d].%s %s -instance -golden
SET NAming Rule %L.%s %L[%d].%s %s -variable -golden
SET NAming Rule -ungroup_separator _ -golden
SET HDl Options -const_port_extend
SET HDl Options -unsigned_conversion_overflow on
SET HDl Options -v_to_vd on
SET HDl Options -VERILOG_INCLUDE_DIR sep:src
DELete SEarch Path -all -design -golden
ADD SEarch Path ../rtl/ -design -golden
REAd DEsign -enumconstraint -define SYNTHESIS -merge bbox -golden -lastmod -noelab -sv09 ../rtl/opdiv_correct.sv
EXIt -f
