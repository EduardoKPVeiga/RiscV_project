set soma_subtrai="soma_subtrai.ghw"
set mux2x1_tb="mux2x1_tb.ghw"

::  Analyzing files
ghdl -a ./soma_subtrai_tb.vhd
ghdl -a ./mux2x1_tb.vhd

::  Creating entities
ghdl -e soma_e_subtrai_tb
ghdl -e mux2x1_tb

cd ..\GHW\

::  Deleting old ghw files
if exist %soma_subtrai% del %soma_subtrai%
if exist %mux2x1_tb% del %mux2x1_tb%

::  Creating new ghw files
ghdl  -r  soma_e_subtrai_tb  --wave=%soma_subtrai%
ghdl  -r  mux2x1_tb  --wave=%mux2x1_tb%