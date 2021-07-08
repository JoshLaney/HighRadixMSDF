//generalized parallel online adder for radix > 2

module rRp_mult(
	x_in,
	y_in,
	p_out,
	clock
);

parameter WIDTH = 7; //number of digits
parameter RADIX = 2;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit

input clock;
input [D*WIDTH-1:0] x_in, y_in;
output [D*(2*WIDTH+1)-1:0] p_out;

(* preserve *) reg [D*WIDTH-1:0] x, y;
(* preserve *) reg [D*(2*WIDTH+1)-1:0] p_out;

//wire [D*WIDTH-1:0] x, y;
wire [D*(2*WIDTH+1)-1:0] p;
wire [D*(WIDTH+6)-1:0] w[0:WIDTH+2];
wire [2*D*WIDTH-1: 0] p_frac;
wire [2*D*WIDTH-1: 0] p_msds;

//assign x = x_reg;
//assign y = y_reg;
always@(posedge clock) begin
	x<=x_in;
	y<=y_in;
	p_out<=p;
end

genvar i;

rR_mult_block #(.J(-3), .WIDTH(WIDTH), .RADIX(RADIX)) mb_n3(
	.x(x),
	.y(y),
	.w(128'b0),
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
	
assign p_msds[0 +: D*(WIDTH)] = 128'b0;
assign p_frac[0 +: D*(WIDTH+3)] = w[WIDTH+2][D*(WIDTH+6)-1 -: D*(WIDTH+3)];
assign p_frac[2*D*WIDTH-1 : D*(WIDTH+3)] = 128'b0;
	
rRp_add #(.RADIX(RADIX), .WIDTH(2*WIDTH)) addr_p(
	.x(p_msds),
	.y(p_frac),
	.s(p));

endmodule