module mc_data_delay (pll_clock, div_clock, data_in, data_out);

parameter WIDTH = 32;
parameter INVERT = 1;
// signals for connecting to the Avalon fabric 
input pll_clock, div_clock;
input [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [WIDTH-1:0] data_out, data_mid_fast, data_mid_slow;
(* preserve="true" *) reg enable;

always@(posedge pll_clock) begin
	enable <= ~enable;
	data_mid_fast <= data_in;
	if(INVERT[0]^enable) begin
		data_mid_slow <= data_mid_fast;
	end
end

always@(posedge div_clock) begin
	data_out <= data_mid_slow;
end

endmodule
