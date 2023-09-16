set EntPh="Entities"

if exist work-obj93.cf del work-obj93.cf

::  Analyzing files
cd ..
ghdl -a %EntPh%/soma_subtrai.vhd
ghdl -a %EntPh%/mux2x1.vhd
ghdl -a %EntPh%/mux4x1.vhd
ghdl -a %EntPh%/mux8bits.vhd

::  Creating entities
ghdl -e soma_e_subtrai
ghdl -e mux2x1
ghdl -e mux4x1
ghdl -e mux8bits