del work-obj93.cf
ghdl -a ./soma_subtrai.vhd
ghdl -e soma_e_subtrai    
ghdl -a ./soma_subtrai_tb.vhd
ghdl -e soma_e_subtrai_tb
ghdl  -r  soma_e_subtrai_tb  --wave=soma_subtrai.ghw 
gtkwave ./soma_subtrai.ghw
