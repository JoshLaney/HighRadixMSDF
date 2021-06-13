module arith_in_mux (pos_in, neg_in, q_out, clk_pos);
// signals for connecting to the Avalon fabric

parameter WIDTH = 30;
input clk_pos;
input [31:0] pos_in, neg_in;
output [WIDTH-1:0] q_out;


assign q_out = clk_pos ? neg_in[WIDTH-1:0] : pos_in[WIDTH-1:0];

endmodule