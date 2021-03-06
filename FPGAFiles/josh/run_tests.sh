#!/bin/sh

r_prog="rR_pll_add_test_4.py"
c_prog="control_pll_add_test_4.py"
r_prog_m="rR_pll_mult_test_4.py"
c_prog_m="control_pll_mult_test_4.py"
c_prog_s="control_pll_add_test_seed.py"

python $r_prog 2 15 10
python $r_prog 4 8 10
python $r_prog 8 5 10
python $c_prog 15 10
python $r_prog_m 2 7 10
python $r_prog_m 4 4 10
python $c_prog_m 7 10

python $r_prog 2 31 20
python $r_prog 4 16 20
python $r_prog 8 11 20
python $c_prog 31 20

python $r_prog 2 63 40
python $r_prog 4 32 40
python $r_prog 8 21 40
python $c_prog 63 40
python $r_prog_m 2 31 40
python $r_prog_m 4 15 40
python $c_prog_m 31 40

python $r_prog 2 127 80
python $r_prog 4 64 80
python $r_prog 8 43 80
python $c_prog 127 80
python $r_prog_m 2 63 80
python $r_prog_m 4 32 80

python $c_prog 16 10
python $c_prog 32 20
python $c_prog 64 40
python $c_prog 128 80
python $c_prog_m 8 10
python $c_prog_m 32 40
python $c_prog_m 64 80