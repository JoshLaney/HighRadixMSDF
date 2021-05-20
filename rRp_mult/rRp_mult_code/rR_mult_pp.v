module rR_mult_pp(
	a,
	b,
	pp
);

parameter J = 0;
parameter RADIX = 4;
localparam D = $clog2(RADIX) + 1; //bitwidth of each digit

input signed [D*(J+3) -1: 0] a;
input signed [D-1: 0] b;
output [D*(J+4) -1: 0] pp;

reg [D*(J+4) -1: 0] even;
reg [D*(J+4) -1: 0] odd;
reg signed [D-1:0] a_digit;

integer i;
integer pp_val;
integer pp_lb;
integer pp_ub;

initial begin
	even <= 0;
	odd <= 0;
end

always@(a,b, even, odd)begin
	for(i = 0; i<J+3; i=i+2) begin
		a_digit = a[D*i +: D];
		pp_val = a_digit*b;
		if(pp_val<=-1*RADIX||pp_val>=RADIX) begin
			pp_ub = pp_val/RADIX;
			pp_lb = pp_val - (pp_val/RADIX)*RADIX;
		end else begin
			pp_ub = 0;
			pp_lb = pp_val;
		end
		even[D*i +: D] <= pp_lb;
		even[D*(i+1) +: D] <= pp_ub;
	end
	
	for(i = 1; i<J+3; i=i+2) begin
		a_digit = a[D*i +: D];
		pp_val = a_digit*b;
		if(pp_val<=-1*RADIX||pp_val>=RADIX) begin
			pp_ub = pp_val/RADIX;
			pp_lb = pp_val - (pp_val/RADIX)*RADIX;
		end else begin
			pp_ub = 0;
			pp_lb = pp_val;
		end
		odd[D*i +: D] <= pp_lb;
		odd[D*(i+1) +: D] <= pp_ub;
	end
end

rRp_add #(.RADIX(RADIX), .WIDTH(J+4)) addr(
	.x(even),
	.y(odd),
	.s(pp));
		
endmodule 