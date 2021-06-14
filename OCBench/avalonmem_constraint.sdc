create_clock -period 1.666 -name memclk [get_ports {MEM_CLK}]





# Using -divide_by option
create_generated_clock \
-divide_by 2 \
-source [get_ports {MEM_CLK}] \
-name memclkdiv2 \
[get_registers {ram1p2_clk}]

create_generated_clock \
-source [get_registers {ram1p2_clk}] \
-invert \
-name memclkdiv2_inv \
[get_nets {ram2p2_clk}]


create_clock -period 10.000 -name avalonclk [get_ports {AVALON_CLK}]

create_generated_clock \
-divide_by 2 \
-source [get_ports {AVALON_CLK}] \
-name avalonclkdiv2 \
[get_registers {ram1p1_clk}]

create_generated_clock \
-source [get_registers {ram1p1_clk}] \
-invert\
-name avalonclkdiv2_inv \
[get_nets {ram2p1_clk}]

foreach_in_collection clk [get_clocks] {
puts [get_clock_info -period $clk]
}

report_clock_fmax_summary \
-stdout



