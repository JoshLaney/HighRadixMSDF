
module ocbench_top
(
 // CLOCKS
 DUT_CLK,
 MEM_CLK,
 MEM_CLK_DIV2,

 // MEM_TX AVALON
 MEM_TX_AVALON_ADDRESS,   
 MEM_TX_AVALON_BYTEENABLE,
 MEM_TX_AVALON_CHIPSELECT,
 MEM_TX_AVALON_CLK,       
 MEM_TX_AVALON_CLKEN,     
 MEM_TX_AVALON_RESET,     
 MEM_TX_AVALON_RESET_REQ, 
 MEM_TX_AVALON_WRITE,     
 MEM_TX_AVALON_WRITEDATA, 

  // MEM_RX AVALON
 MEM_RX_AVALON_READDATA,  
 MEM_RX_AVALON_ADDRESS,   
 MEM_RX_AVALON_READ,
 MEM_RX_AVALON_CLK,       
 MEM_RX_AVALON_CLKEN,     
 MEM_RX_AVALON_RESET,     
 MEM_RX_AVALON_RESET_REQ, 

 // CU AVALON
 CU_AVALON_READDATA, 
 CU_AVALON_ADDRESS,  
 CU_AVALON_BYTEENABLE,
 CU_AVALON_CHIPSELECT,
 CU_AVALON_CLK,      
 CU_AVALON_CLKEN,    
 CU_AVALON_RESET,    
 CU_AVALON_RESET_REQ,
 CU_AVALON_WRITE,    
 CU_AVALON_WRITEDATA
          
);

 // CLOCKS
 input wire DUT_CLK;
 input wire MEM_CLK;
 input wire MEM_CLK_DIV2;

 // MEM_TX AVALON
 input  wire [8:0]  MEM_TX_AVALON_ADDRESS;
 input  wire [3:0]  MEM_TX_AVALON_BYTEENABLE;
 input  wire        MEM_TX_AVALON_CHIPSELECT;
 input  wire        MEM_TX_AVALON_CLK;
 input  wire        MEM_TX_AVALON_CLKEN;
 input  wire        MEM_TX_AVALON_RESET;
 input  wire        MEM_TX_AVALON_RESET_REQ;
 input  wire        MEM_TX_AVALON_WRITE;
 input  wire [31:0] MEM_TX_AVALON_WRITEDATA; 

  // MEM_RX AVALON
 output wire [31:0] MEM_RX_AVALON_READDATA;
 input  wire [8:0]  MEM_RX_AVALON_ADDRESS;
 input  wire        MEM_RX_AVALON_READ;
 input  wire        MEM_RX_AVALON_CLK;     
 input  wire        MEM_RX_AVALON_CLKEN;
 input  wire        MEM_RX_AVALON_RESET;
 input  wire        MEM_RX_AVALON_RESET_REQ;

 // CU AVALON
 output wire [31:0] CU_AVALON_READDATA; 
 input wire  [8:0]  CU_AVALON_ADDRESS;
 input wire  [3:0]  CU_AVALON_BYTEENABLE;
 input wire         CU_AVALON_CHIPSELECT;
 input wire         CU_AVALON_CLK;
 input wire         CU_AVALON_CLKEN;
 input wire         CU_AVALON_RESET;
 input wire         CU_AVALON_RESET_REQ;
 input wire         CU_AVALON_WRITE;
 input wire  [31:0] CU_AVALON_WRITEDATA;
  
  wire [31:0] mem_tx_mem_q;
  wire [8:0]  mem_tx_addr;
  wire [8:0]  mem_rx_addr;
  wire        mem_tx_wren;
  wire        mem_rx_wren;
  wire [15:0] dut_a;
  wire [15:0] dut_b;
  wire [31:0] dut_out;

  

  assign dut_a = mem_tx_mem_q[15:0];
  assign dut_b = mem_tx_mem_q[31:16];



  avalonmem_tx mem_tx (
     .AVALON_ADDRESS    (MEM_TX_AVALON_ADDRESS),
     .AVALON_BYTEENABLE (MEM_TX_AVALON_BYTEENABLE),
     .AVALON_CHIPSELECT (MEM_TX_AVALON_CHIPSELECT),
     .AVALON_CLK        (MEM_TX_AVALON_CLK),
     .AVALON_CLKEN      (MEM_TX_AVALON_CLKEN),
     .AVALON_RESET      (MEM_TX_AVALON_RESET),
     .AVALON_RESET_REQ  (MEM_TX_AVALON_RESET_REQ),
     .AVALON_WRITE      (MEM_TX_AVALON_WRITE),
     .AVALON_WRITEDATA  (MEM_TX_AVALON_WRITEDATA),
     .MEM_Q             (mem_tx_mem_q),
     .MEM_ADDR          (mem_tx_addr),
     .MEM_CLK           (MEM_CLK),
     .MEM_CLK_DIV2      (MEM_CLK_DIV2)
  );



  avalonmem_rx mem_rx (
     .AVALON_READDATA   (MEM_RX_AVALON_READDATA),
     .AVALON_ADDRESS    (MEM_RX_AVALON_ADDRESS),
     .AVALON_READ       (MEM_RX_AVALON_READ),
     .AVALON_CLK        (MEM_RX_AVALON_CLK),
     .AVALON_CLKEN      (MEM_RX_AVALON_CLKEN),
     .AVALON_RESET      (MEM_RX_AVALON_RESET),
     .AVALON_RESET_REQ  (MEM_RX_AVALON_RESET_REQ),
     .MEM_DATA          (dut_out),
     .MEM_ADDR          (mem_rx_addr),
     .MEM_CLK           (MEM_CLK),
     .MEM_CLK_DIV2      (MEM_CLK_DIV2),
     .MEM_WREN          (mem_rx_wren)
  );

  controlunit cu (

     .AVALON_READDATA   (CU_AVALON_READDATA),
     .AVALON_ADDRESS    (CU_AVALON_ADDRESS),
     .AVALON_BYTEENABLE (CU_AVALON_BYTEENABLE),
     .AVALON_CHIPSELECT (CU_AVALON_CHIPSELECT),
     .AVALON_CLK        (CU_AVALON_CLK),
     .AVALON_CLKEN      (CU_AVALON_CLKEN),
     .AVALON_RESET      (CU_AVALON_RESET),
     .AVALON_RESET_REQ  (CU_AVALON_RESET_REQ),
     .AVALON_WRITE      (CU_AVALON_WRITE),
     .AVALON_WRITEDATA  (CU_AVALON_WRITEDATA),
     .CTRL_CLK          (MEM_CLK),
     .CTRL_TX_MEMADDR   (mem_tx_addr),
     .CTRL_TX_WREN      (mem_tx_wren),
     .CTRL_RX_MEMADDR   (mem_rx_addr),
     .CTRL_RX_WREN      (mem_rx_wren)
  );

  dummy_DUT dut (
     .CLK               (DUT_CLK),
     .A                 (dut_a),
     .B                 (dut_b),
     .OUT               (dut_out)
  );




endmodule
