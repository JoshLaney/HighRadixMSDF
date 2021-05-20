`timescale 1 ns/10 ps

module rRp_mult_tb;

parameter RADIX = 4;
parameter WIDTH = 4; //number of digits 
parameter TESTS = 4;

localparam A = RADIX - 1;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit
localparam N = D*WIDTH; //bitwidth of each input

reg clk;
reg signed [D*WIDTH-1:0] x, y;
wire signed [D*(2*WIDTH+1)-1:0] p;
reg signed [(D-1):0] x_i, y_i, p_i;

integer errors;
integer i;
integer x_num;
integer y_num;
integer p_num;
integer p_expected;
integer tests;

rRp_mult #(.WIDTH(WIDTH), .RADIX(RADIX)) mult(.x(x), .y(y), .p(p));

always begin
	clk = 1; #5; clk=0; #5;
end

initial begin
	errors = 0;
	x_num = 0;
	y_num = 0;
	p_num = 0;
	p_expected = 0;
	tests = TESTS -1;
end

always @(posedge clk)
	begin
		#1;
		x_num = 0;
		y_num = 0;
		p_expected = 0;
		for(i = 0; i<WIDTH; i= i +1) begin
			x_i = $signed($urandom_range(0,2*A))-A;
			y_i = $signed($urandom_range(0,2*A))-A;
			//$display("i: %0d, x_i: %0d, y_i: %0d", i, x_i, y_i);
			x_num = x_num + x_i*RADIX**i;
			y_num = y_num + y_i*RADIX**i;
			x[i*D +: D] = x_i;
			y[i*D +: D] = y_i;
		end
		p_expected = x_num * y_num;
	end

always @(negedge clk)
	begin
		p_num = 0;
		for(i = 0; i<2*WIDTH+1; i= i +1) begin
			p_i = p[i*D +: D];
			p_num = p_num + p_i*RADIX**i;
		end

		if(p_num != p_expected)
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