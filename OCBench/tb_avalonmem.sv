`timescale 1ns /1ps

module tb_avalonmem;


// AVALON PORT WIRING
logic  [63:0]  avalon_readdata;
logic  [14:0]  avalon_address;
logic  [7:0]   avalon_byteenable;
logic          avalon_chipselect;
logic          avalon_clken;
logic          avalon_reset;
logic          avalon_reset_req;
logic          avalon_write;
logic  [63:0]  avalon_writedata;

// RAW MEM PORT WIRING
logic  [63:0]  mem_q;
logic  [14:0]  mem_addr;
logic  [7:0]   mem_byteen;
logic          mem_clken;
logic  [63:0]  mem_data;
logic          mem_wren;        

// CLOCK LOGIC
logic          mem_clk = 0;
logic          avalon_clk = 0;

always #10 mem_clk = ~mem_clk;
always #10 avalon_clk = ~mem_clk;




avalonmem avalonmem1 (
   .AVALON_READDATA   (avalon_readdata),
   .AVALON_ADDRESS    (avalon_address),
   .AVALON_BYTEENABLE (avalon_byteenable),
   .AVALON_CHIPSELECT (avalon_chipselect),
   .AVALON_CLK        (avalon_clk),
   .AVALON_CLKEN      (avalon_clken),
   .AVALON_RESET      (avalon_reset),
   .AVALON_RESET_REQ  (avalon_reset_req),
   .AVALON_WRITE      (avalon_write),
   .AVALON_WRITEDATA  (avalon_writedata),
   .MEM_Q             (mem_q),
   .MEM_ADDR          (mem_addr),
   .MEM_BYTEEN        (mem_byteen),
   .MEM_CLK           (mem_clk),
   .MEM_CLKEN         (mem_clken),
   .MEM_DATA          (mem_data),
   .MEM_WREN          (mem_wren)
);


mem_test test1 (
   .avalon_readdata   (avalon_readdata),
   .avalon_address    (avalon_address),
   .avalon_byteenable (avalon_byteenable),
   .avalon_chipselect (avalon_chipselect),
   .avalon_clk        (avalon_clk),
   .avalon_clken      (avalon_clken),
   .avalon_reset      (avalon_reset),
   .avalon_reset_req  (avalon_reset_req),
   .avalon_write      (avalon_write),
   .avalon_writedata  (avalon_writedata),
   .mem_q             (mem_q),
   .mem_addr          (mem_addr),
   .mem_byteen        (mem_byteen),
   .mem_clk           (mem_clk),
   .mem_clken         (mem_clken),
   .mem_data          (mem_data),
   .mem_wren          (mem_wren)
);

program mem_test (
   input  logic        avalon_clk,
   input  logic [63:0] avalon_readdata,
   output logic [14:0] avalon_address,
   output logic [7:0]  avalon_byteenable,
   output logic        avalon_chipselect,
   output logic        avalon_clken,
   output logic        avalon_reset,
   output logic        avalon_reset_req,
   output logic        avalon_write,
   output logic [63:0] avalon_writedata,
   input  logic        mem_clk,
   input  logic [63:0] mem_q,
   output logic [14:0] mem_addr,
   output logic [7:0]  mem_byteen,
   output logic        mem_clken,
   output logic [63:0] mem_data,
   output logic        mem_wren
);

   localparam PARAM_AVALON_LATENCY = 10;
   longint unsigned memoutput = 0;

   initial begin
      
      avalon_reset = 1;
      avalon_address = 0;
      avalon_byteenable = 0;
      avalon_chipselect = 0;
      avalon_clken = 0;
      avalon_reset_req = 0;
      avalon_write = 0;
      avalon_writedata = 0;
      repeat (3) begin
         @(posedge avalon_clk);
      end

    
      @(posedge avalon_clk);
      avalon_address = 0;
      avalon_reset = 0;
      avalon_clken = 1;
   
      @(posedge avalon_clk);
      avalon_address = 1;

      @(posedge avalon_clk);
      avalon_address = 2;

      @(posedge avalon_clk);
      avalon_address = 3;
  

      @(posedge avalon_clk);
      avalon_address = 4;
 
      @(posedge avalon_clk);
      avalon_address = 5;
      
      @(posedge avalon_clk);
      avalon_address = 6;
      
      @(posedge avalon_clk);
      avalon_address = 7;
     
      @(posedge avalon_clk);
      avalon_address = 3;
      @(posedge avalon_clk);
      @(posedge avalon_clk);

      avalon_address = 2;
      
      
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
 
      memoutput = avalon_readdata;
      $display("response data %0h at address %0h", avalon_readdata, avalon_address);

      $stop;
   end

endprogram

endmodule

