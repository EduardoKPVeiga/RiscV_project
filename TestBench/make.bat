set utb="ula_tb"
set r16tb="reg16bits_tb"
set brtb="banco_de_regs_tb"
set GHWPh="GHW"
set TBenchPh="TestBench"

::  Analyzing files
ghdl -a %TBenchPh%/%utb%.vhd
ghdl -a %TBenchPh%/%r16tb%.vhd
ghdl -a %TBenchPh%/%brtb%.vhd

::  Creating entities
ghdl -e ula_tb
ghdl -e reg16bits_tb
ghdl -e banco_de_regs_tb

::  Deleting old ghw files
cd GHW
if exist %utb%.ghw del %utb%.ghw
if exist %r16tb%.ghw del %r16tb%.ghw
if exist %brtb%.ghw del %brtb%.ghw

::  Creating new ghw files
cd ..
ghdl  -r  ula_tb  --wave=%GHWPh%/%utb%.ghw
ghdl  -r  reg16bits_tb  --wave=%GHWPh%/%r16tb%.ghw
ghdl  -r  banco_de_regs_tb  --wave=%GHWPh%/%brtb%.ghw