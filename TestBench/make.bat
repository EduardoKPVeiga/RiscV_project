set utb="ula_tb"
set r16tb="reg16bits_tb"
set brtb="banco_de_regs_tb"
set romtb="rom_tb"
set smtb="state_machine_tb"
set pctb="program_counter_tb"
set tluctb="top_level_uc_tb"
set proc="processador_tb"
set ramtb="ram_tb"
set GHWPh="GHW"
set TBenchPh="TestBench"

::  Analyzing files
ghdl -a %TBenchPh%/%utb%.vhd
ghdl -a %TBenchPh%/%r16tb%.vhd
ghdl -a %TBenchPh%/%brtb%.vhd
ghdl -a %TBenchPh%/%romtb%.vhd
ghdl -a %TBenchPh%/%smtb%.vhd
ghdl -a %TBenchPh%/%pctb%.vhd
::ghdl -a %TBenchPh%/%tluctb%.vhd
ghdl -a %TBenchPh%/%proc%.vhd
ghdl -a %TBenchPh%/%ramtb%.vhd

::  Creating entities
ghdl -e %utb%
ghdl -e %r16tb%
ghdl -e %brtb%
ghdl -e %romtb%
ghdl -e %smtb%
ghdl -e %pctb%
::ghdl -e %tluctb%
ghdl -e %proc%
ghdl -e %ramtb%

::  Deleting old ghw files
cd GHW
if exist %utb%.ghw del %utb%.ghw
if exist %r16tb%.ghw del %r16tb%.ghw
if exist %brtb%.ghw del %brtb%.ghw
if exist %romtb%.ghw del %romtb%.ghw
if exist %smtb%.ghw del %smtb%.ghw
if exist %pctb%.ghw del %pctb%.ghw
::if exist %tluctb%.ghw del %tluctb%.ghw
if exist %proc%.ghw del %proc%.ghw
if exist %ramtb%.ghw del %ramtb%.ghw

::  Creating new ghw files
cd ..
ghdl  -r  %utb%  --wave=%GHWPh%/%utb%.ghw
ghdl  -r  %r16tb%  --wave=%GHWPh%/%r16tb%.ghw
ghdl  -r  %brtb%  --wave=%GHWPh%/%brtb%.ghw
ghdl  -r  %romtb%  --wave=%GHWPh%/%romtb%.ghw
ghdl  -r  %smtb%  --wave=%GHWPh%/%smtb%.ghw
ghdl  -r  %pctb%  --wave=%GHWPh%/%pctb%.ghw
::ghdl  -r  %tluctb%  --wave=%GHWPh%/%tluctb%.ghw
ghdl  -r  %proc%  --wave=%GHWPh%/%proc%.ghw
ghdl  -r  %ramtb%  --wave=%GHWPh%/%ramtb%.ghw