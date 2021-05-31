module aAddb (a, b, c, clock);
// signals for connecting to the Avalon fabric 
input [31:0] a, b;
output [31:0] c;
input clock;

(* preserve="true" *) reg [31:0] a_in, b_in, c; 
wire [31:0] c_out;


assign c_out = a_in + b_in;

always@(posedge clock) begin
	a_in <= a;
	b_in <= b;
	c <= c_out;
end

endmodule
