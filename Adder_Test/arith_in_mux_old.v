module arith_in_mux (pos_in, neg_in, q_out, pll_clock);
// signals for connecting to the Avalon fabric

parameter WIDTH = 30;
input pll_clock;
input [31:0] pos_in, neg_in;
output [WIDTH-1:0] q_out;


assign q_out = pll_clock ? neg_in[WIDTH-1:0] : pos_in[WIDTH-1:0];

endmodule