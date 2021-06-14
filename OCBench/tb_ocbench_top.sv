`timescale 1ns /1ps

module tb_ocbench_top;


// AVALON PORT WIRING
logic  [8:0]   mem_tx_avalon_address;
logic  [3:0]   mem_tx_avalon_byteenable;
logic          mem_tx_avalon_chipselect;
logic          mem_tx_avalon_clken;
logic          mem_tx_avalon_reset;
logic          mem_tx_avalon_reset_req;
logic          mem_tx_avalon_write;
logic  [31:0]  mem_tx_avalon_writedata;
logic  [31:0]  mem_rx_avalon_readdata;
logic  [8:0]   mem_rx_avalon_address;
logic          mem_rx_avalon_chipselect;
logic          mem_rx_avalon_clken;
logic          mem_rx_avalon_reset;
logic          mem_rx_avalon_reset_req;
logic  [31:0]  cu_avalon_readdata;
logic  [8:0]   cu_avalon_address;
logic  [3:0]   cu_avalon_byteenable;
logic          cu_avalon_chipselect;
logic          cu_avalon_clken;
logic          cu_avalon_reset;
logic          cu_avalon_reset_req;
logic          cu_avalon_write;
logic  [31:0]  cu_avalon_writedata;        

// CLOCK LOGIC
logic          mem_tx_avalon_clk = 1;
logic          mem_tx_avalon_clk_div2 = 1;
logic          mem_rx_avalon_clk;
logic          mem_rx_avalon_clk_div2;
logic          cu_avalon_clk = 1;
logic          mem_clk = 1;
logic          mem_clk_div2 = 1;
logic          dut_clk;

assign dut_clk = mem_clk;
assign mem_rx_avalon_clk = mem_tx_avalon_clk;
assign mem_rx_avalon_clk_div2 = mem_tx_avalon_clk_div2;

always #2 mem_clk = ~mem_clk;
always #4 mem_clk_div2 = ~mem_clk_div2;

always #10 mem_tx_avalon_clk = ~mem_tx_avalon_clk;
always #20 mem_tx_avalon_clk_div2 = ~mem_tx_avalon_clk_div2;
always #10 cu_avalon_clk = ~cu_avalon_clk;




ocbench_top toplevel (
   .DUT_CLK                  (dut_clk),
   .MEM_CLK                  (mem_clk),
   .MEM_CLK_DIV2             (mem_clk_div2),
   .MEM_TX_AVALON_ADDRESS    (mem_tx_avalon_address),
   .MEM_TX_AVALON_BYTEENABLE (mem_tx_avalon_byteenable),
   .MEM_TX_AVALON_CHIPSELECT (mem_tx_avalon_chipselect),
   .MEM_TX_AVALON_CLK        (mem_tx_avalon_clk),
   .MEM_TX_AVALON_CLK_DIV2   (mem_tx_avalon_clk_div2),
   .MEM_TX_AVALON_CLKEN      (mem_tx_avalon_clken),
   .MEM_TX_AVALON_RESET      (mem_tx_avalon_reset),
   .MEM_TX_AVALON_RESET_REQ  (mem_tx_avalon_reset_req),
   .MEM_TX_AVALON_WRITE      (mem_tx_avalon_write),
   .MEM_TX_AVALON_WRITEDATA  (mem_tx_avalon_writedata),
   .MEM_RX_AVALON_READDATA   (mem_rx_avalon_readdata),
   .MEM_RX_AVALON_ADDRESS    (mem_rx_avalon_address),
   .MEM_RX_AVALON_CLK        (mem_rx_avalon_clk),
   .MEM_RX_AVALON_CLK_DIV2   (mem_rx_avalon_clk_div2),
   .MEM_RX_AVALON_CLKEN      (mem_rx_avalon_clken),
   .MEM_RX_AVALON_RESET      (mem_rx_avalon_reset),
   .MEM_RX_AVALON_RESET_REQ  (mem_rx_avalon_reset_req),
   .CU_AVALON_READDATA       (cu_avalon_readdata),
   .CU_AVALON_ADDRESS        (cu_avalon_address),
   .CU_AVALON_BYTEENABLE     (cu_avalon_byteenable),
   .CU_AVALON_CHIPSELECT     (cu_avalon_chipselect),
   .CU_AVALON_CLK            (cu_avalon_clk),
   .CU_AVALON_CLKEN          (cu_avalon_clken),
   .CU_AVALON_RESET          (cu_avalon_reset),
   .CU_AVALON_RESET_REQ      (cu_avalon_reset_req),
   .CU_AVALON_WRITE          (cu_avalon_write),
   .CU_AVALON_WRITEDATA      (cu_avalon_writedata)         
);


ocbench_test test1 (
  .mem_tx_avalon_address          (mem_tx_avalon_address),
  .mem_tx_avalon_byteenable       (mem_tx_avalon_byteenable),
  .mem_tx_avalon_chipselect       (mem_tx_avalon_chipselect),
  .mem_tx_avalon_clken            (mem_tx_avalon_clken),
  .mem_tx_avalon_reset            (mem_tx_avalon_reset),
  .mem_tx_avalon_reset_req        (mem_tx_avalon_reset_req),
  .mem_tx_avalon_write            (mem_tx_avalon_write),
  .mem_tx_avalon_writedata        (mem_tx_avalon_writedata),
  .mem_rx_avalon_readdata         (mem_rx_avalon_readdata),
  .mem_rx_avalon_address          (mem_rx_avalon_address),
  .mem_rx_avalon_clken            (mem_rx_avalon_clken),
  .mem_rx_avalon_reset            (mem_rx_avalon_reset),
  .mem_rx_avalon_reset_req        (mem_rx_avalon_reset_req),
  .cu_avalon_readdata             (cu_avalon_readdata),
  .cu_avalon_address              (cu_avalon_address),
  .cu_avalon_byteenable           (cu_avalon_byteenable),
  .cu_avalon_chipselect           (cu_avalon_chipselect),
  .cu_avalon_clken                (cu_avalon_clken),
  .cu_avalon_reset                (cu_avalon_reset),
  .cu_avalon_reset_req            (cu_avalon_reset_req),
  .cu_avalon_write                (cu_avalon_write),
  .cu_avalon_writedata            (cu_avalon_writedata)     
);

program ocbench_test (
   output logic  [8:0]   mem_tx_avalon_address,
   output logic  [3:0]   mem_tx_avalon_byteenable,
   output logic          mem_tx_avalon_chipselect,
   output logic          mem_tx_avalon_clken,
   output logic          mem_tx_avalon_reset,
   output logic          mem_tx_avalon_reset_req,
   output logic          mem_tx_avalon_write,
   output logic  [31:0]  mem_tx_avalon_writedata,
   input  logic  [31:0]  mem_rx_avalon_readdata,
   output logic  [8:0]   mem_rx_avalon_address,
   output logic          mem_rx_avalon_clken,
   output logic          mem_rx_avalon_reset,
   output logic          mem_rx_avalon_reset_req,
   input  logic  [31:0]  cu_avalon_readdata,
   output logic  [8:0]   cu_avalon_address,
   output logic  [3:0]   cu_avalon_byteenable,
   output logic          cu_avalon_chipselect,
   output logic          cu_avalon_clken,
   output logic          cu_avalon_reset,
   output logic          cu_avalon_reset_req,
   output logic          cu_avalon_write,
   output logic  [31:0]  cu_avalon_writedata        
);

   integer unsigned memoutput = 0;

   initial begin

      // RESET
      mem_tx_avalon_reset = 1;
      mem_rx_avalon_reset = 1;
      cu_avalon_reset = 1;
 
      mem_tx_avalon_address = 0;
      mem_tx_avalon_byteenable = 0;
      mem_tx_avalon_chipselect = 0;
      mem_tx_avalon_clken = 0;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 0;
      mem_tx_avalon_writedata = 0;
      
      mem_rx_avalon_address = 0;
      mem_rx_avalon_chipselect = 0;
      mem_rx_avalon_clken = 0;
      mem_rx_avalon_reset_req = 0;      
      repeat (3) begin
         @(posedge mem_tx_avalon_clk);
         @(posedge cu_avalon_clk);
      end
      mem_tx_avalon_reset = 0;
      mem_rx_avalon_reset = 0;
      cu_avalon_reset = 0;

      @(posedge mem_tx_avalon_clk);  
      @(posedge cu_avalon_clk);

      // AVALON WRITE
      @(posedge mem_tx_avalon_clk);
      mem_tx_avalon_address = 8'd0;
      mem_tx_avalon_byteenable = 4'b1111;;
      mem_tx_avalon_chipselect = 1;
      mem_tx_avalon_clken = 1;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 1;
      mem_tx_avalon_writedata = 32'hdeadbeef;
      @(posedge mem_tx_avalon_clk);
      
      mem_tx_avalon_reset = 0;
      mem_tx_avalon_address = 8'd1;
      mem_tx_avalon_byteenable = 4'b1111;;
      mem_tx_avalon_chipselect = 1;
      mem_tx_avalon_clken = 1;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 1;
      mem_tx_avalon_writedata = 32'hbadc0ffe;
      @(posedge mem_tx_avalon_clk);

      mem_tx_avalon_reset = 0;
      mem_tx_avalon_address = 8'd2;
      mem_tx_avalon_byteenable = 4'b1111;;
      mem_tx_avalon_chipselect = 1;
      mem_tx_avalon_clken = 1;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 1;
      mem_tx_avalon_writedata = 32'hc0ffebad;
      @(posedge mem_tx_avalon_clk);

      mem_tx_avalon_reset = 0;
      mem_tx_avalon_address = 8'd3;
      mem_tx_avalon_byteenable = 4'b1111;;
      mem_tx_avalon_chipselect = 1;
      mem_tx_avalon_clken = 1;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 1;
      mem_tx_avalon_writedata = 32'hffffffff;
      @(posedge mem_tx_avalon_clk);
      
      mem_tx_avalon_reset = 0;
      mem_tx_avalon_address = 8'd4;
      mem_tx_avalon_byteenable = 4'b1111;;
      mem_tx_avalon_chipselect = 1;
      mem_tx_avalon_clken = 1;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 1;
      mem_tx_avalon_writedata = 32'haaaaaaaa;
      @(posedge mem_tx_avalon_clk);

      mem_tx_avalon_reset = 0;
      mem_tx_avalon_address = 8'd5;
      mem_tx_avalon_byteenable = 4'b1111;;
      mem_tx_avalon_chipselect = 1;
      mem_tx_avalon_clken = 1;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 1;
      mem_tx_avalon_writedata = 32'hbbbbbbbb;
      @(posedge mem_tx_avalon_clk);
      
      mem_tx_avalon_reset = 0;
      mem_tx_avalon_address = 8'd6;
      mem_tx_avalon_byteenable = 4'b1111;
      mem_tx_avalon_chipselect = 1;
      mem_tx_avalon_clken = 1;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 1;
      mem_tx_avalon_writedata = 32'hcccccccc;
      @(posedge mem_tx_avalon_clk);
     
      mem_tx_avalon_reset = 0;
      mem_tx_avalon_address = 8'd7;
      mem_tx_avalon_byteenable = 4'b1111;
      mem_tx_avalon_chipselect = 1;
      mem_tx_avalon_clken = 1;
      mem_tx_avalon_reset_req = 0;
      mem_tx_avalon_write = 1;
      mem_tx_avalon_writedata = 32'h00000000;
      @(posedge mem_tx_avalon_clk);
      mem_tx_avalon_write = 0;
      mem_tx_avalon_chipselect = 0;
      @(posedge mem_tx_avalon_clk);
      @(posedge mem_tx_avalon_clk);
      



      // INTERNAL TRANSFER TEST
      @(posedge cu_avalon_clk);
      cu_avalon_reset = 0;
      cu_avalon_address = 0;
      cu_avalon_byteenable = 4'b0001;
      cu_avalon_chipselect = 1;
      cu_avalon_clken = 1;
      cu_avalon_reset_req = 0;
      cu_avalon_write = 1;
      cu_avalon_writedata = 32'h00000001;
      @(posedge cu_avalon_clk);
      @(posedge cu_avalon_clk);


      cu_avalon_write = 1;
      cu_avalon_writedata = 32'h00000000;

      @(posedge cu_avalon_clk);

      cu_avalon_write = 0;

      @(posedge cu_avalon_clk);

      wait(cu_avalon_readdata == 32'h00000001);
      @(posedge cu_avalon_clk);


      // RX READOUT TEST

      @(posedge mem_rx_avalon_clk);
      mem_rx_avalon_address = 8'd0;

      mem_rx_avalon_reset = 0;
      mem_rx_avalon_clken = 1;
      mem_rx_avalon_reset_req = 0;
      @(posedge mem_rx_avalon_clk);

      memoutput = mem_rx_avalon_readdata;
      $display("addr 0 data %0h", memoutput);
      mem_rx_avalon_address = 8'd1;
      @(posedge mem_rx_avalon_clk);

      memoutput = mem_rx_avalon_readdata;
      $display("addr 1 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd2;
      @(posedge mem_rx_avalon_clk);

      memoutput = mem_rx_avalon_readdata;
      $display("addr 2 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd3;
      @(posedge mem_rx_avalon_clk);

      memoutput = mem_rx_avalon_readdata;
      $display("addr 3 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd4;
      @(posedge mem_rx_avalon_clk);

      memoutput = mem_rx_avalon_readdata;
      $display("addr 4 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd5;
      @(posedge mem_rx_avalon_clk);

      memoutput = mem_rx_avalon_readdata;
      $display("addr 5 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd6;
      @(posedge mem_rx_avalon_clk);

      memoutput = mem_rx_avalon_clk;
      $display("addr 6 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd7;
      @(posedge mem_rx_avalon_clk);
      
      memoutput = mem_rx_avalon_clk;
      $display("addr 6 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd8;
      @(posedge mem_rx_avalon_clk);
      
      memoutput = mem_rx_avalon_clk;
      $display("addr 6 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd9;
      @(posedge mem_rx_avalon_clk);
      
      memoutput = mem_rx_avalon_clk;
      $display("addr 6 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd10;
      @(posedge mem_rx_avalon_clk);
      
      memoutput = mem_rx_avalon_clk;
      $display("addr 6 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd11;
      @(posedge mem_rx_avalon_clk);

      memoutput = mem_rx_avalon_clk;
      $display("addr 6 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd12;
      @(posedge mem_rx_avalon_clk);


      memoutput = mem_rx_avalon_clk;
      $display("addr 6 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd13;
      @(posedge mem_rx_avalon_clk);


      memoutput = mem_rx_avalon_clk;
      $display("addr 6 data %0h", memoutput);
      mem_rx_avalon_reset = 0;
      mem_rx_avalon_address = 8'd14;
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      @(posedge mem_rx_avalon_clk);
      $display("end of test");

      $stop;
   end

endprogram

endmodule

