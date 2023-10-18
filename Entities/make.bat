set EntPh="Entities"

::  Analyzing files
ghdl -a %EntPh%/ula.vhd
ghdl -a %EntPh%/mux16bits.vhd
ghdl -a %EntPh%/reg16bits.vhd
ghdl -a %EntPh%/banco_de_regs.vhd
ghdl -a %EntPh%/top_level.vhd
ghdl -a %EntPh%/rom.vhd
ghdl -a %EntPh%/state_machine.vhd
ghdl -a %EntPh%/program_counter.vhd
ghdl -a %EntPh%/pc_sum.vhd

::  Creating entities
ghdl -e ula
ghdl -e mux16bits
ghdl -e reg16bits
ghdl -e banco_de_regs
ghdl -e top_level
ghdl -e rom
ghdl -e state_machine
ghdl -e program_counter
ghdl -e pc_sum
