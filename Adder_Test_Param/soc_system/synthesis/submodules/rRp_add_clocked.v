//generalized parallel online adder for radix > 2

module rRp_add_clocked(
	x_in,
	y_in,
	s_out,
	clock
);

parameter RADIX = 8;
parameter WIDTH = 5; //number of digits
localparam A = RADIX - 1;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit
localparam N = D*WIDTH; //bitwidth of each input
localparam tN = 2*WIDTH; //bitwidth of t

integer i;

input [(N-1):0] x_in, y_in;
output [((N-1)+D):0] s_out;
input clock;
(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [(N-1):0] x, y;
(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *) (* preserve="true" *) reg [((N-1)+D):0] s_out, s;

reg [(tN-1):0] t;

//nessessary for signed addition/comparison
reg signed [(D-1):0] x_i, y_i;
reg signed [1:0] t_im1;

always@(posedge clock) begin
	x<=x_in;
	y<=y_in;
	s_out<=s;
end

always@(x,y) begin
	s <= x + y;
end

//generate
//if (RADIX == 2) begin
//	reg [N-1:0] z;
//	reg [WIDTH-1:0] h , w;
//	reg signed [1:0] z_i, z_h;
//
//	always@(x, y) begin
//		for(i=0; i < WIDTH; i = i+1) begin
//			x_i = x[i*2 +: 2];
//			y_i = y[i*2 +: 2]; 
//			h[i] = ((x_i+y_i)>0)? 1'd1: 1'd0;
//			z[i*2 +: 2] = ((x_i+y_i)>0)? (x_i+y_i-2'd2) : (x_i+y_i);
//		end
//		
//		z_i = z[1:0];
//		w[0] = (z_i<0)? (z_i+2'd2): z_i;
//		t[1:0] = (z_i<0)? -2'd1: 2'd0;
//
//		for(i=1; i<WIDTH; i = i+1) begin
//			z_i = z[i*2 +: 2];
//			z_h = z_i + h[i-1];
////			$display ("z[%0d +: %0d] = %0d ('b%0b)", i*2, 2, z_i, z_i);
////			$display ("h[%0d] = %0d ('b%0b)", i-1, h[i-1], h[i-1]);
////			$display ("z+h = %0d ('b%0b)", z_i+h[i-1], z_i+h[i-1]);
//			w[i] = (z_h<0)? (z_h+2'd2): (z_h);
//			t[i*2 +: 2] = (z_h<0)? -2'd1: 2'd0;
//		end
//
//		s[N+1:N] <= h[WIDTH-1] + t[tN-1:tN-2];
//		s[1:0] <= w[0];
//
//		for(i=1; i<WIDTH; i=i+1) begin
//			t_im1 = t[(i-1)*2 +: 2];
//			s[i*2 +: 2] <= w[i] + t_im1;
//		end
//	end
//end else begin
//	reg [(N-1):0] w;
//	reg signed [(D-1): 0] w_i;
//	always @(x, y) begin
//		for(i = 0; i < WIDTH; i = i+1) begin
//			x_i = x[i*D +: D];
//			y_i = y[i*D +: D];
//			//$display ("x[%0d +: %0d] = %0d ('b%0b)", i*D, D, x_i, x_i);
//			//$display ("y[%0d +: %0d] = %0d ('b%0b)", i*D, D, y_i, y_i);
//			//$display ("x+y = %0d ('b%0b)", x_i+y_i, x_i+y_i);
//			if(x_i+y_i >= A) begin
//				t[i*2 +: 2] = 2'd1;
//				w[i*D +: D] = x_i + y_i - RADIX;
//			end else if (x_i+y_i <= -A) begin
//				t[i*2 +: 2] = -2'd1;
//				w[i*D +: D] = x_i + y_i + RADIX;
//			end else begin
//				t[i*2 +: 2] = 2'd0;
//				w[i*D +: D] = x_i + y_i;
//			end
//		end
//		
//		//$display ("s[%0d : %0d] <= t[%0d : %0d] ('b%0b)", (N-1)+D, N, x_i, x_i, t[tN-1:tN-2]);
//		s[(N-1)+D:N] <= { {(D-2){t[tN-1]}}, t[tN-1:tN-2]};
//		s[(D-1):0] <= w[(D-1):0];
//		
//		for(i=1; i<WIDTH; i=i+1) begin
//			w_i = w[i*D +: D];
//			t_im1 = t[(i-1)*2 +: 2];
//			s[i*D +: D] <= w_i + t_im1;
//		end
//	end
//end endgenerate

endmodule