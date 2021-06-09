module clock_div (clock, clk_neg, clk_pos, resetn);

input clock, resetn;
output clk_neg, clk_pos;

reg clk_neg;
reg clk_pos;

always@(posedge clock)begin
	if(!resetn) clk_neg<=1'b1;
	clk_neg<=~clk_neg;
	clk_pos<=clk_neg;
end

endmodule