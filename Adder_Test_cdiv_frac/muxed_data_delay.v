module data_delay (pll_clock, data_in, data_out);

parameter WIDTH = 32;
parameter NEG = 0;
// signals for connecting to the Avalon fabric 
input pll_clock;
input [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;

(* keep *) wire [WIDTH-1:0] mux_out;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [WIDTH-1:0] data_out, data_out_old;
(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg mux_ctrl;
generate
	if(NEG==0) assign mux_out = (~mux_ctrl)? data_in : data_out_old;
	else assign mux_out = (mux_ctrl)? data_in : data_out_old;
endgenerate

always@(posedge pll_clock) begin
	mux_ctrl <= ~mux_ctrl;
	data_out <= mux_out;
	data_out_old <= data_out;
end

endmodule
