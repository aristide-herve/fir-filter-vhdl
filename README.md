# fir-filter-vhdl
Parallel and sequential FIR filter architectures in VHDL with timing, resource, and DSP utilization analysis.
# FIR Filter VHDL Implementation

Implementation and architectural study of a 4-tap FIR filter on Intel MAX10 FPGA.

## Filter Equation

y(n) = (7x(n) + 5x(n−1) + 3x(n−2) + x(n−3)) / 16

## Objectives

- Implement a FIR filter in VHDL
- Explore parallel and sequential architectures
- Compare resource utilization
- Evaluate timing performance
- Study DSP block utilization in Quartus

## Architectures

### Parallel Architecture

- 4 multipliers
- 3 adders
- Latency: 1 cycle

### Sequential Architecture

- 1 multiplier
- 1 adder
- FSM-controlled
- Latency: 4 cycles

## Platform

- Intel MAX10 FPGA
- Quartus Prime

## Results Summary

| Architecture | Latency | Fmax |
|-------------|----------|--------|
| Parallel | 1 cycle | ~102 MHz |
| Sequential | 4 cycles | ~106 MHz |

## Repository Structure

See the project directories for source code, simulations, Quartus projects, and reports.

## Author

Aristide-Hervé Dossou
