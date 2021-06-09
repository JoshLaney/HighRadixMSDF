module clock_div (clock, ctrl_a, ctrl_b, resetn);

input clock, resetn;
output ctrl_a, ctrl_b;

(* preserve="true" *) reg ctrl_a;
(* preserve="true" *) reg ctrl_b;

always@(posedge clock)begin
	ctrl_a<=~ctrl_a;
	ctrl_b<=~ctrl_b;
end

endmodule