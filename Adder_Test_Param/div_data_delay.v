module div_data_delay (pll_clock, data_in, data_out);

parameter WIDTH = 32;
parameter NEG = 0;
// signals for connecting to the Avalon fabric 
input pll_clock;
input [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [WIDTH-1:0] data_out;
(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg clk_div;

generate
	if(NEG==0) begin
		always@(posedge clk_div) begin
			data_out <= data_in;
		end
	end
	else begin
		always@(negedge clk_div) begin
			data_out <= data_in;
		end
	end
endgenerate

always@(posedge pll_clock) begin
	clk_div <= ~clk_div;
end

endmodule
