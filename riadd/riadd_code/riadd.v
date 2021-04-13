//generalized online adder for radix > 2

module riadd(
	x_j2,
	y_j2,
	s_j,
	clk,
	reset
);

parameter RADIX = 4;
localparam A = RADIX - 1;
localparam N = $clog2(RADIX) + 1;


input clk, reset;
input signed [(N-1):0] y_j2, x_j2;
output signed [(N-1):0] s_j;

reg signed [(N-1):0] w_j2, s_j, w_j1;
reg signed [1:0] t_j1;
wire signed [(N-1):0] s_j1;

always @(x_j2, y_j2) begin
	if(x_j2+y_j2 >= A) begin
		t_j1 <= 2'd1;
		w_j2 <= x_j2 + y_j2 - RADIX;
	end else if (x_j2+y_j2 <= -A) begin
		t_j1 <= -2'd1;
		w_j2 <= x_j2 + y_j2 + RADIX;
	end else begin
		t_j1 <= 2'd0;
		w_j2 <= x_j2 + y_j2;
	end
end

assign s_j1 = t_j1+w_j1;

always @(posedge clk or posedge reset) begin
	if(reset == 1'b1) begin
		w_j1 <= 0;
		s_j <= 0;
	end 
	else begin
		if(clk == 1'b1) begin
			w_j1 <= w_j2;
			s_j <= s_j1;
		end
	end
end

endmodule