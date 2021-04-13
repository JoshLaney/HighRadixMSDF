module r2add(
	x_j3,
	y_j3,
	s_j,
	clk,
	reset
);

input clk, reset;
input signed [1:0] y_j3, x_j3;
output signed [1:0] s_j;

wire signed [1:0] z_j3, t_j1, s_j1, w_j2, h_j2;

reg signed [1:0] z_j2, s_j, w_j1;

assign h_j2 = ((x_j3+y_j3)>0)? 1'd1: 1'd0;
assign z_j3 = ((x_j3+y_j3)>0)? (x_j3+y_j3-2'd2) : (x_j3+y_j3);

assign t_j1 = ((z_j2+h_j2)<0)? -2'd1: 2'd0;
assign w_j2 = ((z_j2+h_j2)<0)? (z_j2+h_j2+2'd2): (z_j2+h_j2);

assign s_j1 = t_j1+w_j1;

always @(posedge clk or posedge reset) begin
	if(reset == 1'b1) begin
		w_j1 <= 2'd0;
		z_j2 <= 2'd0;
		s_j <= 2'd0;
	end 
	else begin
		if(clk == 1'b1) begin
			w_j1 <= w_j2;
			z_j2 <= z_j3;
			s_j <= s_j1;
		end
	end
end

endmodule