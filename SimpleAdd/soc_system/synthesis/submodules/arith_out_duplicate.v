module arith_out_duplicate (data_in, pos_out, neg_out);

input [31:0] data_in;
output [31:0] pos_out, neg_out;


assign pos_out = data_in;
assign neg_out = data_in;

endmodule