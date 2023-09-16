if exist work-obj93.cf del work-obj93.cf

::  Analyzing files
ghdl -a ./soma_subtrai.vhd
ghdl -a ./mux2x1.vhd
ghdl -a ./mux4x1.vhd
ghdl -a ./mux8bits.vhd

::  Creating entities
ghdl -e soma_e_subtrai
ghdl -e mux2x1
ghdl -e mux4x1
ghdl -e mux8bits
