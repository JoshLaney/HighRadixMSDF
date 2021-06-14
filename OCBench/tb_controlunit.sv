`timescale 1ns /1ps

module tb_controlunit;


// AVALON PORT WIRING
logic  [31:0]  avalon_readdata;
logic  [11:0]  avalon_address;
logic  [3:0]   avalon_byteenable;
logic          avalon_chipselect;
logic          avalon_clken;
logic          avalon_reset;
logic          avalon_reset_req;
logic          avalon_write;
logic  [31:0]  avalon_writedata;

// RAW MEM PORT WIRING
//logic  ctrl_start;
//logic  ctrl_ready;
logic [8:0] ctrl_memaddr;
logic  ctrl_wren;

// CLOCK LOGIC
logic          ctrl_clk = 0;
logic          avalon_clk = 0;

always #1 ctrl_clk = ~ctrl_clk;
always #2 avalon_clk = ~avalon_clk;




controlunit cu1 (
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
   .CTRL_CLK          (ctrl_clk),
   .CTRL_MEMADDR      (ctrl_memaddr),
   .CTRL_WREN         (ctrl_wren)
   //.CTRL_START        (ctrl_start),
   //.CTRL_READY        (ctrl_ready)
);


cu_test test1 (
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
   .ctrl_clk          (ctrl_clk),
   .ctrl_memaddr      (ctrl_memaddr),
   .ctrl_wren         (ctrl_wren)
   //.ctrl_start        (ctrl_start),
   //.ctrl_ready        (ctrl_ready)
);

program cu_test (
   input  logic        avalon_clk,
   input  logic [31:0] avalon_readdata,
   output logic        avalon_address,
   output logic [3:0]  avalon_byteenable,
   output logic        avalon_chipselect,
   output logic        avalon_clken,
   output logic        avalon_reset,
   output logic        avalon_reset_req,
   output logic        avalon_write,
   output logic [31:0] avalon_writedata,
   input  logic        ctrl_clk,
   input  logic [8:0]  ctrl_memaddr,
   input  logic        ctrl_wren
   //output logic        ctrl_start,
   //input  logic        ctrl_ready
);


   initial begin
      avalon_reset = 1;
      avalon_address = 0;
      avalon_byteenable = 0;
      avalon_chipselect = 0;
      avalon_clken = 0;
      avalon_reset_req = 0;
      avalon_write = 0;
      avalon_writedata = 0;
      @(posedge ctrl_clk);
      @(posedge ctrl_clk);
      avalon_reset = 0;
      avalon_address = 0;
      avalon_byteenable = 0;
      avalon_chipselect = 0;
      avalon_reset_req = 0;
      avalon_write = 0;
      avalon_writedata = 0;
      @(posedge ctrl_clk);
      avalon_reset = 0;
      avalon_address = 0;
      avalon_byteenable = 4'b0001;
      avalon_chipselect = 1'b1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'h0001;
      @(posedge ctrl_clk);
      avalon_reset = 0;
      avalon_address = 0;
      avalon_byteenable = 4'b0001;
      avalon_chipselect = 1'b0;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'h0000;
      @(posedge ctrl_clk);
      wait (avalon_clk & ~avalon_readdata[0]);
      wait (avalon_clk & avalon_readdata[0]);
      $display("test complete");
   end

endprogram

endmodule

