module mux_ctrl (clock, ctrl_a, ctrl_b);

input clock;
output ctrl_a, ctrl_b;

reg ctrl_a;
wire ctrl_b;

assign ctrl_b = ctrl_a;
always@(posedge clock)begin
	ctrl_a<=~ctrl_a;
end

endmodule