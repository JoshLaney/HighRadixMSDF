//generalized parallel online adder for radix > 2

module rRp_mult(
	x,
	y,
	p
);

parameter WIDTH = 4; //number of digits
parameter RADIX = 2;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit


input [D*WIDTH-1:0] x, y;
output [D*(2*WIDTH+1)-1:0] p;

wire [D*(WIDTH+10)-1:0] w[0:WIDTH+2];
reg [2*D*WIDTH-1: 0] p_frac;
wire [2*D*WIDTH-1: 0] p_msds;

genvar i;

rR_mult_block #(.J(-3), .WIDTH(WIDTH), .RADIX(RADIX)) mb_n3(
	.x(x),
	.y(y),
	.w(0),
	.w_1(w[0]),
	.p());

generate
	for(i=-2; i<0; i=i+1) begin: negative_blocks
		rR_mult_block #(.J(i), .WIDTH(WIDTH), .RADIX(RADIX)) mb_n(
			.x(x),
			.y(y),
			.w(w[i+2]),
			.w_1(w[i+3]),
			.p());
	end
endgenerate

generate
	for(i=0; i<(WIDTH -1); i=i+1) begin: postive_blocks
		rR_mult_block #(.J(i), .WIDTH(WIDTH), .RADIX(RADIX)) mb_p(
			.x(x),
			.y(y),
			.w(w[i+2]),
			.w_1(w[i+3]),
			.p(p_msds[D*(2*WIDTH-i)-1 -: D]));
	end
endgenerate



rR_mult_block #(.J(WIDTH-1), .WIDTH(WIDTH), .RADIX(RADIX)) mb_last(
	.x(x),
	.y(y),
	.w(w[WIDTH-1+2]),
	.w_1(w[WIDTH+2]),
	.p(p_msds[D*(WIDTH+1)-1 -: D]));
	
assign p_msds[0 +: D*(WIDTH)] = 0;
always@(w[WIDTH+2]) begin
	p_frac[2*D*WIDTH-1 -: D*(2*WIDTH-WIDTH-3)] <= 0;
	p_frac[0 +: D*(WIDTH+4)] <= w[WIDTH+2][D*(WIDTH+7)-1 -: D*(WIDTH+4)];
end
//assign p_frac[0 +: D*(WIDTH+4)] = w[WIDTH+2][D*(WIDTH+7)-1 -: D*(WIDTH+4)];
// assign 
	
rRp_add #(.RADIX(RADIX), .WIDTH(2*WIDTH)) addr_p(
	.x(p_msds),
	.y(p_frac),
	.s(p));

endmodule