module clock_div (clock, clk_pos, clk_neg);

input clock;
output clk_pos, clk_neg;

(* preserve="true" *) reg clk_pos, clk_neg;


always@(posedge clock)begin
	clk_pos<=~clk_pos;
	clk_neg<=clk_pos;
end

endmodule