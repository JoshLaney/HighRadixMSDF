module data_delay_chain (pll_clock, data_in, data_out);

parameter WIDTH = 32;
parameter CHAIN = 3;
// signals for connecting to the Avalon fabric 
input pll_clock;
input [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [WIDTH-1:0] data_mid[0:CHAIN-2];
(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [WIDTH-1:0] data_out;

integer i;

always@(posedge pll_clock) begin
	data_mid[0] <= data_in;
	for(i=1; i<=CHAIN-2; i=i+1) begin
		data_mid[i] <= data_mid[i-1];
	end
	data_out <= data_mid[CHAIN-2];
end

endmodule
