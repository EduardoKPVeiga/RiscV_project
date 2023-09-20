set EntPh="Entities"

::  Analyzing files
ghdl -a %EntPh%/ula.vhd

::  Creating entities
ghdl -e ula