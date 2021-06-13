module arith_in_mux (pos_in, neg_in, q_out, mux_ctrl);
// signals for connecting to the Avalon fabric

parameter WIDTH = 30;
input mux_ctrl;
input [WIDTH-1:0] pos_in, neg_in;
output [WIDTH-1:0] q_out;


assign q_out = mux_ctrl ? neg_in[WIDTH-1:0] : pos_in[WIDTH-1:0];

endmodule