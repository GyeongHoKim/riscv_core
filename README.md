# RISC-V CPU

32 bit RISC-V Core

# Overview
not yet

# Features
not yet

# Directories
not yet

# How to simulate Each Verilog Modules on Mac

xilinx is not available in Mac.

## installation

to install icarus-verilog,

``` shell
brew install icarus-verilog
```

to install gtkwave,
you just google "gtkwave" and download it anyway.

## icarus-verilog

for compile verilog files, 

``` shell
iverilog -o <output file name> <module.v> <tb_module.v>
```

> you should add below codes in your testbench to make vcd files.

``` verilog
initial begin
	$dumpfile("fileName.vcd");
	$dumpvars(0,ModuleNameOfTestBench);
end
```
and then, you have to make waveform file(.vcd file).

``` shell
vvp <output file name you made above>
```

## gtkwave

just double click on your waveform file(.vcd file) you made above.