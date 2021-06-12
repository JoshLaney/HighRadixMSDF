module clock_div (clock, clk_pos, clk_neg);

input clock;
output clk_pos, clk_neg;

(* preserve="true" *) reg clk_pos;
(* preserve="true" *) reg clk_neg;

always@(posedge clock)begin
	clk_pos<=clk_neg;
	clk_neg<=~clk_neg;
end

endmodule