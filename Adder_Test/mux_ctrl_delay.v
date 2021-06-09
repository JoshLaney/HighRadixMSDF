module mux_ctrl_delay (pll_clock, ctrl_in, ctrl_out);

// signals for connecting to the Avalon fabric 
input pll_clock, ctrl_in;
output ctrl_out;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg ctrl_out;

always@(posedge pll_clock) begin
	ctrl_out <= ctrl_in;
end

endmodule
