module clock_div (clock, clk_pos, clk_neg, resetn);

input clock, resetn;
output clk_pos, clk_neg;

(* preserve="true" *) reg clk_pos;
wire clk_neg;

assign clk_neg = ~clk_pos;
always@(posedge clock)begin
	if(~resetn) clk_pos <= 1'b0;
	else clk_pos<=~clk_pos;
end

endmodule