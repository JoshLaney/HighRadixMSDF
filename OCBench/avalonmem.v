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

module avalonmem (
  // AVALON PORT
  AVALON_READDATA,  
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
  MEM_BYTEEN,
  MEM_CLK,   
  MEM_CLKEN, 
  MEM_DATA,  
  MEM_WREN );

  parameter PARAM_MEM_LATENCY = 3;
  parameter ENABLE_RETIM_FLOPS = 1;

  // Avalon port
  output wire [39:0] AVALON_READDATA;
  input  wire [7:0] AVALON_ADDRESS;
  input  wire [4:0]  AVALON_BYTEENABLE;
  input  wire        AVALON_CHIPSELECT;
  input  wire        AVALON_CLK;
  input  wire        AVALON_CLKEN;
  input  wire        AVALON_RESET;
  input  wire        AVALON_RESET_REQ;
  input  wire        AVALON_WRITE;
  input  wire [39:0] AVALON_WRITEDATA;

  // Raw memory port

  output wire [39:0] MEM_Q;
  input  wire [7:0] MEM_ADDR;
  input  wire [4:0]  MEM_BYTEEN;
  input  wire        MEM_CLK;
  input  wire        MEM_CLKEN;
  input  wire [39:0] MEM_DATA;
  input  wire        MEM_WREN;  

  // CLOCKS
  reg             ram1p1_clk;
  reg             ram1p2_clk;
  wire            ram2p1_clk;
  wire            ram2p2_clk;

  reg   [39:0]    avalon_readdata;
  reg   [7:0]    avalon_address;
  reg   [4:0]     avalon_byteenable;
  reg             avalon_chipselect;
  reg             avalon_clk;
  reg             avalon_clken;
  reg             avalon_reset;
  reg             avalon_reset_req;
  reg             avalon_write;
  reg   [39:0]    avalon_writedata;


  reg [39:0] mem_q;
  reg [7:0]  mem_addr;
  reg [4:0]  mem_byteen;
  reg        mem_clken;
  reg [39:0] mem_data;
  reg        mem_wren;  

  wire [39:0] mem_q_c;
  wire [7:0]  mem_addr_c;
  wire [4:0]  mem_byteen_c;
  wire        mem_clken_c;
  wire [39:0] mem_data_c;
  wire        mem_wren_c;  
  // AVALON PORT WIRING
  wire  [39:0]    avalon_readdata_c;
  
  wire  [39:0]    ram1p1_q_c;
  wire  [6:0]    ram1p1_addr_c;
  wire  [4:0]     ram1p1_byteen_c;
  wire            ram1p1_clken_c;
  wire  [39:0]    ram1p1_data_c;
  wire            ram1p1_wren_c;  
  reg   [39:0]    ram1p1_q;
  reg   [6:0]    ram1p1_addr;
  reg   [4:0]     ram1p1_byteen;
  reg             ram1p1_clken;
  reg   [39:0]    ram1p1_data;
  reg             ram1p1_wren;  

  wire  [39:0]    ram2p1_q_c;
  wire  [6:0]    ram2p1_addr_c;
  wire  [4:0]     ram2p1_byteen_c;
  wire            ram2p1_clken_c;
  wire  [39:0]    ram2p1_data_c;
  wire            ram2p1_wren_c;  
  reg   [39:0]    ram2p1_q;
  reg   [6:0]    ram2p1_addr;
  reg   [4:0]     ram2p1_byteen;
  reg             ram2p1_clken;
  reg   [39:0]    ram2p1_data;
  reg             ram2p1_wren;  

  // RAW MEM PORT WIRING
  wire  [39:0]    ram1p2_q_c;
  wire  [6:0]    ram1p2_addr_c;
  wire  [4:0]     ram1p2_byteen_c;
  wire            ram1p2_clken_c;
  wire  [39:0]    ram1p2_data_c;
  wire            ram1p2_wren_c;  
  reg   [6:0]    ram1p2_addr;
  reg  [39:0]    ram1p2_q;
  reg   [4:0]     ram1p2_byteen;
  reg             ram1p2_clken;
  reg   [39:0]    ram1p2_data;
  reg             ram1p2_wren;  

  /*reg   [7:0]    ram1p2_addr_retim1;
  */
  reg   [39:0]    ram1p2_q_retim1;
  /*reg   [7:0]     ram1p2_byteen_retim1;
  reg             ram1p2_clken_retim1;
  reg   [39:0]    ram1p2_data_retim1;
  reg             ram1p2_wren_retim1;  
  
  reg   [7:0]    ram1p2_addr_retim2;
  */
  reg   [39:0]    ram1p2_q_retim2;
  /*reg   [7:0]     ram1p2_byteen_retim2;
  reg             ram1p2_clken_retim2;
  reg   [39:0]    ram1p2_data_retim2;
  reg             ram1p2_wren_retim2;  
  
  reg   [7:0]    ram1p2_addr_retim3;
  */
  reg   [39:0]    ram1p2_q_retim3;
  /* reg   [7:0]     ram1p2_byteen_retim3;
  reg             ram1p2_clken_retim3;
  reg   [39:0]    ram1p2_data_retim3;
  reg             ram1p2_wren_retim3;  
  */

  wire  [39:0]    ram2p2_q_c;
  wire  [6:0]    ram2p2_addr_c;
  wire  [4:0]     ram2p2_byteen_c;
  wire            ram2p2_clken_c;
  wire  [39:0]    ram2p2_data_c;
  wire            ram2p2_wren_c;  
  reg   [6:0]    ram2p2_addr;
  reg   [39:0]    ram2p2_q;
  reg   [4:0]     ram2p2_byteen;
  reg             ram2p2_clken;
  reg   [39:0]    ram2p2_data;
  reg             ram2p2_wren;  

  /*
  reg   [11:0]    ram2p2_addr_retim1;
  */
  reg   [39:0]    ram2p2_q_retim1;
  /*reg   [7:0]     ram2p2_byteen_retim1;
  reg             ram2p2_clken_retim1;
  reg   [39:0]    ram2p2_data_retim1;
  reg             ram2p2_wren_retim1;  

  reg   [11:0]    ram2p2_addr_retim2;
  */
  reg   [39:0]    ram2p2_q_retim2;
  /* reg   [7:0]     ram2p2_byteen_retim2;
  reg             ram2p2_clken_retim2;
  reg   [39:0]    ram2p2_data_retim2;
  reg             ram2p2_wren_retim2;  

  reg   [11:0]    ram2p2_addr_retim3;
  */ 
  reg   [39:0]    ram2p2_q_retim3;
  /* reg   [7:0]     ram2p2_byteen_retim3;
  reg             ram2p2_clken_retim3;
  reg   [39:0]    ram2p2_data_retim3;
  reg             ram2p2_wren_retim3;  
*/

  // read mux delay line
  //reg  [PARAM_MEM_LATENCY-1:0] avalon_mux_delay;
  //wire [PARAM_MEM_LATENCY-1:0] avalon_mux_delay_c;
  reg             avalon_mux_delay_1;
  reg             avalon_mux_delay_2;
  reg             avalon_mux_delay_3;
  reg             avalon_mux_delay_4;
  reg             avalon_mux_delay_5;
  reg             avalon_mux_delay_6;
  reg             avalon_mux_delay_7;

  assign AVALON_READDATA = avalon_readdata;
   



  // DUAL PUMP CLOCK LOGIC
  // CLOCK LOGIC
  assign ram2p1_clk = ~ram1p1_clk;
  assign ram2p2_clk = ~ram1p2_clk;

  // AVALON PORT LOGIC
  assign avalon_readdata_c = (avalon_mux_delay_3) ? ram1p1_q[39:0]: ram2p1_q[39:0];
  
  assign ram1p1_addr_c   = (avalon_address[0]) ? ram1p1_addr   : avalon_address[7:1];
  assign ram1p1_byteen_c = (avalon_address[0]) ? ram1p1_byteen : avalon_byteenable;
  assign ram1p1_clken_c  = (avalon_address[0]) ? ram1p1_clken  : (avalon_clken & ~avalon_reset_req);
  assign ram1p1_data_c   = (avalon_address[0]) ? ram1p1_data   : avalon_writedata;
  assign ram1p1_wren_c   = (avalon_address[0]) ? ram1p1_wren   : avalon_chipselect & avalon_write; // & ~avalon_reset; // & ram1_addr[0];
  
  assign ram2p1_addr_c   = (avalon_address[0]) ? avalon_address[7:1]               : ram2p1_addr;
  assign ram2p1_byteen_c = (avalon_address[0]) ? avalon_byteenable                  : ram2p1_byteen;
  assign ram2p1_clken_c  = (avalon_address[0]) ? avalon_clken & ~avalon_reset_req   : ram2p1_clken;
  assign ram2p1_data_c   = (avalon_address[0]) ? avalon_writedata                   : ram2p1_data;
  assign ram2p1_wren_c   = (avalon_address[0]) ? avalon_chipselect & avalon_write   : ram2p1_wren; // & ~avalon_reset; // & ram1_addr[0];
  

  
  always @ (posedge AVALON_CLK) begin
    if (AVALON_RESET) begin
       ram1p1_clk       <= 0;
       avalon_mux_delay_1 <= 0;
       avalon_mux_delay_2 <= 0;
       avalon_mux_delay_3 <= 0;
       avalon_mux_delay_4 <= 0;
       avalon_mux_delay_5 <= 0;   
       avalon_mux_delay_6 <= 0;   
       avalon_mux_delay_7 <= 0;   
    end
    else begin
       ram1p1_clk        <= ~ram1p1_clk;

       avalon_address    <= AVALON_ADDRESS;
       avalon_byteenable <= AVALON_BYTEENABLE;
       avalon_chipselect <= AVALON_CHIPSELECT;
       avalon_clken      <= AVALON_CLKEN;
       avalon_reset      <= AVALON_RESET;
       avalon_reset_req  <= AVALON_RESET_REQ;
       avalon_write      <= AVALON_WRITE;
       avalon_writedata  <= AVALON_WRITEDATA;
       avalon_readdata   <= avalon_readdata_c;

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


       avalon_mux_delay_1 <= (avalon_reset) ? 1'b0: avalon_address[0];
       avalon_mux_delay_2 <= avalon_mux_delay_1;
       avalon_mux_delay_3 <= avalon_mux_delay_2;
       avalon_mux_delay_4 <= avalon_mux_delay_3;
       avalon_mux_delay_5 <= avalon_mux_delay_4;
       avalon_mux_delay_6 <= avalon_mux_delay_5;
       avalon_mux_delay_7 <= avalon_mux_delay_6;
     end
  end

  
  // RAW MEM PORT LOGIC
  assign MEM_Q = mem_q;
  assign mem_q_c = (mem_addr[0]) ? ram1p2_q[39:0]: ram2p2_q[39:0];
  
  assign ram1p2_addr_c   = (mem_addr[0]) ? mem_addr[7:1] : ram1p2_addr;
  assign ram1p2_byteen_c = (mem_addr[0]) ? mem_byteen     : ram1p2_byteen;
  assign ram1p2_clken_c  = (mem_addr[0]) ? mem_clken      : ram1p2_clken;
  assign ram1p2_data_c   = (mem_addr[0]) ? mem_data       : ram1p2_data;
  assign ram1p2_wren_c   = (mem_addr[0]) ? mem_wren       : ram1p2_wren; //  & ram1_addr[0];
   
  assign ram2p2_addr_c   = (mem_addr[0]) ? ram2p2_addr    : MEM_ADDR[7:1];
  assign ram2p2_byteen_c = (mem_addr[0]) ? ram2p2_byteen  : MEM_BYTEEN;
  assign ram2p2_clken_c    = (mem_addr[0]) ? ram2p2_clken   : MEM_CLKEN;
  assign ram2p2_data_c     = (mem_addr[0]) ? ram2p2_data    : MEM_DATA;
  assign ram2p2_wren_c     = (mem_addr[0]) ? ram2p2_wren    : MEM_WREN; //  & ~ram1_addr[0];
  
  
  always @ (posedge MEM_CLK) begin
    ram1p2_clk    <= ~ram1p2_clk;
    
    // ram1p2_addr_retim1   <= ram1p2_addr_c;
    // ram1p2_addr_retim2  <= ram1p2_addr_retim1;
    // ram1p2_addr_retim3 <= ram1p2_addr_retim
    //ram1p2_addr_retim1   <= ram1p2_addr_c;
    //ram1p2_addr_retim2   <= ram1p2_addr_retim1;
    //ram1p2_addr_retim3   <= ram1p2_addr_retim2;
    ram1p2_addr          <= ram1p2_addr_c;

    //ram1p2_byteen_retim1 <= ram1p2_byteen_c;
    //ram1p2_byteen_retim2 <= ram1p2_byteen_retim1;
    //ram1p2_byteen_retim3 <= ram1p2_byteen_retim2;
    ram1p2_byteen        <= ram1p2_byteen_c;

    //ram1p2_clken_retim1  <= ram1p2_clken_c;
    //ram1p2_clken_retim2  <= ram1p2_clken_retim1;
    //ram1p2_clken_retim3  <= ram1p2_clken_retim2;
    ram1p2_clken         <= ram1p2_clken_c;

    //ram1p2_data_retim1   <= ram1p2_data_c;
    //ram1p2_data_retim2   <= ram1p2_data_retim1;
    //ram1p2_data_retim3   <= ram1p2_data_retim2;
    ram1p2_data          <= ram1p2_data_c;

    //ram1p2_wren_retim1   <= ram1p2_wren_c;
    //ram1p2_wren_retim2   <= ram1p2_wren_retim1;
    //ram1p2_wren_retim3   <= ram1p2_wren_retim2;
    ram1p2_wren          <= ram1p2_wren_c;

    //ram1p2_q_retim1      <= ram1p2_q_c;
    //ram1p2_q_retim2      <= ram1p2_q_retim1;
    //ram1p2_q_retim3      <= ram1p2_q_retim2;
    ram1p2_q             <= ram1p2_q_c;

    // ram2p2_addr_retim1   <= ram2p2_addr_c;
    // ram2p2_addr_retim2  <= ram2p2_addr_retim1;
    // ram2p2_addr_retim3 <= ram2p2_addr_retim2;

    //ram2p2_addr_retim1   <= ram2p2_addr_c;
    //ram2p2_addr_retim2   <= ram2p2_addr_retim1;
    //ram2p2_addr_retim3   <= ram2p2_addr_retim2;
    ram2p2_addr          <= ram2p2_addr_c;

    //ram2p2_byteen_retim1 <= ram2p2_byteen_c;
    //ram2p2_byteen_retim2 <= ram2p2_byteen_retim1;
    //ram2p2_byteen_retim3 <= ram2p2_byteen_retim2;
    ram2p2_byteen        <= ram2p2_byteen_c;

    //ram2p2_clken_retim1  <= ram2p2_clken_c;
    //ram2p2_clken_retim2  <= ram2p2_clken_retim1;
    //ram2p2_clken_retim3  <= ram2p2_clken_retim2;
    ram2p2_clken         <= ram2p2_clken_c;

    //ram2p2_data_retim1   <= ram2p2_data_c;
    //ram2p2_data_retim2   <= ram2p2_data_retim1;
    //ram2p2_data_retim3   <= ram2p2_data_retim2;
    ram2p2_data          <= ram2p2_data_c;

    //ram2p2_wren_retim1   <= ram2p2_wren_c;
    //ram2p2_wren_retim2   <= ram2p2_wren_retim1;
    //ram2p2_wren_retim3   <= ram2p2_wren_retim2;
    ram2p2_wren          <= ram2p2_wren_c;

    //ram2p2_q_retim1      <= ram2p2_q_c;
    //ram2p2_q_retim2      <= ram2p2_q_retim1;
    //ram2p2_q_retim3      <= ram2p2_q_retim2;
    ram2p2_q             <= ram2p2_q_c;
    

    mem_addr      <= MEM_ADDR;
    mem_byteen    <= MEM_BYTEEN;
    mem_clken     <= MEM_CLKEN;
    mem_data      <= MEM_DATA;
    mem_wren      <= MEM_WREN;
    mem_q         <= mem_q_c;





  end
  
  
  altsyncram altsyncram1
    (
      .address_a (ram1p1_addr),
      .address_b (ram1p2_addr),
      .byteena_a (ram1p1_byteen),
      .byteena_b (ram1p2_byteen),
      .clock0    (ram1p1_clk),
      .clock1    (ram1p2_clk),
      .clocken0  (1'b1),
      .clocken1  (1'b1),
      .data_a    (ram1p1_data),
      .data_b    (ram1p2_data),
      .q_a       (ram1p1_q_c),
      .q_b       (ram1p2_q_c),
      .wren_a    (ram1p1_wren),
      .wren_b    (ram1p2_wren)
    );

  defparam // altsyncram1.address_reg_a = "CLOCK0",
           altsyncram1.address_reg_b = "CLOCK1",
           altsyncram1.byte_size = 8,
	   //altsyncram1.byteena_reg_a = "CLOCK0",
           //altsyncram1.indata_reg_a = "CLOCK0",
           altsyncram1.byteena_reg_b = "CLOCK1",
           altsyncram1.indata_reg_b = "CLOCK1",
           altsyncram1.lpm_type = "altsyncram",
           altsyncram1.maximum_depth = 128,
           altsyncram1.numwords_a = 128,
           altsyncram1.numwords_b = 128,
           altsyncram1.operation_mode = "BIDIR_DUAL_PORT",
           altsyncram1.outdata_reg_a = "CLOCK0",
           altsyncram1.outdata_reg_b = "CLOCK1",
           altsyncram1.ram_block_type = "M10K",
           altsyncram1.read_during_write_mode_mixed_ports = "DONT_CARE",
           altsyncram1.width_a = 40,
           altsyncram1.width_b = 40,
           altsyncram1.width_byteena_a = 5,
           altsyncram1.width_byteena_b = 5,
           altsyncram1.widthad_a = 7,
           altsyncram1.widthad_b = 7,
           //altsyncram1.wrcontrol_wraddress_reg_a = "CLOCK0",
           altsyncram1.wrcontrol_wraddress_reg_b = "CLOCK1",
           altsyncram1.init_file = "mem1.mif";




  altsyncram altsyncram2
    (
      .address_a (ram2p1_addr),
      .address_b (ram2p2_addr),
      .byteena_a (ram2p1_byteen),
      .byteena_b (ram2p2_byteen),
      .clock0    (ram2p1_clk),
      .clock1    (ram2p2_clk),
      .clocken0  (1'b1),
      .clocken1  (1'b1),
      .data_a    (ram2p1_data),
      .data_b    (ram2p2_data),
      .q_a       (ram2p1_q_c),
      .q_b       (ram2p2_q_c),
      .wren_a    (ram2p1_wren),
      .wren_b    (ram2p2_wren)

    );

  defparam // altsyncram2.address_reg_a = "CLOCK0",
           altsyncram2.address_reg_b = "CLOCK1",
           altsyncram2.byte_size = 8,
           // altsyncram2.byteena_reg_a = "CLOCK0",
           //altsyncram2.indata_reg_a = "CLOCK0",
           altsyncram2.byteena_reg_b = "CLOCK1",
           altsyncram2.indata_reg_b = "CLOCK1",
           altsyncram2.lpm_type = "altsyncram",
           altsyncram2.maximum_depth = 128,
           altsyncram2.numwords_a = 128,
           altsyncram2.numwords_b = 128,
           altsyncram2.operation_mode = "BIDIR_DUAL_PORT",
           altsyncram2.outdata_reg_a = "CLOCK0",
           altsyncram2.outdata_reg_b = "CLOCK1",
           altsyncram2.ram_block_type = "M10K",
           altsyncram2.read_during_write_mode_mixed_ports = "DONT_CARE",
           altsyncram2.width_a = 40,
           altsyncram2.width_b = 40,
           altsyncram2.width_byteena_a = 5,
           altsyncram2.width_byteena_b = 5,
           altsyncram2.widthad_a = 7,
           altsyncram2.widthad_b = 7,
           // altsyncram2.wrcontrol_wraddress_reg_a = "CLOCK0",
           altsyncram2.wrcontrol_wraddress_reg_b = "CLOCK1",
           altsyncram2.init_file = "mem2.mif";


  //s1, which is an e_avalon_slave
  //s2, which is an e_avalon_slave

endmodule

