set ulatb="ula_tb.ghw"
set reg16bitstb="reg16bits_tb.ghw"
set GHWPh="GHW"
set TBenchPh="TestBench"

::  Analyzing files
ghdl -a %TBenchPh%/ula_tb.vhd
ghdl -a %TBenchPh%/reg16bits_tb.vhd

::  Creating entities
ghdl -e ula_tb
ghdl -e reg16bits_tb

::  Deleting old ghw files
cd GHW
if exist %ulatb% del %ulatb%
if exist %reg16bitstb% del %reg16bitstb%

::  Creating new ghw files
cd ..
ghdl  -r  ula_tb  --wave=%GHWPh%/%ulatb%
ghdl  -r  reg16bits_tb  --wave=%GHWPh%/%reg16bitstb%