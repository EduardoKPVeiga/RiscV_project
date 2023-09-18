set EntPh="Entities"

::  Analyzing files
ghdl -a %EntPh%/mux16bits.vhd
ghdl -a %EntPh%/ula.vhd

::  Creating entities
ghdl -e ula
ghdl -e mux16bits