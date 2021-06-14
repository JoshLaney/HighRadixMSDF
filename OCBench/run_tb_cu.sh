#! /bin/sh

vlog +assert +cover -work work +acc=blnr -sv -noincr -timescale 1ns/1ps tb_controlunit.sv controlunit.v  && vopt -work work tb_controlunit -o work_opt && vsim -coverage work_opt -gui -msgmode both -do doit.tcl

