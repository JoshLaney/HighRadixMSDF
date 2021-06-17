module clocked_mux (pos_in, neg_in, q_out, clock);
// signals for connecting to the Avalon fabric

parameter WIDTH = 30;
input clock;
input [31:0] pos_in, neg_in;
output [WIDTH-1:0] q_out;

reg ctrl;

assign q_out = ctrl ? pos_in[WIDTH-1:0]: neg_in[WIDTH-1:0];

always@(posedge clock)begin
	ctrl<=~ctrl;
end

endmodule