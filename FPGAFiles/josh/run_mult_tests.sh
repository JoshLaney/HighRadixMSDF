#!/bin/sh


r_prog="rR_pll_mult_test_4.py"
c_prog="control_pll_add_test_4.py"

python $r_prog 2 7 10
python $r_prog 4 4 10
python $c_prog 7 10

python $r_prog 2 31 40
python $r_prog 4 15 40
python $c_prog 31 40