module clocked_mux (pos_in, neg_in, q_out, pos_clock, fast_clock);
// signals for connecting to the Avalon fabric

parameter WIDTH = 30;
input pos_clock, fast_clock;
input [WIDTH-1:0] pos_in, neg_in;
output [WIDTH-1:0] q_out;

reg ctrl;

assign q_out = ctrl ? neg_in[WIDTH-1:0] : pos_in[WIDTH-1:0];

always@(posedge fast_clock) begin
	if(posedge pos_clock) ctrl<=1'b1;
	else ctrl<=1'b0;
end

endmodule