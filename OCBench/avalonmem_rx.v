// Avalon-raw dual port memory
// Based on original Altera qsys design


//Legal Notice: (C)2020 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// IGNORE THIS altera DONT message_level Level1 
// IGNORE THIS altera DONT message_off 10034 10035 10036 10037 10230 10240 10030 

module avalonmem_rx (
  // AVALON PORT
  AVALON_ADDRESS,
  AVALON_READDATA,   
  AVALON_CHIPSELECT,
  AVALON_READ,
  AVALON_CLK,       
  AVALON_CLKEN,     
  AVALON_RESET,     
  AVALON_RESET_REQ, 
 // RAW MEM PORT      
  MEM_ADDR,
  MEM_WREN,
  MEM_DATA,  
  MEM_CLK,
  MEM_CLK_DIV2);

  parameter PARAM_MEM_LATENCY = 3;

  // Avalon port
  output wire [31:0] AVALON_READDATA;
  input  wire [8:0]  AVALON_ADDRESS;
  input  wire        AVALON_CHIPSELECT;
  input  wire        AVALON_CLK;
  input  wire        AVALON_CLKEN;
  input  wire        AVALON_RESET;
  input  wire        AVALON_RESET_REQ;
  input  wire        AVALON_READ;
  // Raw memory port

  input  wire [31:0] MEM_DATA;
  input  wire [8:0]  MEM_ADDR;
  input  wire        MEM_CLK;
  input  wire        MEM_CLK_DIV2;
  input  wire        MEM_WREN;
  //input  wire        MEM_CLKEN;

  // CLOCKS
  wire            ram1p1_clk;
  wire            ram1p2_clk;
  wire            ram2p1_clk;
  wire            ram2p2_clk;

  reg   [31:0]    avalon_readdata;
  reg   [8:0]     avalon_address;
  reg             avalon_read;
  reg             avalon_chipselect;
  reg             avalon_clk;
  reg             avalon_clken;
  reg             avalon_reset;
  reg             avalon_reset_req;

  wire   [31:0]    avalon_readdata_c;
  reg [31:0] mem_data;
  reg [8:0]  mem_addr;
  reg        mem_wren;

  wire [31:0] mem_data_c;
  wire [8:0]  mem_addr_c;
  wire        mem_wren_c;
  // AVALON PORT WIRING
  wire  [31:0]    ram1p1_q_c;
  wire  [7:0]    ram1p1_addr_c;
  wire  [3:0]     ram1p1_byteen_c;
  wire            ram1p1_clken_c;
  wire  [31:0]    ram1p1_data_c;
  wire            ram1p1_wren_c;  
  reg   [31:0]    ram1p1_q;
  reg   [7:0]     ram1p1_addr;
  reg   [3:0]     ram1p1_byteen;
  reg             ram1p1_clken;
  reg   [31:0]    ram1p1_data;
  reg             ram1p1_wren;  

  wire  [31:0]    ram2p1_q_c;
  wire  [7:0]    ram2p1_addr_c;
  wire  [3:0]     ram2p1_byteen_c;
  wire            ram2p1_clken_c;
  wire  [31:0]    ram2p1_data_c;
  wire            ram2p1_wren_c;  
  reg   [31:0]    ram2p1_q;
  reg   [7:0]    ram2p1_addr;
  reg   [3:0]     ram2p1_byteen;
  reg             ram2p1_clken;
  reg   [31:0]    ram2p1_data;
  reg             ram2p1_wren;  

  // RAW MEM PORT WIRING
  wire  [31:0]    ram1p2_q_c;
  wire  [7:0]    ram1p2_addr_c;
  wire            ram1p2_clken_c;
  reg   [7:0]    ram1p2_addr;
  reg  [31:0]    ram1p2_q;
  reg             ram1p2_clken;

  wire  [31:0]    ram2p2_q_c;
  wire  [7:0]    ram2p2_addr_c;
  wire            ram2p2_clken_c;
  reg   [7:0]    ram2p2_addr;
  reg   [31:0]    ram2p2_q;
  reg             ram2p2_clken;

  // DUAL PUMP CLOCK LOGIC
  // CLOCK LOGIC
  assign ram1p1_clk = MEM_CLK_DIV2;
  assign ram2p1_clk = ~ram1p1_clk;
  assign ram1p2_clk = AVALON_CLK;
  assign ram2p2_clk = AVALON_CLK;

  reg avalon_mux_retard1;
  reg avalon_mux_retard2;
  reg avalon_mux_retard3;
  reg avalon_mux_retard4;
  reg avalon_mux_retard5;
  reg avalon_mux_retard6;
  reg avalon_mux_retard7;
  // AVALON PORT LOGIC

  assign AVALON_READDATA = avalon_readdata;

  assign avalon_readdata_c = (~avalon_mux_retard4) ? ram1p2_q : ram2p2_q;
  //assign avalon_readdata_c = ram1p2_q;

  assign ram1p2_addr_c   = avalon_address[7:0];
  assign ram1p2_clken_c  = (avalon_clken & ~avalon_reset_req);
  
  assign ram2p2_addr_c   = avalon_address[7:0];
  assign ram2p2_clken_c  = (avalon_clken & ~avalon_reset_req);

  
  always @ (posedge AVALON_CLK) begin
    if (AVALON_RESET) begin
       ram1p2_addr      <= 0;
       ram2p2_addr      <= 0;
    end
    else begin

       avalon_address    <= AVALON_ADDRESS;
       avalon_clken      <= AVALON_CLKEN;
       avalon_reset      <= AVALON_RESET;
       avalon_reset_req  <= AVALON_RESET_REQ;
       avalon_read       <= AVALON_READ;
       avalon_readdata   <= avalon_readdata_c;

       ram1p2_addr    <= ram1p2_addr_c;
       ram1p2_q       <= ram1p2_q_c;
       ram1p2_clken   <= ram1p2_clken_c;

       ram2p2_addr    <= ram2p2_addr_c;
       ram2p2_clken   <= ram2p2_clken_c;
       ram2p2_q       <= ram2p2_q_c;

       avalon_mux_retard1 <= avalon_address[8];
       avalon_mux_retard2 <= avalon_mux_retard1;
       avalon_mux_retard3 <= avalon_mux_retard2;
       avalon_mux_retard4 <= avalon_mux_retard3;
       avalon_mux_retard5 <= avalon_mux_retard4;
       avalon_mux_retard6 <= avalon_mux_retard5;
       avalon_mux_retard7 <= avalon_mux_retard6;
      

     end
  end

  
  // RAW MEM PORT LOGIC
  assign ram1p1_addr_c  = (mem_addr[0]) ? ram1p1_addr    : mem_addr[8:1];
  assign ram1p1_data_c  = (mem_addr[0]) ? ram1p1_data    : mem_data;
  assign ram1p1_wren_c  = (mem_addr[0]) ? ram1p1_wren    : mem_wren;
  
  assign ram2p1_addr_c  = (mem_addr[0]) ? mem_addr[8:1]  : ram2p1_addr;
  assign ram2p1_data_c  = (mem_addr[0]) ? mem_data       : ram2p1_data;
  assign ram2p1_wren_c  = (mem_addr[0]) ? mem_wren       : ram2p1_wren;
  
  always @ (posedge MEM_CLK) begin
    ram1p1_addr   <= ram1p1_addr_c;
    ram1p1_data   <= ram1p1_data_c;
    ram1p1_wren   <= ram1p1_wren_c;

    ram2p1_addr   <= ram2p1_addr_c;
    ram2p1_data   <= ram2p1_data_c;
    ram2p1_wren   <= ram2p1_wren_c;
   
    mem_addr      <= MEM_ADDR;
    mem_data      <= MEM_DATA;
    mem_wren      <= MEM_WREN;
  end
  
  
  altsyncram altsyncram1
    (
      .address_a (ram1p1_addr),
      .byteena_a (4'b1111),
      .clock0    (ram1p1_clk),
      .clocken0  (1'b1),
      .data_a    (ram1p1_data),
      //.q_a       (ram1p1_q_c),
      .wren_a    (ram1p1_wren),

      .q_b       (ram1p2_q_c),
      .clocken1  (1'b1),
      .address_b (ram1p2_addr),
      .clock1    (ram1p2_clk)

    );

  defparam altsyncram1.address_reg_b = "CLOCK1",
           altsyncram1.byte_size = 8,
	   //altsyncram1.byteena_reg_a = "CLOCK0",
           //altsyncram1.indata_reg_a = "CLOCK0",
           altsyncram1.lpm_type = "altsyncram",
           altsyncram1.maximum_depth = 256,
           altsyncram1.numwords_a = 256,
           altsyncram1.numwords_b = 256,
           altsyncram1.operation_mode = "DUAL_PORT",
           altsyncram1.outdata_reg_b = "CLOCK1",
           altsyncram1.ram_block_type = "M10K",
           altsyncram1.read_during_write_mode_mixed_ports = "DONT_CARE",
           altsyncram1.width_a = 32,
           altsyncram1.width_b = 32,
           altsyncram1.width_byteena_a = 4,
           altsyncram1.widthad_a = 8,
           altsyncram1.widthad_b = 8,
           //altsyncram1.wrcontrol_wraddress_reg_a = "CLOCK0",
           altsyncram1.init_file = "mem1.mif";


  altsyncram altsyncram2
    (
      .address_a (ram2p1_addr),
      .byteena_a (4'b1111),
      .clock0    (ram2p1_clk),
      .clocken0  (1'b1),
      .data_a    (ram2p1_data),
      //.q_a       (ram2p1_q_c),
      .wren_a    (ram2p1_wren),

      .clocken1  (1'b1),
      .address_b (ram2p2_addr),
      .clock1    (ram2p2_clk),
      .q_b       (ram2p2_q_c)
    );

  defparam altsyncram2.address_reg_b = "CLOCK1",
           altsyncram2.byte_size = 8,
           //altsyncram2.byteena_reg_a = "CLOCK0",
           //altsyncram2.indata_reg_a = "CLOCK0",
           altsyncram2.lpm_type = "altsyncram",
           altsyncram2.maximum_depth = 256,
           altsyncram2.numwords_a = 256,
           altsyncram2.numwords_b = 256,
           altsyncram2.operation_mode = "DUAL_PORT",
           altsyncram2.outdata_reg_b = "CLOCK1",
           altsyncram2.ram_block_type = "M10K",
           altsyncram2.read_during_write_mode_mixed_ports = "DONT_CARE",
           altsyncram2.width_a = 32,
           altsyncram2.width_b = 32,
           altsyncram2.width_byteena_a = 4,
           altsyncram2.widthad_a = 8,
           altsyncram2.widthad_b = 8,
           //altsyncram2.wrcontrol_wraddress_reg_a = "CLOCK0",
           altsyncram2.init_file = "mem2.mif";

endmodule

