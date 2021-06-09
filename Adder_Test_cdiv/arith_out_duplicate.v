module arith_out_duplicate (data_in, pos_out, neg_out);
parameter WIDTH = 32;
input [WIDTH-1:0] data_in;
output [31:0] pos_out, neg_out;


assign pos_out[WIDTH-1:0] = data_in;
assign neg_out[WIDTH-1:0] = data_in;

endmodule