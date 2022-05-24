# RISCV pipeline

wired all 5 stages modules.

# Initial values in Register and Memory

x10 has 0. x1 to x6 has 2 to 7 respectively.
mem[42] = 123 and mem[50] = 321.

This is arbitary initial value for the test.

# Test Bench

in darksocv.mem,

```
0x0280A503
0x403105B3
0x00418633
0x0300A683
0x00628733
```

They means

```
lw x10, 40(x1);
sub x11, x2, x3;
add x12, x3, x4;
lw x13, 48(x1);
add x14, x5, x6;
```

respectively.
Waveform should be like below.

![tb_RISCVpipeline](../img/tb_RISCVpipeline.PNG)
