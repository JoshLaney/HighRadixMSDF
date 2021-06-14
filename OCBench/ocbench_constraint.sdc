 create_clock -period 1.5 -name memclk [get_ports {MEM_CLK}]

 create_clock -period 2.000 -name dut_clk [get_ports {DUT_CLK}]

create_clock -period 10.000 -name avalonclk1 [get_ports {MEM_TX_AVALON_CLK}]

create_clock -period 10.000 -name avalonclk2 [get_ports {MEM_RX_AVALON_CLK}]


create_clock -period 10.000 -name avalonclk3 [get_ports {CU_AVALON_CLK}]

#create_clock -period 1.666 -name ctrl_clk [get_ports {CTRL_CLK}]