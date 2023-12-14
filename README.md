# Pipelined double precision( fp64 ) floating point adder

Fully functional double precision floating point adder which handles all cases including edge cases like NaN, +inf, -inf, and subnormal numbers according to the IEEE 754 standard.

## Table of Contents

- [Introduction](#introduction)
- [Our Approach](#our-approach)
- [Functional Verification](#functional-verification)
- [Synthesis reports](#synthesis-reports)
- [Usage](#usage)
- [References](#references)


## Introduction
Double-precision floating-point format (double/float64) is a floating-point number format, usually occupying 64 bits in computer memory. It represents a wide dynamic range of numeric values by using a floating radix point. The IEEE 754 standard specifies a double as having:

- Sign bit: 1 bit
- Exponent: 11 bits
- Significand precision: 52 bits

![image](https://github.com/RamaManoj/CS6320/blob/5ede2a9f49b350e0f4e48d4dac42931ed73bac3b/float64.png)

The sign bit determines the sign of the number.

The exponent field is an 11-bit unsigned integer from 0 to 2047, in biased form: an exponent value of 1023 represents the actual zero. Exponents range from −1022 to +1023 because exponents of −1023 (all 0s) and +1024 (all 1s) are reserved for special numbers. 

- A number with exponent = -1023 could represent either signed zero (or) subnormal numbers.
- A number with exponent = +1024 could represent inf (or) NaN.

The 53-bit significand precision gives from 15 to 17 significant decimal digits precision (2−53 ≈ 1.11 × 10−16). 

Except for the above exceptions, the entire double-precision number is described by:

Number = ( − 1 )<sup>sign</sup> × 2 <sup>e − 1023</sup> × 1. fraction

In the case of subnormal numbers (e = 0) the double-precision number is described by:

Number = ( − 1 )<sup>sign</sup> × 2 <sup>− 1022</sup> × 0. fraction

Floating point numbers are used extensively in various digital applications and therefore there is a need to run arithmetic on these numbers rapidly. Therefore in this project, we built a fully functional 64-bit floating point adder and made it efficient using the power of pipelining.

## Our Approach

We have divided the process of floating point addition into 4 sequential stages for the sake of pipelining namely:
- Load inputs and check for exceptional cases.
- Align the mantissas.
- Add or subtract the mantissas.
- Normalize the results and handle exceptional cases.

<p align="center">
  <img src="https://github.com/RamaManoj/CS6320/blob/5ede2a9f49b350e0f4e48d4dac42931ed73bac3b/fpadder_pipeline.png" />
</p>

### Stage-1
The goals of this stage are to:
- Extract exponent, Mantissa, Sign bit from given inputs.
- Append 1 and zero extend mantissae.
- Find the difference between exponents.
- Set all necessary special case flags: isNaN, isInfi, is_subnorm.

### Stage-2
The goals of this stage are to:
- This stage will shift the mantissa of the number with the smaller exponent to the right.
- It will return sign bits, exponent, mantissae, and flags corresponding to both inputs.

### Stage-3
The goals of this stage are to:
- Perform the addition of mantissae and return
  - the sign of the final result,
  - positive, non-normalized mantissa of the final result,
  - Exponent of result before normalization.
- If any of the special case flags are set, the result will be overwritten accordingly in 
   the order of NaN, input 1 is infinite, input 2 is infinite.

### Stage-4
The goals of this stage are to:
- Normalize the mantissa
- Set the mantissa and exponent for special cases.
- Set final output for the subnormal case.
- Enqueue the new output to output FIFO and dequeue the previous output.

We have decided to create separate modules for each stage in different files as a package. We imported other stages recursively and connected the interfaces using the feed method. For the decision of how to go about pipelining, we initially thought to go with normal mkReg registers but encountered the Pipeline FIFO in the bluespec documentation which was optimized for the use in pipelining. So we chose FIFOL as the choice of pipeline register.

For readability of code, we have defined all our custom data types in `Type_defs.bsv`. 

Also, since there are multiple files to be handled to run the simulation we have created a shell script (`compile.sh`) to run the simulation using our testbench.

## Functional Verification

To make the testbench, we first created the test cases for all usual calculations and also for all the special/edge cases like subnormal numbers, NaN, and inf. Then we stored all these test cases as array variables. Using a counter variable we defined a rule to feed input to the Stage_1 of the fpadder. The inputs, obtained result and expected result are displayed for each test case to verify functionality. The whole module was thoroughly tested for bugs and simulated through testbench.

One note to take care of is that there is an initial latency of 4 clock cycles due to pipelining and thereafter there is a new output after every clock cycle.

## Synthesis reports
We have ran the synthesis using OpenLane PD flow tool. The results of the synthesis, area and timing reports are present in the `/fpadder/reports` directory.

## Usage
We have 4 bsv files for each stage of the pipeline and a testbench to verify the functionality. We have also provided the verilog files of these bsv files which were used for area estimation in the synthesis tool.

### Steps to execute the code

To run the functional simulation for the module using the provided testbench, just execute `./compile.sh` in the terminal while in the `fpadd` directory. This command will automatically run the simulation.

## References

1. [Comparison of pipelined IEEE-754 standard floating point adder with
unpipelined adder](https://drive.google.com/file/d/1QoFRBWotnZkIy2AAeQb8t8_fQCMpxh0K/view?usp=sharing)
2. [Double-precision floating-point format](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)
