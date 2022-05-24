# RISC-V CPU

32 bit RISC-V Core

# Overview

Our own RISC-V CPU RTL design.

![RISCVcore](./img/RISCVcore.png)

# Features
not yet

# Directories

| Name                | Contents                                            |
| ------------------- | --------------------------------------------------- |
| InFetch             | Fetch module and test bench for fetching            |
| InDecode            | Decode module and test bench for decoding           |
| Execution           | Execution module and test bench for executing       |
| Memory              | Memory module and test bench for executing          |
| WB                  | Write Back module                                   |
| RISCVpipeline       | RISC-V pipelined CPU core and Test bench            |

# References

Computer Organization and Design RISC-V Edition The Hardware Software Interface by David A. Patterson, John L.Hennessy

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