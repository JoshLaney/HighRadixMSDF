`timescale 1 ns/10 ps

module rRp_pp_tb;

parameter RADIX = 8;
parameter J = 2; //number of digits 
parameter TESTS = 10000;

localparam WIDTH = J+3;
localparam A = RADIX - 1;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit
localparam N = D*WIDTH; //bitwidth of each input

reg clk;
reg signed [D*(J+3)-1:0] x;
reg signed [D-1:0] y;
wire [D*(J+4) -1: 0] pp;
reg signed [(D-1):0] x_i, y_i, pp_i;

integer errors;
integer i;
integer x_num;
integer y_num;
integer pp_num;
integer pp_expected;
integer tests;

rR_mult_pp #(.RADIX(RADIX), .J(J)) pp_block(.a(x), .b(y), .pp(pp));

always begin
	clk = 1; #5; clk=0; #5;
end

initial begin
	errors = 0;
	x_num = 0;
	y_num = 0;
	pp_num = 0;
	pp_expected = 0;
	tests = TESTS -1;
end

always @(posedge clk)
	begin
		#1;
		x_num = 0;
		y_num = 0;
		pp_expected = 0;
		for(i = 0; i<WIDTH; i= i +1) begin
			x_i = $signed($urandom_range(0,2*A))-A;
			
			//$display("i: %0d, x_i: %0d, y_i: %0d", i, x_i, y_i);
			x_num = x_num + x_i*RADIX**i;
			x[i*D +: D] = x_i;
		end
		y_i = $signed($urandom_range(0,2*A))-A;
		y = y_i;
		y_num = y_i;
		pp_expected = x_num * y_num;
	end

always @(negedge clk)
	begin
		pp_num = 0;
		for(i = 0; i<WIDTH+1; i= i +1) begin
			pp_i = pp[i*D +: D];
			pp_num = pp_num + pp_i*RADIX**i;
		end

		if(pp_num != pp_expected)
		begin
			$display("Error at test %d", TESTS-tests);
			errors = errors + 1;
		end
		tests = tests - 1;
		if (tests < 0)
		begin
			#2;
			$display("%d tests completed with %d errors", TESTS, errors);
			$finish;
		end
	end

endmodule