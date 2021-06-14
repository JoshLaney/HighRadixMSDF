`timescale 1 ns/10 ps

module rRp_add_tb;

parameter RADIX = 4;
parameter WIDTH = 6; //number of digits 
parameter TESTS = 100;

localparam A = RADIX - 1;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit
localparam N = D*WIDTH; //bitwidth of each input

reg clk;
reg signed [(N-1):0] x, y;
wire signed [((N-1)+D):0] s;
reg signed [(D-1):0] x_i, y_i, s_i;

integer errors;
integer i;
integer x_num;
integer y_num;
integer s_num;
integer s_expected;
integer s_expected_old;
integer tests;

rRp_add_clocked #(.RADIX(RADIX), .WIDTH(WIDTH)) addr(.x_in(x), .y_in(y), .s_out(s), .clock(clk));

always begin
	clk = 1; #5; clk=0; #5;
end

initial begin
	errors = 0;
	x_num = 0;
	y_num = 0;
	s_num = 0;
	s_expected = 0;
	tests = TESTS -1;
end

always @(negedge clk)
	begin
		#3;
		x_num = 0;
		y_num = 0;
		s_expected = 0;
		for(i = 0; i<WIDTH; i= i +1) begin
			x_i = $signed($urandom_range(0,2*A))-A;
			y_i = $signed($urandom_range(0,2*A))-A;
			//$display("i: %0d, x_i: %0d, y_i: %0d", i, x_i, y_i);
			x_num = x_num + x_i*RADIX**i;
			y_num = y_num + y_i*RADIX**i;
			x[i*D +: D] = x_i;
			y[i*D +: D] = y_i;
		end
		s_expected = x_num + y_num;
	end

always @(posedge clk)
	begin
		#1
		s_num = 0;
		for(i = 0; i<WIDTH+1; i= i +1) begin
			s_i = s[i*D +: D];
			s_num = s_num + s_i*RADIX**i;
		end
		#1
		if(s_num != s_expected_old)
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
		#1
		s_expected_old = s_expected;
	end

endmodule