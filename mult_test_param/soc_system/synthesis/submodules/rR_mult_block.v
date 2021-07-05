module rR_mult_block(
	x,
	y,
	w,
	w_1,
	p
);
parameter J = 0;
parameter WIDTH = 4;
parameter RADIX = 4;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit

input [D*WIDTH -1: 0] x;
input [D*WIDTH -1: 0] y;
input [D*(WIDTH+6)-1: 0] w;
output [D*(WIDTH+6)-1: 0] w_1;
output reg [D-1: 0] p;

generate
if(J == -3) begin
	wire [D*(J+4+1) -1: 0] y_j_1;
	reg [D*(WIDTH+6)-1: 0] w_1_n;

	rR_mult_pp #(.RADIX(RADIX), .J(J+1)) y_sel(
		.a(y[D*WIDTH-1 -: D*(J+1+3)]),
		.b(x[D*(WIDTH-J-3)-1 -: D]), 
		.pp(y_j_1));

	always@(y_j_1) begin
		//w_1_n[D*(WIDTH+6)-1 -: D*(J+1+3+6)] <= {12'b0,y_j_1};
		w_1_n[D*(WIDTH+6)-1 -: D*5] <= 128'b0;
		w_1_n[D*(WIDTH+1)-1 -: D*(J+1+4)] <= y_j_1;
		w_1_n[0 +: D*(WIDTH-J-4)] <= 128'b0;
		p <= 128'b0;
	end
	
	assign w_1 = w_1_n;

end

else if (J<0) begin
	reg [D*(WIDTH+6)-1: 0] pp_x;
	reg [D*(WIDTH+6)-1: 0] pp_y;
	reg [D*(WIDTH+6)-1: 0] w_shift;

	wire [D*(J+4) -1: 0] x_j;
	wire [D*(J+4+1) -1: 0] y_j_1;
	wire [D*(WIDTH+6)-1: 0] x_y;
	

	rR_mult_pp #(.RADIX(RADIX), .J(J)) x_sel(
		.a(x[D*WIDTH-1 -: D*(J+3)]),
		.b(y[D*(WIDTH-J-3)-1 -: D]), 
		.pp(x_j));
	rR_mult_pp #(.RADIX(RADIX), .J(J+1)) y_sel(
		.a(y[D*WIDTH-1 -: D*(J+1+3)]),
		.b(x[D*(WIDTH-J-3)-1 -: D]), 
		.pp(y_j_1));

	always @(x_j, y_j_1) begin
		pp_x[D*(WIDTH+6)-1 -: D*5] <= 128'b0;
		pp_x[D*(WIDTH+1)-1 -: D*(J+4)] <= x_j;
		pp_x[0 +: D*(WIDTH-J-3)] <= 128'b0;

		pp_y[D*(WIDTH+6)-1 -: D*5] <= 128'b0;
		pp_y[D*(WIDTH+1)-1 -: D*(J+1+4)] <= y_j_1;
		pp_y[0 +: D*(WIDTH-J-4)] <= 128'b0;
		p <= 128'b0;
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_xy(
		.x(pp_x),
		.y(pp_y),
		.s(x_y));

	always@(w) begin
		w_shift[0 +: D] <= 128'b0;
		w_shift[D*(WIDTH+6)-1 : D] <= w[0 +: D*(WIDTH+5)];
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_v(
		.x(w_shift),
		.y(x_y),
		.s(w_1));
end

else if(J<WIDTH-4) begin
	reg [D*(WIDTH+6)-1: 0] pp_x;
	reg [D*(WIDTH+6)-1: 0] pp_y;
	reg [D*(WIDTH+6)-1: 0] p_val;
	reg signed [D-1:0] v_i;
	reg [D*(WIDTH+6)-1: 0] w_shift;

	wire [D*(J+4) -1: 0] x_j;
	wire [D*(J+4+1) -1: 0] y_j_1;
	wire [D*(WIDTH+6)-1: 0] x_y;
	wire [D*(WIDTH+6)-1: 0] v;

	integer v_est;
	integer i;

	rR_mult_pp #(.RADIX(RADIX), .J(J)) x_sel(
		.a(x[D*WIDTH-1 -: D*(J+3)]),
		.b(y[D*(WIDTH-J-3)-1 -: D]), 
		.pp(x_j));
	rR_mult_pp #(.RADIX(RADIX), .J(J+1)) y_sel(
		.a(y[D*WIDTH-1 -: D*(J+1+3)]),
		.b(x[D*(WIDTH-J-3)-1 -: D]), 
		.pp(y_j_1));

	always @(x_j, y_j_1) begin
		pp_x[D*(WIDTH+6)-1 -: D*5] <= 128'b0;
		pp_x[D*(WIDTH+1)-1 -: D*(J+4)] <= x_j;
		pp_x[0 +: D*(WIDTH-J-3)] <= 128'b0;

		pp_y[D*(WIDTH+6)-1 -: D*5] <= 128'b0;
		pp_y[D*(WIDTH+1)-1 -: D*(J+1+4)] <= y_j_1;
		pp_y[0 +: D*(WIDTH-J-4)] <= 128'b0;
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_xy(
		.x(pp_x),
		.y(pp_y),
		.s(x_y));

	always@(w) begin
		w_shift[0 +: D] <= 128'b0;
		w_shift[D*(WIDTH+6)-1 : D] <= w[0 +: D*(WIDTH+5)];
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_v(
		.x(w_shift),
		.y(x_y),
		.s(v));

	always @(v, v_est) begin
		v_est=0;
		for(i = 0; i<5; i=i+1) begin
			v_i = v[D*(WIDTH+6-i)-1 -: D];
			v_est = v_est + v_i*(RADIX**(4-i));
		end
		v_est = v_est + (RADIX*RADIX)/2;
		if(v_est>=(RADIX**3)) begin
			p <= RADIX-1;
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*(RADIX-1));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else if(v_est<=(-1*RADIX*RADIX*(RADIX-1))) begin
			p <= -1*(RADIX-1);
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (RADIX-1);
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else if(v_est>=0) begin
			p <= v_est/(RADIX*RADIX);
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*v_est/(RADIX*RADIX));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else begin
			p <= v_est/(RADIX*RADIX) - 1;
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*(v_est/(RADIX*RADIX)-1));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_w(
		.x(p_val),
		.y(v),
		.s(w_1));

end

else if(J==WIDTH-4) begin
	reg [D*(WIDTH+6)-1: 0] pp_x;
	reg [D*(WIDTH+6)-1: 0] pp_y;
	reg [D*(WIDTH+6)-1: 0] p_val;
	reg signed [D-1:0] v_i;
	reg [D*(WIDTH+6)-1: 0] w_shift;

	wire [D*(J+4) -1: 0] x_j;
	wire [D*(J+4+1) -1: 0] y_j_1;
	wire [D*(WIDTH+6)-1: 0] x_y;
	wire [D*(WIDTH+6)-1: 0] v;

	integer v_est;
	integer i;

	rR_mult_pp #(.RADIX(RADIX), .J(J)) x_sel(
		.a(x[D*WIDTH-1 -: D*(J+3)]),
		.b(y[D*(WIDTH-J-3)-1 -: D]), 
		.pp(x_j));
	rR_mult_pp #(.RADIX(RADIX), .J(J+1)) y_sel(
		.a(y[D*WIDTH-1 -: D*(J+1+3)]),
		.b(x[D*(WIDTH-J-3)-1 -: D]), 
		.pp(y_j_1));

	always @(x_j, y_j_1) begin
		pp_x[D*(WIDTH+6)-1 -: D*5] <= 128'b0;
		pp_x[D*(WIDTH+1)-1 -: D*(J+4)] <= x_j;
		pp_x[0 +: D*(WIDTH-J-3)] <= 128'b0;

		pp_y[D*(WIDTH+6)-1 -: D*5] <= 128'b0;
		pp_y[D*(WIDTH+1)-1 -: D*(J+1+4)] <= y_j_1;
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_xy(
		.x(pp_x),
		.y(pp_y),
		.s(x_y));

	always@(w) begin
		w_shift[0 +: D] <= 128'b0;
		w_shift[D*(WIDTH+6)-1 : D] <= w[0 +: D*(WIDTH+5)];
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_v(
		.x(w_shift),
		.y(x_y),
		.s(v));

	always @(v, v_est) begin
		v_est=0;
		for(i = 0; i<5; i=i+1) begin
			v_i = v[D*(WIDTH+6-i)-1 -: D];
			v_est = v_est + v_i*(RADIX**(4-i));
		end
		v_est = v_est + (RADIX*RADIX)/2;
		if(v_est>=(RADIX**3)) begin
			p <= RADIX-1;
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*(RADIX-1));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else if(v_est<=(-1*RADIX*RADIX*(RADIX-1))) begin
			p <= -1*(RADIX-1);
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (RADIX-1);
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else if(v_est>=0) begin
			p <= v_est/(RADIX*RADIX);
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*v_est/(RADIX*RADIX));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else begin
			p <= v_est/(RADIX*RADIX) - 1;
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*(v_est/(RADIX*RADIX)-1));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_w(
		.x(p_val),
		.y(v),
		.s(w_1));
end

else begin
	reg [D*(WIDTH+6)-1: 0] pp_x;
	reg [D*(WIDTH+6)-1: 0] pp_y;
	reg [D*(WIDTH+6)-1: 0] p_val;
	reg signed [D-1:0] v_i;
	wire [D*(WIDTH+6)-1: 0] v;
	
	integer v_est;
	integer i;
	
	assign v[0 +: D] = 0;
	assign v[D*(WIDTH+6)-1 : D] = w[0 +: D*(WIDTH+5)];
	always @(v, v_est) begin
		v_est=0;
		for(i = 0; i<5; i=i+1) begin
			v_i = v[D*(WIDTH+6-i)-1 -: D];
			v_est = v_est + v_i*(RADIX**(4-i));
		end
		v_est = v_est + (RADIX*RADIX)/2;
		if(v_est>=(RADIX**3)) begin
			p <= RADIX-1;
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*(RADIX-1));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else if(v_est<=(-1*RADIX*RADIX*(RADIX-1))) begin
			p <= -1*(RADIX-1);
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (RADIX-1);
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else if(v_est>=0) begin
			p <= v_est/(RADIX*RADIX);
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*v_est/(RADIX*RADIX));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
		else begin
			p <= v_est/(RADIX*RADIX) - 1;
			p_val[D*(WIDTH+6)-1 -: 2*D] <= 128'b0;
			p_val[D*(WIDTH+3) +: D] <= (-1*(v_est/(RADIX*RADIX)-1));
			p_val[0 +: D*(WIDTH+3)] <= 128'b0;
		end
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_w(
		.x(p_val),
		.y(v),
		.s(w_1));
end

endgenerate

endmodule
