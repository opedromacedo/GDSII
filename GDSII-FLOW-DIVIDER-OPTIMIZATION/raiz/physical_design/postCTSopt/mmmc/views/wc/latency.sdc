set_clock_latency -source -early -max -rise  -0.111117 [get_ports {clock}] -clock clock 
set_clock_latency -source -early -max -fall  -0.113801 [get_ports {clock}] -clock clock 
set_clock_latency -source -late -max -rise  -0.111117 [get_ports {clock}] -clock clock 
set_clock_latency -source -late -max -fall  -0.113801 [get_ports {clock}] -clock clock 
