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

generate
if(RADIX==2) begin
	reg [2*(J+4) -1: 0] prod;

	integer i;
	assign pp = prod;
	always@(a,b) begin
	
		for(i=0; i<J+3; i=i+1)begin
			case(b)
				2'b00: prod[2*i +: 2] <= 2'b00;
				2'b01: prod[2*i +: 2] <= a[2*i +: 2];
				2'b10: prod[2*i +: 2] <= 2'bXX;
				2'b11: begin
					case(a[2*i +: 2])
						2'b00: prod[2*i +: 2] <= 2'b00;
						2'b01: prod[2*i +: 2] <= 2'b11;
						2'b10: prod[2*i +: 2] <= 2'bXX;
						2'b11: prod[2*i +: 2] <= 2'b01;
						default: ;
					endcase	
				end
				default: ;
			endcase
		end
		
		prod[2*(J+3) +: 2] <= 2'b00;
	end
end else if (RADIX==4) begin
	reg [D*(J+4) -1: 0] even;
	reg [D*(J+4) -1: 0] odd;

	initial begin
		even <= 0;
		odd <= 0;
	end

	always@(a,b, even, odd)begin
		pp4(0,a,b,even);
		pp4(1,a,b,odd);
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(J+4)) addr(
		.x(even),
		.y(odd),
		.s(pp));
end else begin
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
end endgenerate

task automatic pp4;
	input parity;
	input signed [D*(J+3) -1: 0] a;
	input signed [D-1: 0] b;
	output [D*(J+4) -1: 0] half_pp;

	reg signed [D-1:0] a_digit;
	reg [2:0] pp_lb, pp_ub;
	integer i;

	begin
	half_pp = 0;
	for(i = parity; i<J+3; i=i+2) begin
		case(b)
			3'b000: begin
				pp_ub = 3'b000;
				pp_lb = 3'b000;
			end
			3'b001: begin
				pp_ub = 3'b000;
				pp_lb = a[D*i +: D];
			end
			3'b010: begin
				case(a[D*i +: D])
					3'b000: begin //0
						pp_ub = 3'b000;
						pp_lb = 3'b000;
					end
					3'b001: begin //2
						pp_ub = 3'b000;
						pp_lb = 3'b010;
					end
					3'b010: begin //4
						pp_ub = 3'b001;
						pp_lb = 3'b000;
					end
					3'b011: begin //6
						pp_ub = 3'b001;
						pp_lb = 3'b010;
					end
					3'b100: begin
						pp_ub = 3'bXXX;
						pp_lb = 3'bXXX;
					end
					3'b101: begin //-6
						pp_ub = 3'b111;
						pp_lb = 3'b110;
					end
					3'b110: begin //-4
						pp_ub = 3'b111;
						pp_lb = 3'b000;
					end
					3'b111: begin //-2
						pp_ub = 3'b000;
						pp_lb = 3'b110;
					end
					default: ;
				endcase
			end
			3'b011: begin
				case(a[D*i +: D])
					3'b000: begin //0
						pp_ub = 3'b000;
						pp_lb = 3'b000;
					end
					3'b001: begin //3
						pp_ub = 3'b000;
						pp_lb = 3'b011;
					end
					3'b010: begin //6
						pp_ub = 3'b001;
						pp_lb = 3'b010;
					end
					3'b011: begin //9
						pp_ub = 3'b010;
						pp_lb = 3'b001;
					end
					3'b100: begin
						pp_ub = 3'bXXX;
						pp_lb = 3'bXXX;
					end
					3'b101: begin //-9
						pp_ub = 3'b110;
						pp_lb = 3'b111;
					end
					3'b110: begin //-6
						pp_ub = 3'b111;
						pp_lb = 3'b110;
					end
					3'b111: begin
						pp_ub = 3'b000;
						pp_lb = 3'b101;
					end
					default: ;
				endcase
			end
			3'b100: begin
				pp_ub = 3'bXXX;
				pp_lb = 3'bXXX;
			end
			3'b101: begin
				case(a[D*i +: D])
					3'b000: begin //0
						pp_ub = 3'b000;
						pp_lb = 3'b000;
					end
					3'b001: begin //-3
						pp_ub = 3'b000;
						pp_lb = 3'b101;
					end
					3'b010: begin //-6
						pp_ub = 3'b111;
						pp_lb = 3'b110;
					end
					3'b011: begin //-9
						pp_ub = 3'b110;
						pp_lb = 3'b111;
					end
					3'b100: begin
						pp_ub = 3'bXXX;
						pp_lb = 3'bXXX;
					end
					3'b101: begin //9
						pp_ub = 3'b010;
						pp_lb = 3'b001;
					end
					3'b110: begin //6
						pp_ub = 3'b001;
						pp_lb = 3'b010;
					end
					3'b111: begin //3
						pp_ub = 3'b000;
						pp_lb = 3'b011;
					end
					default: ;
				endcase
			end
			3'b110: begin
				case(a[D*i +: D])
					3'b000: begin //0
						pp_ub = 3'b000;
						pp_lb = 3'b000;
					end
					3'b001: begin //-2
						pp_ub = 3'b000;
						pp_lb = 3'b110;
					end
					3'b010: begin //-4
						pp_ub = 3'b111;
						pp_lb = 3'b000;
					end
					3'b011: begin //-6
						pp_ub = 3'b111;
						pp_lb = 3'b110;
					end
					3'b100: begin
						pp_ub = 3'bXXX;
						pp_lb = 3'bXXX;
					end
					3'b101: begin //6
						pp_ub = 3'b001;
						pp_lb = 3'b010;
					end
					3'b110: begin //4
						pp_ub = 3'b001;
						pp_lb = 3'b000;
					end
					3'b111: begin //2
						pp_ub = 3'b000;
						pp_lb = 3'b010;
					end
					default: ;
				endcase
			end
			3'b111: begin
				case(a[D*i +: D])
					3'b000: begin //0
						pp_ub = 3'b000;
						pp_lb = 3'b000;
					end
					3'b001: begin //-1
						pp_ub = 3'b000;
						pp_lb = 3'b111;
					end
					3'b010: begin //-2
						pp_ub = 3'b000;
						pp_lb = 3'b110;
					end
					3'b011: begin //-3
						pp_ub = 3'b000;
						pp_lb = 3'b101;
					end
					3'b100: begin
						pp_ub = 3'bXXX;
						pp_lb = 3'bXXX;
					end
					3'b101: begin //3
						pp_ub = 3'b000;
						pp_lb = 3'b011;
					end
					3'b110: begin //2
						pp_ub = 3'b000;
						pp_lb = 3'b010;
					end
					3'b111: begin //1
						pp_ub = 3'b000;
						pp_lb = 3'b001;
					end
					default: ;
				endcase
			end
			default: ;
		endcase
		half_pp[D*i +: D] = pp_lb;
		half_pp[D*(i+1) +: D] = pp_ub;
	end
end endtask
endmodule 