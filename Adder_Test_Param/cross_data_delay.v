module cross_data_delay (pll_clock, div_clock, data_in, data_out);

parameter WIDTH = 32;
// signals for connecting to the Avalon fabric 
input pll_clock, div_clock;
input [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [WIDTH-1:0] data_out, data_mid;

always@(posedge pll_clock) begin
	data_mid <= data_in;
end

always@(posedge div_clock) begin
	data_out <= data_mid;
end

endmodule
