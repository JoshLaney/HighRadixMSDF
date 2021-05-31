module data_delay (pll_clock, data_in, data_out);

parameter WIDTH = 32;
// signals for connecting to the Avalon fabric 
input pll_clock;
input [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;

(* preserve="true" *) reg [WIDTH-1:0] data_out;

always@(posedge pll_clock) begin
	data_out <= data_in;
end

endmodule
