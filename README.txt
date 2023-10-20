# RiscV_project

This is a project of a microcontroller based on RISC-V instruction set architecture

## Installation

Download the project's folder in https://github.com/EduardoKPVeiga/RiscV_project

Obs. You will need GHDL and GtkWave to run this project, available at:

https://sourceforge.net/projects/gtkwave/files/, for GtkWave
https://github.com/ghdl/ghdl/releases/, for GHDL

Use the following command to analyze and create the .ghw files

```bash
./make.bash
```

## Usage

To open the .ghw files with GtkWave, use the following command:

```bash
gtkwave .\GHW\file_name.ghw
```