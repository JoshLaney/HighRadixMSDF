module r2_mult_pp(
	a,
	b,
	pp
);

parameter J = 0;

input [2*(J+3) -1: 0] a;
input [1: 0] b;
output reg [2*(J+3) -1: 0] pp;

integer i;

always@(a,b)begin
	if(b==2'd1) begin
		pp <= a;
		i = 0;
	end
	else if (b==-2'd1) begin
		for(i=0; i<J+3; i=i+1)begin
			pp[2*i +: 2] <= ~a[2*i +: 2] + 2'd1;
		end
	end
	else begin 
		pp <= 0;
		i=0;
	end
end

endmodule 