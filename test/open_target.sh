#!/bin/bash
../build/bin/clang -c -emit-llvm align.c -menable-experimental-extensions -march=rv64gcv -target riscv64 -O3 -mllvm --riscv-v-vector-bits-min=256
../build/bin/llc -debug -march=riscv64 -mattr=experimetal-v -riscv-v-vector-bits-min=256 align.bc > riscv64.log  2>&1