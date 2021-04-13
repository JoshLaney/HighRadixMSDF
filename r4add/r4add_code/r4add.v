module r4add(
	x_j2,
	y_j2,
	s_j,
	clk,
	reset
);

input clk, reset;
input signed [2:0] y_j2, x_j2;
output signed [2:0] s_j;

reg signed [2:0] w_j2, s_j, w_j1;
reg signed [1:0] t_j1;
wire signed [2:0] s_j1;

always @(x_j2, y_j2) begin
	if(x_j2+y_j2 >= 3) begin
		t_j1 <= 2'd1;
		w_j2 <= x_j2 + y_j2 - 4;
	end else if (x_j2+y_j2 <= -3) begin
		t_j1 <= -2'd1;
		//w_j2 <= {1'b1, x_j2 + y_j2} + 4'd4;
		w_j2 <= x_j2 + y_j2 + 4;
	end else begin
		t_j1 <= 2'd0;
		w_j2 <= x_j2 + y_j2;
	end
end

assign s_j1 = t_j1+w_j1;

always @(posedge clk or posedge reset) begin
	if(reset == 1'b1) begin
		w_j1 <= 3'd0;
		s_j <= 3'd0;
	end 
	else begin
		if(clk == 1'b1) begin
			w_j1 <= w_j2;
			s_j <= s_j1;
		end
	end
end

endmodule