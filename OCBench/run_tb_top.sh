#! /bin/sh

vmap altera_mf_ver /home/tjb216/altera_sim_libs/verilog_libs/altera_mf_ver && vlog +assert +cover -work work +acc=blnr -sv -noincr -timescale 1ns/1ps tb_ocbench_top.sv ocbench_top.v avalonmem_rx.v avalonmem_tx.v controlunit.v dummy_DUT.v && vopt -L altera_mf_ver -work work tb_ocbench_top -o work_opt && vsim -L altera_mf_ver -coverage work_opt -gui -msgmode both -do doit.tcl

