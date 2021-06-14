`timescale 1ns /1ps

module tb_avalonmem_tx;


// AVALON PORT WIRING
logic  [8:0]  avalon_address;
logic  [3:0]   avalon_byteenable;
logic          avalon_chipselect;
logic          avalon_clken;
logic          avalon_reset;
logic          avalon_reset_req;
logic          avalon_write;
logic  [31:0]  avalon_writedata;

// RAW MEM PORT WIRING
logic  [31:0]  mem_q;
logic  [8:0]  mem_addr;

// CLOCK LOGIC
logic          mem_clk = 1;
logic          mem_clk_div2 = 1;
logic          avalon_clk = 1;
logic          avalon_clk_div2 = 1;

always #2 mem_clk = ~mem_clk;
always #4 mem_clk_div2 = ~mem_clk_div2;
always #10 avalon_clk = ~avalon_clk;




avalonmem_tx avalonmem1 (
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
   .MEM_CLK           (mem_clk),
   .MEM_CLK_DIV2      (mem_clk_div2)
);


mem_tx_test test1 (
   .avalon_address    (avalon_address),
   .avalon_byteenable (avalon_byteenable),
   .avalon_chipselect (avalon_chipselect),
   .avalon_clk        (avalon_clk),
   .avalon_clken      (avalon_clken),
   .avalon_reset      (avalon_reset),
   .avalon_reset_req  (avalon_reset_req),
   .avalon_write      (avalon_write),
   .avalon_writedata  (avalon_writedata),
   .mem_addr          (mem_addr),
   .mem_clk           (mem_clk),
   .mem_q             (mem_q)
);

program mem_tx_test (
   input  logic        avalon_clk,
   output logic [8:0] avalon_address,
   output logic [3:0]  avalon_byteenable,
   output logic        avalon_chipselect,
   output logic        avalon_clken,
   output logic        avalon_reset,
   output logic        avalon_reset_req,
   output logic        avalon_write,
   output logic [31:0] avalon_writedata,
   input  logic        mem_clk,
   input  logic [31:0] mem_q,
   output logic [8:0] mem_addr
);

   localparam PARAM_AVALON_LATENCY = 10;
   integer unsigned memoutput = 0;

   initial begin
      mem_addr = 0;
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
      
      avalon_reset = 0;
      avalon_address = 8'd0;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hdeadbeef;
      @(posedge avalon_clk);
      
      avalon_reset = 0;
      avalon_address = 8'd1;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hbadc0ffe;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 8'd2;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hc0ffebad;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 8'd3;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hffffffff;
      @(posedge avalon_clk);

      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      avalon_reset = 0;
      avalon_address = 8'd4;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'haaaaaaaa;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 8'd5;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hbbbbbbbb;
      @(posedge avalon_clk);
      
      avalon_reset = 0;
      avalon_address = 8'd6;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hcccccccc;
      @(posedge avalon_clk);
     
      avalon_reset = 0;
      avalon_address = 8'd7;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hdddddddd;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 8'd8;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'heeeeeeee;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 8'd9;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hffffffff;
      @(posedge avalon_clk);


      avalon_reset = 0;
      avalon_address = 8'd10;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'h00000000;
      @(posedge avalon_clk);


      avalon_reset = 0;
      avalon_address = 9'd256;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hdeadbeef;
      @(posedge avalon_clk);
      
      avalon_reset = 0;
      avalon_address = 9'd257;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hbadc0ffe;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 9'd258;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hc0ffebad;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 9'd259;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hffffffff;
      @(posedge avalon_clk);

      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge avalon_clk);
      avalon_reset = 0;
      avalon_address = 9'd260;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'haaaaaaaa;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 9'd261;
      avalon_byteenable = 4'b1111;;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hbbbbbbbb;
      @(posedge avalon_clk);
      
      avalon_reset = 0;
      avalon_address = 9'd262;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hcccccccc;
      @(posedge avalon_clk);
     
      avalon_reset = 0;
      avalon_address = 9'd262;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hdddddddd;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 9'd263;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'heeeeeeee;
      @(posedge avalon_clk);

      avalon_reset = 0;
      avalon_address = 9'd264;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'hffffffff;
      @(posedge avalon_clk);


      avalon_reset = 0;
      avalon_address = 9'd265;
      avalon_byteenable = 4'b1111;
      avalon_chipselect = 1;
      avalon_clken = 1;
      avalon_reset_req = 0;
      avalon_write = 1;
      avalon_writedata = 32'h00000000;
      @(posedge avalon_clk);
      avalon_write = 0;
      avalon_chipselect = 0;

      @(posedge avalon_clk);
      @(posedge avalon_clk);
      @(posedge mem_clk);
      

      memoutput = mem_q;
      $display("addr 0 data %0h", memoutput);
      mem_addr = 8'd1;
      @(posedge mem_clk);

      memoutput = mem_q;
      $display("addr 1 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd2;
      @(posedge mem_clk);

      memoutput = mem_q;
      $display("addr 2 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd3;
      @(posedge mem_clk);

      memoutput = mem_q;
      $display("addr 3 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd4;
      @(posedge mem_clk);

      memoutput = mem_q;
      $display("addr 4 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd5;
      @(posedge mem_clk);

      memoutput = mem_q;
      $display("addr 5 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd6;
      @(posedge mem_clk);

      memoutput = mem_q;
      $display("addr 6 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd7;
      @(posedge mem_clk);
      
      memoutput = mem_q;
      $display("addr 6 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd8;
      @(posedge mem_clk);
     
      memoutput = mem_q;
      $display("addr 6 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd9;
      @(posedge mem_clk);

      memoutput = mem_q;
      $display("addr 6 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd10;
      @(posedge mem_clk);

      memoutput = mem_q;
      $display("addr 6 data %0h", memoutput);
      avalon_reset = 0;
      mem_addr = 8'd11;
      @(posedge mem_clk);






      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      @(posedge mem_clk);
      $display("end of test");

      $stop;
   end

endprogram

endmodule

