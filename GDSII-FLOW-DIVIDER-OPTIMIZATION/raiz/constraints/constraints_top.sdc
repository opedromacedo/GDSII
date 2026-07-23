# create_clock -name "clock" -period 10 -waveform {0 5} [get_ports "clock"]
# set_clock_transition -rise 0.1 [get_clocks "clock"]
# set_clock_transition -fall 0.1 [get_clocks "clock"]
# set_clock_uncertainty 0.01 [get_ports "clock"]
# set_input_delay -max 1.0 [get_ports "nreset"] -clock [get_clocks "clock"]
# set_output_delay -max 1.0 [get_ports "c"] -clock [get_clocks "clock"]

# -----------------------------------------------------------
# 1. CLOCK DEFINITION
# -----------------------------------------------------------

# Define o clock principal (Período de 10ns, Frequência de 100MHz)
create_clock -name "clock" -period 10 -waveform {0 5} [get_ports "clock"]
# Define as incertezas (jitter e skew) do clock
set_clock_uncertainty 0.01 [get_clocks "clock"]
# Define os tempos de transição do clock (slope/slew rate)
set_clock_transition -rise 0.1 [get_clocks "clock"]
set_clock_transition -fall 0.1 [get_clocks "clock"]

# -----------------------------------------------------------
# 2. ASYNCHRONOUS RESET (nreset)
# -----------------------------------------------------------

# O nreset é um sinal assíncrono[cite: 8], mas precisa de constraints
# para a sincronização correta com o clock.
# O -max para Setup Time (originalmente fornecido, usado para todos os inputs)
set_input_delay -max 1.0 [get_ports "nreset"] -clock [get_clocks "clock"]
# O -min para Hold Time (adicionado para coerência)
set_input_delay -min 0.3 [get_ports "nreset"] -clock [get_clocks "clock"]

# -----------------------------------------------------------
# 3. INPUT PORTS (A, B, Handshake, Control)
# -----------------------------------------------------------

# Define os atrasos máximos (Setup Time) para todas as entradas síncronas:
# (a, b, in_valid_i, out_ready_i, signal_division)
set_input_delay -max 1.0 -clock [get_clocks "clock"] [get_ports {a b in_valid_i out_ready_i signal_division}]
# Define os atrasos mínimos (Hold Time) para todas as entradas síncronas:
set_input_delay -min 0.3 -clock [get_clocks "clock"] [get_ports {a b in_valid_i out_ready_i signal_division}]

# -----------------------------------------------------------
# 4. OUTPUT PORTS (C, R, Handshake)
# -----------------------------------------------------------

# Define os atrasos máximos (Setup Time) para todas as saídas síncronas:
# (c, r, in_ready_o, out_valid_o)
set_output_delay -max 1.0 -clock [get_clocks "clock"] [get_ports {c r in_ready_o out_valid_o}]
# Define os atrasos mínimos (Hold Time) para todas as saídas síncronas:
set_output_delay -min 0.3 -clock [get_clocks "clock"] [get_ports {c r in_ready_o out_valid_o}]

