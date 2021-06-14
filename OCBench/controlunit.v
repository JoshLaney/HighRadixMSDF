


module controlunit (
   AVALON_READDATA,
   AVALON_ADDRESS,
   AVALON_BYTEENABLE,
   AVALON_CLK,
   AVALON_CHIPSELECT,
   AVALON_CLKEN,
   AVALON_RESET,
   AVALON_RESET_REQ,
   AVALON_WRITE,
   AVALON_WRITEDATA,
   CTRL_CLK,
   CTRL_TX_MEMADDR,
   CTRL_RX_MEMADDR,
   CTRL_TX_WREN,
   CTRL_RX_WREN
   //CTRL_START,
   //CTRL_READY
);

   output wire [31:0] AVALON_READDATA;
   input  wire        AVALON_ADDRESS;
   input  wire [3:0]  AVALON_BYTEENABLE;
   input  wire        AVALON_CLK;
   input  wire        AVALON_CHIPSELECT;
   input  wire        AVALON_CLKEN;
   input  wire        AVALON_RESET;
   input  wire        AVALON_RESET_REQ;
   input  wire        AVALON_WRITE;
   input  wire [31:0] AVALON_WRITEDATA;
   input  wire        CTRL_CLK;
   output wire [8:0]  CTRL_TX_MEMADDR;
   output wire [8:0]  CTRL_RX_MEMADDR;
   output wire        CTRL_TX_WREN;
   output wire        CTRL_RX_WREN;
   // temporary
   // input  wire        CTRL_START;
   // output wire        CTRL_READY;


   reg         [31:0] avalon_readdata;
   reg                avalon_address;
   reg         [3:0]  avalon_byteenable;
   reg                avalon_chipselect;
   reg                avalon_write;
   reg         [31:0] avalon_writedata;
   wire               avalon_address_c;
   wire        [3:0]  avalon_byteenable_c;
   wire               avalon_chipselect_c;
   wire               avalon_write_c;
   wire        [31:0] avalon_writedata_c;
   wire        [31:0] avalon_readdata_c;   

   reg         [8:0]  ctrl_memaddr_retard1;
   reg         [8:0]  ctrl_memaddr_retard2;
   reg         [8:0]  ctrl_memaddr_retard3;
   reg         [8:0]  ctrl_memaddr_retard4;
   reg         [8:0]  ctrl_memaddr_retard5;
   reg         [8:0]  ctrl_memaddr_retard6;
   reg         [8:0]  ctrl_memaddr_retard7;
   reg         [8:0]  ctrl_memaddr_retard8;
   reg         [8:0]  ctrl_memaddr_retard9;

   reg                ctrl_wren_retard1;
   reg                ctrl_wren_retard2;
   reg                ctrl_wren_retard3;
   reg                ctrl_wren_retard4;
   reg                ctrl_wren_retard5;
   reg                ctrl_wren_retard6;
   reg                ctrl_wren_retard7;
   reg                ctrl_wren_retard8;
   reg                ctrl_wren_retard9;
 
   reg         [8:0]  ctrl_memaddr;
   reg                ctrl_wren;
   reg                ctrl_start;
   reg                ctrl_ready;
   reg                ctrl_ack;
   reg         [2:0]  state;
   wire               ctrl_start_c;
   //wire               ctrl_ack_c;


   // I/O
   assign avalon_address_c    = AVALON_ADDRESS;
   assign avalon_byteenable_c = AVALON_BYTEENABLE;
   assign avalon_chipselect_c = AVALON_CHIPSELECT;
   assign avalon_write_c      = AVALON_WRITE;
   assign avalon_writedata_c  = AVALON_WRITEDATA;
   assign AVALON_READDATA     = avalon_readdata;


   assign avalon_readdata_c   = {31'b0, ctrl_ready};

   always @ (posedge AVALON_CLK)
   begin
      if (AVALON_RESET)
      begin
         avalon_readdata   <= 32'b0;
         avalon_address    <= 0;
         avalon_byteenable <= 4'b0;
         avalon_chipselect <= 0;
         avalon_write      <= 0;
         avalon_writedata  <= 32'b0;
      end

      avalon_readdata   <= avalon_readdata_c;
      avalon_address    <= avalon_address_c; // we can ignore address
      avalon_byteenable <= avalon_byteenable_c;
      avalon_chipselect <= avalon_chipselect_c;
      avalon_write      <= avalon_write_c;
      avalon_writedata  <= avalon_writedata_c;

   end


   
   assign CTRL_TX_MEMADDR = ctrl_memaddr;
   assign CTRL_TX_WREN    = ctrl_wren;
   assign CTRL_RX_MEMADDR = ctrl_memaddr_retard9;
   assign CTRL_RX_WREN    = ctrl_wren_retard9;
   assign ctrl_start_c = avalon_write & avalon_writedata[0];
   //assign ctrl_ack_c = avalon_write & avalon_byteenable[0] & avalon_chipselect & avalon_writedata[1];
   // LSB of control word written
   
   always @ (posedge CTRL_CLK)
   begin

      ctrl_start           <= ctrl_start_c;

      ctrl_memaddr_retard1 <= ctrl_memaddr;
      ctrl_memaddr_retard2 <= ctrl_memaddr_retard1;
      ctrl_memaddr_retard3 <= ctrl_memaddr_retard2;
      ctrl_memaddr_retard4 <= ctrl_memaddr_retard3;
      ctrl_memaddr_retard5 <= ctrl_memaddr_retard4;
      ctrl_memaddr_retard6 <= ctrl_memaddr_retard5;
      ctrl_memaddr_retard7 <= ctrl_memaddr_retard6;
      ctrl_memaddr_retard8 <= ctrl_memaddr_retard7;
      ctrl_memaddr_retard9 <= ctrl_memaddr_retard8;


      ctrl_wren_retard1    <= ctrl_wren;
      ctrl_wren_retard2    <= ctrl_wren_retard1;
      ctrl_wren_retard3    <= ctrl_wren_retard2;
      ctrl_wren_retard4    <= ctrl_wren_retard3;
      ctrl_wren_retard5    <= ctrl_wren_retard4;
      ctrl_wren_retard6    <= ctrl_wren_retard5;
      ctrl_wren_retard7    <= ctrl_wren_retard6;
      ctrl_wren_retard8    <= ctrl_wren_retard7;
      ctrl_wren_retard9    <= ctrl_wren_retard8;


      //ctrl_ack   <= ctrl_ack_c;
      // control state machine
      casex (state)
      3'b000: begin
               if (ctrl_start) state <= 3'b001;
               ctrl_ready   <= 1'b1;
               ctrl_wren    <= 1'b0;
               ctrl_memaddr <= 9'b0;
            end
      3'b001: begin
               state        <= 3'b010;
               ctrl_ready   <= 1'b0;
               ctrl_wren    <= 1'b1;
               ctrl_memaddr <= 9'b0;
            end
      3'b010: begin
               if (ctrl_memaddr == 9'b111111110) state <= 3'b000;
               ctrl_ready <= 1'b0;
               ctrl_wren  <= 1'b1;
               ctrl_memaddr <= ctrl_memaddr + 1'b1;
            end
      //3'b011: begin
      //         state <= 3'b000;
      //         ctrl_ready <= 1'b0;
      //         ctrl_wren  <= 1'b0;
      //         ctrl_memaddr <= 9'b111111111;
      //      end
      //3'b100: begin
      //         state <= 3'b000;
      //         ctrl_ready <= 1'b0;
      //         ctrl_wren  <= 1'b0;
      //         ctrl_memaddr <= 9'b111111111;
      //      end
      default: state <= 3'b000;
      endcase
   end

endmodule
   
