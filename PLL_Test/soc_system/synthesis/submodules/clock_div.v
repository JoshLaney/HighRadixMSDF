module clock_div (clock, ctrl_a, ctrl_b, resetn);

input clock, resetn;
output ctrl_a, ctrl_b;

reg ctrl_a;
wire ctrl_b;

assign ctrl_b = ~ctrl_a;
always@(posedge clock)begin
	if(!resetn) ctrl_a<=1'b1;
	ctrl_a<=~ctrl_a;
end

endmodule