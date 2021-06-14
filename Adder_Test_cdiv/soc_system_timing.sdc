# 50MHz board input clock
create_clock -period 20 [get_ports fpga_clk_50]
create_clock -period 40 [get_ports eth_tse_0_pcs_mac_tx_clock_connection_clk]
create_clock -period 40 [get_ports eth_tse_0_pcs_mac_rx_clock_connection_clk]
derive_pll_clocks


#create_generated_clock -name PLL_C0 -source [get_pins {soc_inst|pll_0|altera_pll_i|cyclonev_pll|inclk[0]}] [get_pins {soc_inst|pll_0|altera_pll_i|cyclonev_pll|clk[0]}]
#create_generated_clock -name PLL_C0 -source [get_pins {soc_inst|pll_0|altera_pll_i|cyclonev_pll|inclk[0]}] [get_pins {soc_inst|pll_0|altera_pll_i|cyclonev_pll|clk[1]}]
#create_generated_clock -name PLL_C2 -multiply_by 2 -source [soc_inst|pll_0|altera_pll_i|cyclonev_pll|inclk[0]}][get_pins {soc_inst|pll_0|altera_pll_i|cyclonev_pll|clk[2]}]

create_generated_clock \
-divide_by 2 \
-source {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk} \
-name clk_pos \
[get_registers soc_system:soc_inst|clock_div:clock_div_0|clk_pos]

#neg clock follows pos clock, but it's reg is clocked by the pll output there it's source is the pll
create_generated_clock \
-divide_by 2 \
-invert \
-source {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk} \
-name clk_neg \
[get_registers soc_system:soc_inst|clock_div:clock_div_0|clk_neg]

#create_generated_clock \
-source [get_registers soc_system:soc_inst|clock_div:clock_div_0|clk_pos] \
-invert \
-name clk_neg \
[get_nets *clock_div_0_clock_neg_clk]

derive_clock_uncertainty

#set_false_path -from {fpga_clk_50} -to {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[*].output_counter|divclk clk_pos clk_neg}
#set_false_path -from {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[*].output_counter|divclk  clk_pos clk_neg} -to {fpga_clk_50}
#set_false_path -from {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk} -to {soc_system:soc_inst|rRp_add:online_adder_0|x[*]}
#set_false_path -from {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk} -to {soc_system:soc_inst|rRp_add:online_adder_0|y[*]}
#set_false_path -from {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[1].output_counter|divclk} -to {soc_system:soc_inst|rRp_add:online_adder_0|x[*]}
#set_false_path -from {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[1].output_counter|divclk} -to {soc_system:soc_inst|rRp_add:online_adder_0|y[*]}
#set_false_path -from [get_keepers *ram_a*portb_we*] -to [get_keepers *ram_a*]
#set_false_path -from [get_keepers *ram_b*portb_we*] -to [get_keepers *ram_b*]
set_false_path -from [get_keepers {*ram_b*portb_we_reg}] -to [get_keepers {*data_delay_b*|data_out* *online_adder*}]
set_false_path -from [get_keepers {*ram_a*portb_we_reg}] -to [get_keepers {*data_delay_a*|data_out* *online_adder*}]
#set_false_path -from [get_keepers {*ram_c*porta_we_reg}] -to [get_clocks {*clk_pos* *clk_neg*}]

#set_max_delay -from [get_registers {soc_system:soc_inst|data_delay:data_delay_c_pos_*|data_out[*]}] -to [get_registers *] 3.5
#set_max_delay -from [get_clocks {soc_inst|pll_0|altera_pll_i|cyclonev_pll|counter[*].output_counter|divclk}] -to [get_keepers {*trace*|dcfifo*}] 2
#set_max_delay -from [get_keepers *\|gen*] -to * 2
#set_max_delay -from [get_keepers *|fclk_data_in*] -to * 2

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

# FPGA IO port constraints
set_false_path -from [get_ports {fpga_button_pio[0]}] -to *
set_false_path -from [get_ports {fpga_button_pio[1]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[0]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[1]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[2]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[3]}] -to *
set_false_path -from * -to [get_ports {fpga_led_pio[0]}]
set_false_path -from * -to [get_ports {fpga_led_pio[1]}]
set_false_path -from * -to [get_ports {fpga_led_pio[2]}]
set_false_path -from * -to [get_ports {fpga_led_pio[3]}]

# HPS peripherals port false path setting to workaround the unconstraint path (setting false_path for hps_0 ports will not affect the routing as it is hard silicon)
set_false_path -from * -to [get_ports {hps_emac1_TX_CLK}] 
set_false_path -from * -to [get_ports {hps_emac1_TXD0}] 
set_false_path -from * -to [get_ports {hps_emac1_TXD1}] 
set_false_path -from * -to [get_ports {hps_emac1_TXD2}] 
set_false_path -from * -to [get_ports {hps_emac1_TXD3}] 
set_false_path -from * -to [get_ports {hps_emac1_MDC}] 
set_false_path -from * -to [get_ports {hps_emac1_TX_CTL}] 
set_false_path -from * -to [get_ports {hps_qspi_SS0}] 
set_false_path -from * -to [get_ports {hps_qspi_CLK}] 
set_false_path -from * -to [get_ports {hps_sdio_CLK}] 
set_false_path -from * -to [get_ports {hps_usb1_STP}] 
set_false_path -from * -to [get_ports {hps_spim0_CLK}] 
set_false_path -from * -to [get_ports {hps_spim0_MOSI}] 
set_false_path -from * -to [get_ports {hps_spim0_SS0}] 
set_false_path -from * -to [get_ports {hps_uart0_TX}] 
set_false_path -from * -to [get_ports {hps_can0_TX}] 
set_false_path -from * -to [get_ports {hps_trace_CLK}] 
set_false_path -from * -to [get_ports {hps_trace_D0}] 
set_false_path -from * -to [get_ports {hps_trace_D1}] 
set_false_path -from * -to [get_ports {hps_trace_D2}] 
set_false_path -from * -to [get_ports {hps_trace_D3}] 
set_false_path -from * -to [get_ports {hps_trace_D4}] 
set_false_path -from * -to [get_ports {hps_trace_D5}] 
set_false_path -from * -to [get_ports {hps_trace_D6}] 
set_false_path -from * -to [get_ports {hps_trace_D7}] 

set_false_path -from * -to [get_ports {hps_emac1_MDIO}] 
set_false_path -from * -to [get_ports {hps_qspi_IO0}] 
set_false_path -from * -to [get_ports {hps_qspi_IO1}] 
set_false_path -from * -to [get_ports {hps_qspi_IO2}] 
set_false_path -from * -to [get_ports {hps_qspi_IO3}] 
set_false_path -from * -to [get_ports {hps_sdio_CMD}] 
set_false_path -from * -to [get_ports {hps_sdio_D0}] 
set_false_path -from * -to [get_ports {hps_sdio_D1}] 
set_false_path -from * -to [get_ports {hps_sdio_D2}] 
set_false_path -from * -to [get_ports {hps_sdio_D3}] 
set_false_path -from * -to [get_ports {hps_usb1_D0}] 
set_false_path -from * -to [get_ports {hps_usb1_D1}] 
set_false_path -from * -to [get_ports {hps_usb1_D2}] 
set_false_path -from * -to [get_ports {hps_usb1_D3}] 
set_false_path -from * -to [get_ports {hps_usb1_D4}] 
set_false_path -from * -to [get_ports {hps_usb1_D5}] 
set_false_path -from * -to [get_ports {hps_usb1_D6}] 
set_false_path -from * -to [get_ports {hps_usb1_D7}] 
set_false_path -from * -to [get_ports {hps_i2c0_SDA}] 
set_false_path -from * -to [get_ports {hps_i2c0_SCL}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO09}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO35}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO41}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO42}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO43}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO44}] 

set_false_path -from [get_ports {hps_emac1_MDIO}] -to *
set_false_path -from [get_ports {hps_qspi_IO0}] -to *
set_false_path -from [get_ports {hps_qspi_IO1}] -to *
set_false_path -from [get_ports {hps_qspi_IO2}] -to *
set_false_path -from [get_ports {hps_qspi_IO3}] -to *
set_false_path -from [get_ports {hps_sdio_CMD}] -to *
set_false_path -from [get_ports {hps_sdio_D0}] -to *
set_false_path -from [get_ports {hps_sdio_D1}] -to *
set_false_path -from [get_ports {hps_sdio_D2}] -to *
set_false_path -from [get_ports {hps_sdio_D3}] -to *
set_false_path -from [get_ports {hps_usb1_D0}] -to *
set_false_path -from [get_ports {hps_usb1_D1}] -to *
set_false_path -from [get_ports {hps_usb1_D2}] -to *
set_false_path -from [get_ports {hps_usb1_D3}] -to *
set_false_path -from [get_ports {hps_usb1_D4}] -to *
set_false_path -from [get_ports {hps_usb1_D5}] -to *
set_false_path -from [get_ports {hps_usb1_D6}] -to *
set_false_path -from [get_ports {hps_usb1_D7}] -to *
set_false_path -from [get_ports {hps_i2c0_SDA}] -to *
set_false_path -from [get_ports {hps_i2c0_SCL}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO09}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO35}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO41}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO42}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO43}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO44}] -to *

set_false_path -from [get_ports {hps_emac1_RX_CTL}] -to *
set_false_path -from [get_ports {hps_emac1_RX_CLK}] -to *
set_false_path -from [get_ports {hps_emac1_RXD0}] -to *
set_false_path -from [get_ports {hps_emac1_RXD1}] -to *
set_false_path -from [get_ports {hps_emac1_RXD2}] -to *
set_false_path -from [get_ports {hps_emac1_RXD3}] -to *
set_false_path -from [get_ports {hps_usb1_CLK}] -to *
set_false_path -from [get_ports {hps_usb1_DIR}] -to *
set_false_path -from [get_ports {hps_usb1_NXT}] -to *
set_false_path -from [get_ports {hps_spim0_MISO}] -to *
set_false_path -from [get_ports {hps_uart0_RX}] -to *
set_false_path -from [get_ports {hps_can0_RX}] -to *

# create unused clock constraint for HPS I2C and usb1 to avoid misleading unconstraint clock reporting in TimeQuest
create_clock -period "1 MHz" [get_ports hps_i2c0_SCL]
create_clock -period "48 MHz" [get_ports hps_usb1_CLK]


