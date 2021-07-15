//generalized parallel online adder for radix > 2

module rRp_mult(
	x_in,
	y_in,
	p_out,
	clock
);

parameter WIDTH = 4; //number of digits
parameter RADIX = 4;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit

input clock;
input [D*WIDTH-1:0] x_in, y_in;
output [D*(2*WIDTH+1)-1:0] p_out;

(* preserve *) reg [D*WIDTH-1:0] x[0:WIDTH+2], y[0:WIDTH+2];
(* preserve *) reg [D*(2*WIDTH+1)-1:0] p_out;
(* preserve *) reg [D*(WIDTH+6)-1:0] w_reg[0:WIDTH+1];
(* preserve *) reg [2*D*WIDTH-1: 0] p_msds_reg[0:WIDTH-1];
//wire [D*WIDTH-1:0] x, y;
wire [D*(2*WIDTH+1)-1:0] p;
wire [D*(WIDTH+6)-1:0] w[0:WIDTH+2];
wire [2*D*WIDTH-1: 0] p_frac;
wire [2*D*WIDTH-1: 0] p_msds[0:WIDTH-1];

integer j;

//assign x = x_reg;
//assign y = y_reg;
always@(posedge clock) begin
	x[0]<=x_in;
	y[0]<=y_in;
//	p_out <= x[0]*y[0];
	p_out<=p;
	for(j=0; j<WIDTH+2; j=j+1) begin: x_y_buf
		x[j+1] <= x[j];
		y[j+1] <= y[j];
	end
	for(j=0; j<=WIDTH+1; j=j+1) begin: w_buf
		w_reg[j]<=w[j];
	end
	//p_msds_reg[0] <= p_msds[0];
	for(j=0; j<WIDTH-1; j=j+1) begin: p_msds_buf
		p_msds_reg[j] <= p_msds[j];
		//p_msds_reg[j+1][D*(2*WIDTH-(j+1))-1 -: D] = p_msds[j+1][D*(2*WIDTH-(j+1))-1 -: D];
	end

end

genvar i;

generate
	for(i=1;i<=WIDTH-1;i=i+1) begin: p_msds_wire
		assign p_msds[i][D*(2*WIDTH)-1 -: D*i] = p_msds_reg[i-1][D*(2*WIDTH)-1 -: D*i];
	end
endgenerate 

rR_mult_block #(.J(-3), .WIDTH(WIDTH), .RADIX(RADIX)) mb_n3(
	.x(x[0]),
	.y(y[0]),
	.w(128'b0),
	.w_1(w[0]),
	.p());

generate
	for(i=-2; i<0; i=i+1) begin: negative_blocks
		rR_mult_block #(.J(i), .WIDTH(WIDTH), .RADIX(RADIX)) mb_n(
			.x(x[i+3]),
			.y(y[i+3]),
			.w(w_reg[i+2]),
			.w_1(w[i+3]),
			.p());
	end
endgenerate

generate
	for(i=0; i<(WIDTH -1); i=i+1) begin: postive_blocks
		rR_mult_block #(.J(i), .WIDTH(WIDTH), .RADIX(RADIX)) mb_p(
			.x(x[i+3]),
			.y(y[i+3]),
			.w(w_reg[i+2]),
			.w_1(w[i+3]),
			.p(p_msds[i][D*(2*WIDTH-i)-1 -: D]));
	end
endgenerate



rR_mult_block #(.J(WIDTH-1), .WIDTH(WIDTH), .RADIX(RADIX)) mb_last(
	.x(x[WIDTH+2]),
	.y(y[WIDTH+2]),
	.w(w_reg[WIDTH-1+2]),
	.w_1(w[WIDTH+2]),
	.p(p_msds[WIDTH-1][D*(WIDTH+1)-1 -: D]));
	

assign p_msds[WIDTH-1][0 +: D*(WIDTH)] = 128'b0;
assign p_frac[0 +: D*(WIDTH+3)] = w[WIDTH+2][D*(WIDTH+6)-1 -: D*(WIDTH+3)];
assign p_frac[2*D*WIDTH-1 : D*(WIDTH+3)] = 128'b0;

// always@(p_msds[WIDTH-1]) begin
// 	p_msds_reg[WIDTH-1][0 +: D*(WIDTH+1)]<=p_msds[WIDTH-1][0 +: D*(WIDTH+1)];
// end
	
rRp_add #(.RADIX(RADIX), .WIDTH(2*WIDTH)) addr_p(
	.x(p_msds[WIDTH-1]),
	.y(p_frac),
	.s(p));

endmodule