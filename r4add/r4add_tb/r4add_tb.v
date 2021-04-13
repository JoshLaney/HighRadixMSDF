`timescale 1 ns/10 ps

module r4add_tb;

reg clk, reset;
reg signed [2:0] x,y;
wire signed [2:0] s;
reg signed [2:0] s_expected;
reg [8:0] testvec[100000:0];
reg [31:0] vecnum, errors;

r4add addr(.x_j2(x), .y_j2(y), .s_j(s), .clk(clk), .reset(reset));

always begin
	clk = 1; #5; clk=0; #5;
end

initial begin
	$readmemb("Z:/Documents/ResearchProject/r4add/r4add_tb/r4add_vec.txt", testvec);
	vecnum = 0; errors = 0;
	reset = 1; #6 reset = 0;
end

always @(posedge clk)
	begin
		#1; {x, y, s_expected} = testvec[vecnum];
	end

always @(negedge clk)
	begin
		if(s != s_expected)
		begin
			$display("Error at line %d", vecnum);
			errors = errors + 1;
		end
		vecnum = vecnum +1;
		if (testvec[vecnum] === 9'bx)
		begin
			$display("%d tests completed with %d errors", vecnum, errors);
			$finish;
		end
	end

endmodule