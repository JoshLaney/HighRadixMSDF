`timescale 1ns /1ps

module tb_avalonmem_rx;


// AVALON PORT WIRING
logic  [8:0]   avalon_address;
logic          avalon_clken;
logic          avalon_reset;
logic          avalon_reset_req;
logic  [31:0]  avalon_readdata;
// RAW MEM PORT WIRING
logic  [31:0]  mem_data;
logic  [8:0]   mem_addr;
logic          mem_wren;

// CLOCK LOGIC
logic          mem_clk = 1;
logic          mem_clk_div2 = 1;
logic          avalon_clk = 0;

always #2 mem_clk = ~mem_clk;
always #4 mem_clk_div2 = ~mem_clk_div2;
always #10 avalon_clk = ~avalon_clk;




avalonmem_rx avalonmem1 (
   .AVALON_ADDRESS    (avalon_address),
   .AVALON_READDATA   (avalon_readdata),
   .AVALON_CLK        (avalon_clk),
   .AVALON_CLKEN      (avalon_clken),
   .AVALON_RESET      (avalon_reset),
   .AVALON_RESET_REQ  (avalon_reset_req),
   .MEM_ADDR          (mem_addr),
   .MEM_CLK           (mem_clk),
   .MEM_CLK_DIV2      (mem_clk_div2),
   .MEM_WREN          (mem_wren),
   .MEM_DATA          (mem_data)
);


mem_rx_test test1 (
   .avalon_readdata   (avalon_readdata),
   .avalon_address    (avalon_address),
   .avalon_clk        (avalon_clk),
   .avalon_clken      (avalon_clken),
   .avalon_reset      (avalon_reset),
   .avalon_reset_req  (avalon_reset_req),
   .mem_addr          (mem_addr),
   .mem_clk           (mem_clk),
   .mem_data          (mem_data),
   .mem_wren          (mem_wren)
);

program mem_rx_test (
   input  logic [31:0] avalon_readdata,
   input  logic        avalon_clk,
   output logic [8:0]  avalon_address,
   output logic        avalon_clken,
   output logic        avalon_reset,
   output logic        avalon_reset_req,
   input  logic        mem_clk,
   output logic [31:0] mem_data,
   output logic [8:0]  mem_addr,
   output logic        mem_wren
);

   localparam PARAM_AVALON_LATENCY = 10;
   integer unsigned memoutput = 0;

   initial begin
      mem_addr = 0;
      mem_data = 0;
      mem_wren = 0;
      avalon_reset = 1;
      avalon_address = 0;
      avalon_clken = 0;
      avalon_reset_req = 0;


      repeat (6) begin
         @(posedge avalon_clk);
         @(posedge mem_clk);
      end
     avalon_reset = 0;
      repeat (10) begin
         @(posedge avalon_clk);
         @(posedge mem_clk);
      end
      @(posedge mem_clk);  
      

      avalon_reset = 0;
      mem_addr = 8'd0;
      mem_wren = 1'b1;
      mem_data = 32'hdeadbeef;
      @(posedge mem_clk);
      
      mem_addr = 8'd1;
      mem_wren = 1'b1;
      mem_data = 32'hbadc0ffe;
      @(posedge mem_clk);

      mem_addr = 8'd2;
      mem_wren = 1'b1;
      mem_data = 32'hc0ffebad;
      @(posedge mem_clk);

      mem_addr = 8'd3;
      mem_wren = 1'b1;
      mem_data = 32'hffffffff;
      @(posedge mem_clk);

      mem_addr = 8'd4;
      mem_wren = 1'b1;
      mem_data = 32'haaaaaaaa;
      @(posedge mem_clk);

      mem_addr = 8'd5;
      mem_wren = 1'b1;
      mem_data = 32'hbbbbbbbb;
      @(posedge mem_clk);

      mem_addr = 8'd6;
      mem_wren = 1'b1;
      mem_data = 32'hcccccccc;
      @(posedge mem_clk);

      mem_addr = 8'd7;
      mem_wren = 1'b1;
      mem_data = 32'h00000000;
      @(posedge mem_clk);
      mem_addr = 8'd0;
      mem_wren = 1'b0;
      @(posedge mem_clk);
      mem_addr = 8'd1;
      mem_wren = 1'b0;
      @(posedge mem_clk);
       
      @(posedge mem_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      avalon_address = 8'd0;

      avalon_reset = 0;
      avalon_clken = 1;
      avalon_reset_req = 0;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 0 data %0h", memoutput);
      avalon_address = 8'd1;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 1 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 8'd2;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 2 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 8'd3;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 3 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 8'd4;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 3 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 8'd4;
      @(posedge avalon_clk);
      memoutput = avalon_readdata;
      $display("addr 3 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 8'd4;
      @(posedge avalon_clk);
      memoutput = avalon_readdata;
      $display("addr 4 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 8'd5;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 5 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 8'd6;
      @(posedge avalon_clk);

      memoutput = avalon_clk;
      $display("addr 6 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 8'd7;
      @(posedge avalon_clk);
      avalon_address = 8'd8;
      @(posedge avalon_clk);



      avalon_address = 9'd256;

      avalon_reset = 0;
      avalon_clken = 1;
      avalon_reset_req = 0;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 0 data %0h", memoutput);
      avalon_address = 9'd257;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 1 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 9'd258;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 2 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 9'd259;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 3 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 9'd260;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 3 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 9'd261;
      @(posedge avalon_clk);
      memoutput = avalon_readdata;
      $display("addr 3 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 9'd262;
      @(posedge avalon_clk);
      memoutput = avalon_readdata;
      $display("addr 4 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 9'd263;
      @(posedge avalon_clk);

      memoutput = avalon_readdata;
      $display("addr 5 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 9'd264;
      @(posedge avalon_clk);

      memoutput = avalon_clk;
      $display("addr 6 data %0h", memoutput);
      avalon_reset = 0;
      avalon_address = 9'd265;
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
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      $display("end of test");

      $stop;
   end

endprogram

endmodule

