set EntPh="Entities"

::  Analyzing files
ghdl -a %EntPh%/ula.vhd
ghdl -a %EntPh%/mux16bits.vhd
ghdl -a %EntPh%/reg8bits.vhd

::  Creating entities
ghdl -e ula
ghdl -e mux16bits
ghdl -e reg8bits