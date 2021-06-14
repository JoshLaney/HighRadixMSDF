


module dummy_DUT (CLK, A, B, OUT);

   input wire          CLK;
   input wire  [15:0]  A;
   input wire  [15:0]  B;
   output wire [31:0]  OUT;



   reg [15:0] a;
   reg [15:0] b;
   reg [31:0] out;

   wire [31:0] out_c;

   assign OUT = out;
   assign out_c = {b, a};
   always @ (posedge CLK) begin
      a <= A;
      b <= B;
      out <= out_c;

   end

endmodule
