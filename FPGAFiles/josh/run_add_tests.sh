#!/bin/sh


r_prog="rR_pll_add_test_4.py"
c_prog="control_pll_add_test_4.py"

python $r_prog 2 15 10
python $r_prog 4 8 10
python $r_prog 8 5 10
python $c_prog 15 10

python $r_prog 2 31 20
python $r_prog 4 16 20
python $r_prog 8 11 20
python $c_prog 31 20

python $r_prog 2 63 40
python $r_prog 4 32 40
python $r_prog 8 21 40
python $c_prog 63 40