module arith_out_duplicate (data_in, pos_out, neg_out);
parameter IN_WIDTH = 32;
parameter OUT_WIDTH = 32;
input [IN_WIDTH-1:0] data_in;
output [OUT_WIDTH-1:0] pos_out, neg_out;


assign pos_out[IN_WIDTH-1:0] = data_in;
assign neg_out[IN_WIDTH-1:0] = data_in;

endmodule