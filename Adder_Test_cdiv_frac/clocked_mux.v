module clocked_mux (pos_in, neg_in, q_out, clock);
// signals for connecting to the Avalon fabric

parameter WIDTH = 30;
parameter INVERT = 1;
input clock;
input [31:0] pos_in, neg_in;
output [WIDTH-1:0] q_out;

reg enable;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [WIDTH-1:0] data_mid_pos, data_mid_neg;

assign q_out = (INVERT[0]^enable) ? data_mid_pos[WIDTH-1:0]: data_mid_neg[WIDTH-1:0];

always@(posedge clock)begin
	enable<=~enable;
	if(INVERT[0]^enable) begin
		data_mid_pos <= pos_in;
	end
	if(!(INVERT[0]^enable)) begin
		data_mid_neg <= neg_in;
	end
end

endmodule