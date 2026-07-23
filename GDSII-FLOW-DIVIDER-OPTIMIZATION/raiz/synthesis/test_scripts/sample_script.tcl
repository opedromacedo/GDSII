# A sample script to run the ATPG flow in Modus Test
# 1. Carrega a descrição do hardware (netlist) e as bibliotecas de tecnologia para iniciar o ambiente de trabalho.
# build_model <workdir | directory> -designsource <netlist> -techlib <files or directories> -designtop <top_level_cell>
# # 2. Define e configura o modo de teste a ser utilizado (ex: Scan), incluindo pinos e configurações de clock.
# build_testmode <workdir | directory> -testmode <name> -assignfile <filename>
# # 3. Realiza uma checagem formal para garantir que as estruturas de teste (ex: cadeias de scan) estão corretamente conectadas e operacionais.
# verify_test_structures <workdir | directory> -testmode <name>
# # 4. Gera relatórios detalhados sobre as estruturas de teste verificadas, como o tamanho das cadeias de scan e a cobertura.
# report_test_structures <workdir | directory> -testmode <name>
# # 5. Cria o modelo de falhas que o ATPG tentará detectar (ex: falhas Stuck-At).
# build_faultmodel <workdir | directory> -fullfault yes|no
# # 6. Gera padrões de teste específicos para verificar a integridade e a correta operação das cadeias de scan.
# create_scanchain_tests <workdir | directory> -testmode <testmode> -experiment <exp_name>
# # 7. Gera os padrões de teste (vetores) para maximizar a detecção das falhas definidas no design (lógica funcional).
# create_logic_tests <workdir | directory> -testmode <testmode> -experiment <exp_name> -effort low|high
# # 8. Salva os padrões de teste gerados (os vetores) no formato especificado (STIL, Verilog, etc.) para serem usados por um simulador ou equipamento de teste.
# write_vectors <workdir | directory> -testmode <testmode> [-inexperiment <exp_name>] [-language <stil|wgl|verilog|tdl>] [-scanformat serial|parallel] -outputfilename <string>

# Cadence Modus
# Cadence(R) Modus(TM) DFT Software Solution

build_model -workdir mydir \
  -designsource opdiv_correct_netlist_dft.v \
  -techlib ../../lib/slow_vdd1v0_basiccells.v \
  -designtop opdiv

build_testmode -workdir mydir \
  -testmode FULLSCAN \
  -assignfile opdiv.FULLSCAN.pinassign

verify_test_structures -workdir mydir -testmode FULLSCAN
report_test_structures -workdir mydir -testmode FULLSCAN

build_faultmodel -workdir mydir -fullfault yes

create_scanchain_tests -workdir mydir -testmode FULLSCAN -experiment scan
create_logic_tests -workdir mydir -testmode FULLSCAN -experiment logic -effort high

write_vectors -workdir mydir \
  -testmode FULLSCAN \
  -inexperiment logic \
  -language verilog \
  -scanformat serial \
  -outputfilename test_results
