module r2_mult_block(
	x,
	y,
	w,
	w_1,
	p
);
parameter J = 0;
parameter WIDTH = 4;

input [2*WIDTH -1: 0] x;
input [2*WIDTH -1: 0] y;
input [2*(WIDTH+6)-1: 0] w;
output [2*(WIDTH+6)-1: 0] w_1;
output reg [1: 0] p;

generate
if(J == -3) begin
	wire [2*(J+3+1) -1: 0] y_j_1;
	reg [2*(WIDTH+6)-1: 0] w_1_n;

	r2_mult_pp #(.J(J+1)) y_sel(
		.a(y[2*WIDTH-1 -: 2*(J+1+3)]),
		.b(x[2*(WIDTH-J-3)-1 -: 2]), 
		.pp(y_j_1));

	always@(y_j_1) begin
		w_1_n[2*(WIDTH+6)-1 -: 2*(J+1+3+6)] <= {12'b0,y_j_1};
		w_1_n[0 +: 2*(WIDTH-J-4)] <= 0;
		p <= 2'b0;
	end
	
	assign w_1 = w_1_n;

end

else if (J<0) begin
	reg [2*(WIDTH+6)-1: 0] pp_x;
	reg [2*(WIDTH+6)-1: 0] pp_y;

	wire [2*(J+3) -1: 0] x_j;
	wire [2*(J+3+1) -1: 0] y_j_1;
	wire [2*(WIDTH+6)-1: 0] x_y;

	r2_mult_pp #(.J(J)) x_sel(
		.a(x[2*WIDTH-1 -: 2*(J+3)]),
		.b(y[2*(WIDTH-J-3)-1 -: 2]), 
		.pp(x_j));
	r2_mult_pp #(.J(J+1)) y_sel(
		.a(y[2*WIDTH-1 -: 2*(J+1+3)]),
		.b(x[2*(WIDTH-J-3)-1 -: 2]), 
		.pp(y_j_1));

	always @(x_j, y_j_1) begin
		pp_x[2*(WIDTH+6)-1 -: 2*(J+3+6)] <= {12'b0,x_j};
		pp_x[0 +: 2*(WIDTH-J-3)] <= 0;

		pp_y[2*(WIDTH+6)-1 -: 2*(J+1+3+6)] <= {12'b0,y_j_1};
		pp_y[0 +: 2*(WIDTH-J-4)] <= 0;
		p <= 2'b0;
	end

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_xy(
		.x(pp_x),
		.y(pp_y),
		.s(x_y));

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_v(
		.x({w[0 +: 2*(WIDTH+5)], 2'b0}),
		.y(x_y),
		.s(w_1));
end

else if(J<WIDTH-4) begin
	reg [2*(WIDTH+6)-1: 0] pp_x;
	reg [2*(WIDTH+6)-1: 0] pp_y;
	reg [2*(WIDTH+6)-1: 0] p_val;
	reg signed [1:0] v_i;

	wire [2*(J+3) -1: 0] x_j;
	wire [2*(J+3+1) -1: 0] y_j_1;
	wire [2*(WIDTH+6)-1: 0] x_y;
	wire [2*(WIDTH+6)-1: 0] v;

	integer v_est;
	integer i;

	r2_mult_pp #(.J(J)) x_sel(
		.a(x[2*WIDTH-1 -: 2*(J+3)]),
		.b(y[2*(WIDTH-J-3)-1 -: 2]), 
		.pp(x_j));
	r2_mult_pp #(.J(J+1)) y_sel(
		.a(y[2*WIDTH-1 -: 2*(J+1+3)]),
		.b(x[2*(WIDTH-J-3)-1 -: 2]), 
		.pp(y_j_1));

	always @(x_j, y_j_1) begin
		pp_x[2*(WIDTH+6)-1 -: 2*(J+3+6)] <= {12'b0,x_j};
		pp_x[0 +: 2*(WIDTH-J-3)] <= 0;

		pp_y[2*(WIDTH+6)-1 -: 2*(J+1+3+6)] <= {12'b0,y_j_1};
		pp_y[0 +: 2*(WIDTH-J-4)] <= 0;
	end

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_xy(
		.x(pp_x),
		.y(pp_y),
		.s(x_y));

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_v(
		.x({w[0 +: 2*(WIDTH+5)], 2'b0}),
		.y(x_y),
		.s(v));

	always @(v, v_est) begin
		v_est=0;
		for(i = 0; i<5; i=i+1) begin
			v_i = v[2*(WIDTH+6-i)-1 -: 2];
			v_est = v_est + v_i*2**(4-i);
		end
		if(v_est>=2) begin
			p <= 2'b01;
			p_val[2*(WIDTH+6)-1 -: 6] <= {4'd0,2'b11};
			p_val[0 +: 2*(WIDTH+3)] <= 0;
		end
		else if(v_est<=-2) begin
			p <= 2'b11;
			p_val[2*(WIDTH+6)-1 -: 6] <= {4'd0,2'b01};
			p_val[0 +: 2*(WIDTH+3)] <= 0;
		end
		else begin
			p <= 2'b00;
			p_val <= 0;
		end
	end

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_w(
		.x(p_val),
		.y(v),
		.s(w_1));

end

else if(J==WIDTH-4) begin
	reg [2*(WIDTH+6)-1: 0] pp_x;
	reg [2*(WIDTH+6)-1: 0] pp_y;
	reg [2*(WIDTH+6)-1: 0] p_val;
	reg signed [1:0] v_i;

	wire [2*(J+3) -1: 0] x_j;
	wire [2*(J+3+1) -1: 0] y_j_1;
	wire [2*(WIDTH+6)-1: 0] x_y;
	wire [2*(WIDTH+6)-1: 0] v;

	integer v_est;
	integer i;

	r2_mult_pp #(.J(J)) x_sel(
		.a(x[2*WIDTH-1 -: 2*(J+3)]),
		.b(y[2*(WIDTH-J-3)-1 -: 2]), 
		.pp(x_j));
	r2_mult_pp #(.J(J+1)) y_sel(
		.a(y[2*WIDTH-1 -: 2*(J+1+3)]),
		.b(x[2*(WIDTH-J-3)-1 -: 2]), 
		.pp(y_j_1));

	always @(x_j, y_j_1) begin
		pp_x[2*(WIDTH+6)-1 -: 2*(J+3+6)] <= {12'b0,x_j};
		pp_x[0 +: 2*(WIDTH-J-3)] <= 0;

		pp_y[2*(WIDTH+6)-1 -: 2*(J+1+3+6)] <= {12'b0,y_j_1};
	end

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_xy(
		.x(pp_x),
		.y(pp_y),
		.s(x_y));

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_v(
		.x({w[0 +: 2*(WIDTH+5)], 2'b0}),
		.y(x_y),
		.s(v));

	always @(v, v_est) begin
		v_est = 0;
		for(i = 0; i<5; i=i+1) begin
			v_i = v[2*(WIDTH+6-i)-1 -: 2];
			v_est = v_est + v_i*2**(4-i);
		end
		if(v_est>=2) begin
			p <= 2'b01;
			p_val[2*(WIDTH+6)-1 -: 6] <= {4'd0,2'b11};
			p_val[0 +: 2*(WIDTH+3) ] <= 0;
		end
		else if(v_est<=-2) begin
			p <= 2'b11;
			p_val[2*(WIDTH+6)-1 -: 6] <= {4'd0,2'b01};
			p_val[0 +: 2*(WIDTH+3) ] <= 0;
		end
		else begin
			p <= 2'b00;
			p_val <= 0;
		end
	end

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_w(
		.x(p_val),
		.y(v),
		.s(w_1));
end

else begin
	reg [2*(WIDTH+6)-1: 0] pp_x;
	reg [2*(WIDTH+6)-1: 0] pp_y;
	reg [2*(WIDTH+6)-1: 0] p_val;
	reg signed [1:0] v_i;
	wire [2*(WIDTH+6)-1: 0] v;
	
	integer v_est;
	integer i;
	
	assign v = {w[0 +: 2*(WIDTH+5)], 2'b0};
	always @(v, v_est) begin
		v_est = 0;
		for(i = 0; i<5; i=i+1) begin
			v_i = v[2*(WIDTH+6-i)-1 -: 2];
			v_est = v_est + v_i*2**(4-i);
		end
		if(v_est>=2) begin
			p <= 2'b01;
			p_val[2*(WIDTH+6)-1 -: 6] <= {4'd0,2'b11};
			p_val[0 +: 2*(WIDTH+3)] <= 0;
		end
		else if(v_est<=-2) begin
			p <= 2'b11;
			p_val[2*(WIDTH+6)-1 -: 6] <= {4'd0,2'b01};
			p_val[0 +: 2*(WIDTH+3)] <= 0;
		end
		else begin
			p <= 2'b00;
			p_val <= 0;
		end
	end

	rRp_add #(.RADIX(2), .WIDTH(WIDTH+6)) addr_w(
		.x(p_val),
		.y(v),
		.s(w_1));
end

endgenerate

endmodule
