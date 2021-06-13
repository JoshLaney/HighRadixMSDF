module addr_delay (pll_clock, addr_in, addr_out, e_in, e_out);

parameter ADDR_WIDTH = 11;
// signals for connecting to the Avalon fabric 
input e_in, pll_clock;
input [ADDR_WIDTH-1:0] addr_in;
output e_out;
output [ADDR_WIDTH-1:0] addr_out;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [ADDR_WIDTH-1:0] addr_out;
(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg e_out;

always@(posedge pll_clock) begin
	addr_out <= addr_in;
	e_out <= e_in;
end

endmodule
