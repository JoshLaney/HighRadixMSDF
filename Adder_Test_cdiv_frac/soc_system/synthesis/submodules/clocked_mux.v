module clocked_mux (pos_in, neg_in, q_out, clock);
// signals for connecting to the Avalon fabric

parameter WIDTH = 30;
parameter INVERT = 1;
input clock;
input [31:0] pos_in, neg_in;
output [WIDTH-1:0] q_out;

reg ctrl;

assign q_out = (INVERT[0]^ctrl) ? pos_in[WIDTH-1:0]: neg_in[WIDTH-1:0];

always@(posedge clock)begin
	ctrl<=~ctrl;
end

endmodule