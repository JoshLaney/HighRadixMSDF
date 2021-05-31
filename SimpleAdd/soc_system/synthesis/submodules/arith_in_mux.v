module arith_in_mux (pos_in, neg_in, q_out, pll_clock);
// signals for connecting to the Avalon fabric
input pll_clock;
input [31:0] pos_in, neg_in;
output [31:0] q_out;


assign q_out = pll_clock ? neg_in : pos_in;

endmodule