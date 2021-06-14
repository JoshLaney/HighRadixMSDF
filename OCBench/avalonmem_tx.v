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

module avalonmem_tx (
  // AVALON PORT
  AVALON_ADDRESS,   
  AVALON_BYTEENABLE,
  AVALON_CHIPSELECT,
  AVALON_CLK,
  AVALON_CLKEN,     
  AVALON_RESET,     
  AVALON_RESET_REQ, 
  AVALON_WRITE,     
  AVALON_WRITEDATA,
 // RAW MEM PORT 
  MEM_Q,     
  MEM_ADDR,  
  MEM_CLK,
  MEM_CLK_DIV2);

  parameter PARAM_MEM_LATENCY = 3;

  // Avalon port
  input  wire [8:0] AVALON_ADDRESS;
  input  wire [3:0]  AVALON_BYTEENABLE;
  input  wire        AVALON_CHIPSELECT;
  input  wire        AVALON_CLK;
  input  wire        AVALON_CLKEN;
  input  wire        AVALON_RESET;
  input  wire        AVALON_RESET_REQ;
  input  wire        AVALON_WRITE;
  input  wire [31:0] AVALON_WRITEDATA;

  // Raw memory port

  output wire [31:0] MEM_Q;
  input  wire [8:0]  MEM_ADDR;
  input  wire        MEM_CLK;
  input  wire        MEM_CLK_DIV2;
  //input  wire        MEM_CLKEN;

  // CLOCKS
  wire             ram1p1_clk;
  wire             ram1p2_clk;
  wire            ram2p1_clk;
  wire            ram2p2_clk;

  reg   [8:0]    avalon_address;
  reg   [3:0]     avalon_byteenable;
  reg             avalon_chipselect;
  reg             avalon_clk;
  reg             avalon_clken;
  reg             avalon_reset;
  reg             avalon_reset_req;
  reg             avalon_write;
  reg   [31:0]    avalon_writedata;


  reg [31:0] mem_q;
  reg [8:0]  mem_addr;
  reg        mem_clken;

  wire [31:0] mem_q_c;
  wire [8:0]  mem_addr_c;
  wire        mem_clken_c;
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

  reg mem_mux_retard1;
  reg mem_mux_retard2;
  reg mem_mux_retard3;
  reg mem_mux_retard4;
  reg mem_mux_retard5;
  reg mem_mux_retard6;
  reg mem_mux_retard7;

  // DUAL PUMP CLOCK LOGIC
  // CLOCK LOGIC
  assign ram1p1_clk = AVALON_CLK;
  assign ram2p1_clk = AVALON_CLK;
  assign ram1p2_clk = MEM_CLK_DIV2;
  assign ram2p2_clk = ~ram1p2_clk;

  // AVALON PORT LOGIC
  assign ram1p1_addr_c   = avalon_address[7:0];
  assign ram1p1_byteen_c = avalon_byteenable;
  assign ram1p1_clken_c  = (avalon_clken & ~avalon_reset_req);
  assign ram1p1_data_c   = avalon_writedata;
  assign ram1p1_wren_c   = ~avalon_address[8] & avalon_chipselect & avalon_write; // & ~avalon_reset; // & ram1_addr[0];
  
  assign ram2p1_addr_c   = avalon_address[7:0];
  assign ram2p1_byteen_c = avalon_byteenable;
  assign ram2p1_clken_c  = avalon_clken & ~avalon_reset_req;
  assign ram2p1_data_c   = avalon_writedata;
  assign ram2p1_wren_c   = avalon_address[8] & avalon_chipselect & avalon_write; // & ~avalon_reset; // & ram1_addr[0];
  

  
  always @ (posedge AVALON_CLK) begin

       avalon_address    <= AVALON_ADDRESS;
       avalon_byteenable <= AVALON_BYTEENABLE;
       avalon_chipselect <= AVALON_CHIPSELECT;
       avalon_clken      <= AVALON_CLKEN;
       avalon_reset      <= AVALON_RESET;
       avalon_reset_req  <= AVALON_RESET_REQ;
       avalon_write      <= AVALON_WRITE;
       avalon_writedata  <= AVALON_WRITEDATA;
      // avalon_readdata   <= avalon_readdata_c;

       ram1p1_addr    <= ram1p1_addr_c;
       ram1p1_byteen  <= ram1p1_byteen_c;
       ram1p1_clken   <= ram1p1_clken_c;
       ram1p1_data    <= ram1p1_data_c;
       ram1p1_wren    <= ram1p1_wren_c;
       ram1p1_q       <= ram1p1_q_c;

       ram2p1_addr    <= ram2p1_addr_c;
       ram2p1_byteen  <= ram2p1_byteen_c;
       ram2p1_clken   <= ram2p1_clken_c;
       ram2p1_data    <= ram2p1_data_c;
       ram2p1_wren    <= ram2p1_wren_c;
       ram2p1_q       <= ram2p1_q_c;

  end

  
  // RAW MEM PORT LOGIC
  assign MEM_Q = mem_q;
  
  assign mem_q_c         = (mem_mux_retard4) ? ram1p2_q[31:0] : ram2p2_q[31:0];
  assign ram1p2_addr_c   = (mem_addr[0]) ? ram1p2_addr    : mem_addr[8:1];
  assign ram2p2_addr_c   = (mem_addr[0]) ? mem_addr[8:1]  : ram2p2_addr;
  
  
  always @ (posedge MEM_CLK) begin
    ram1p2_addr   <= ram1p2_addr_c;
    //ram1p2_clken  <= ram1p2_clken_c;
    ram1p2_q      <= ram1p2_q_c;    
    ram2p2_addr   <= ram2p2_addr_c;
    //ram2p2_clken  <= ram2p2_clken_c;
    ram2p2_q      <= ram2p2_q_c;
   
    mem_addr      <= MEM_ADDR;
    //mem_clken     <= MEM_CLKEN;
    mem_q         <= mem_q_c;
    mem_mux_retard1 <= mem_addr[0];
    mem_mux_retard2 <= mem_mux_retard1;
    mem_mux_retard3 <= mem_mux_retard2;
    mem_mux_retard4 <= mem_mux_retard3;
    mem_mux_retard5 <= mem_mux_retard4;
    mem_mux_retard6 <= mem_mux_retard5;
    mem_mux_retard7 <= mem_mux_retard6;
  end
  
  
  altsyncram altsyncram1
    (
      .address_a (ram1p1_addr),
      .byteena_a (ram1p1_byteen),
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
      .byteena_a (ram2p1_byteen),
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

