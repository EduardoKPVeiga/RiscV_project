set soma_subtrai="soma_subtrai.ghw"
set mux2x1_tb="mux2x1_tb.ghw"
set GHWPath="GHW"
set TBenchPh="TestBench"

::  Analyzing files
cd ..
ghdl -a %TBenchPh%/soma_subtrai_tb.vhd
ghdl -a %TBenchPh%/mux2x1_tb.vhd

::  Creating entities
ghdl -e soma_e_subtrai_tb
ghdl -e mux2x1_tb

::  Deleting old ghw files
cd GHW
if exist %soma_subtrai% del %soma_subtrai%
if exist %mux2x1_tb% del %mux2x1_tb%

::  Creating new ghw files
cd ..
ghdl  -r  soma_e_subtrai_tb  --wave=%GHWPath%/%soma_subtrai%
ghdl  -r  mux2x1_tb  --wave=%GHWPath%/%mux2x1_tb%