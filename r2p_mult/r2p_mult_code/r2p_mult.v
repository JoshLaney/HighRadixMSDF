//generalized parallel online adder for radix > 2

module r2p_mult(
	x,
	y,
	p
);

parameter WIDTH = 4; //number of digits


input [2*WIDTH-1:0] x, y;
output [4*WIDTH+1:0] p;

wire [2*(WIDTH+6)-1:0] w[0:WIDTH+2];
wire [4*WIDTH-1: 0] p_frac;
wire [4*WIDTH-1: 0] p_msds;

genvar i;

r2_mult_block #(.J(-3), .WIDTH(WIDTH)) mb_n3(
	.x(x),
	.y(y),
	.w(0),
	.w_1(w[0]),
	.p());

generate
	for(i=-2; i<0; i=i+1) begin: negative_blocks
		r2_mult_block #(.J(i), .WIDTH(WIDTH)) mb_n(
			.x(x),
			.y(y),
			.w(w[i+2]),
			.w_1(w[i+3]),
			.p());
	end
endgenerate

generate
	for(i=0; i<(WIDTH -1); i=i+1) begin: postive_blocks
		r2_mult_block #(.J(i), .WIDTH(WIDTH)) mb_p(
			.x(x),
			.y(y),
			.w(w[i+2]),
			.w_1(w[i+3]),
			.p(p_msds[2*(2*WIDTH-i)-1-: 2]));
	end
endgenerate



r2_mult_block #(.J(WIDTH-1), .WIDTH(WIDTH)) mb_last(
	.x(x),
	.y(y),
	.w(w[WIDTH-1+2]),
	.w_1(w[WIDTH+2]),
	.p(p_msds[2*(WIDTH+1)-1 -: 2]));
	
assign p_msds[0 +: 2*(WIDTH)] = 0;
assign p_frac[0 +: 2*(WIDTH+3)] = w[WIDTH+2][2*(WIDTH+6)-1 -: 2*(WIDTH+3)];
assign p_frac[4*WIDTH-1 : 2*(WIDTH+3)] = 0;
	
rRp_add #(.RADIX(2), .WIDTH(2*WIDTH)) addr_p(
	.x(p_msds),
	.y(p_frac),
	.s(p));

endmodule