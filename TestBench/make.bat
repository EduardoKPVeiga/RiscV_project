set ulatb="ula_tb.ghw"
set GHWPh="GHW"
set TBenchPh="TestBench"

::  Analyzing files
ghdl -a %TBenchPh%/ula_tb.vhd

::  Creating entities
ghdl -e ula_tb

::  Deleting old ghw files
cd GHW
if exist %ulatb% del %ulatb%

::  Creating new ghw files
cd ..
ghdl  -r  ula_tb  --wave=%GHWPh%/%ulatb%