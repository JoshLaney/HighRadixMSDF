 module rR_mult_block(
 	x,
 	y,
 	w,
 	w_1,
 	p
 );
 parameter J = 0;
 parameter WIDTH = 4;
 parameter RADIX = 4;
 localparam D = $clog2(RADIX) + 1; //bitwidth of each digit

 input [D*WIDTH -1: 0] x;
 input [D*WIDTH -1: 0] y;
 input [D*(WIDTH+6)-1: 0] w;
 output [D*(WIDTH+6)-1: 0] w_1;
 output reg [D-1: 0] p;

//module rR_mult_block(
//    x_in,
//    y_in,
//    w_in,
//    w_1_out,
//    p_out,
//    clock
//);
//parameter J = 1;
//parameter WIDTH = 7;
//parameter RADIX = 2;
//localparam D = $clog2(RADIX) + 1; //bitwidth of each digit
//
//input [D*WIDTH -1: 0] x_in;
//input [D*WIDTH -1: 0] y_in;
//input [D*(WIDTH+6)-1: 0] w_in;
//output reg [D*(WIDTH+6)-1: 0] w_1_out;
//output reg [D-1: 0] p_out;
//input clock;
//
//
//reg [D*WIDTH -1: 0] x;
//reg [D*WIDTH -1: 0] y;
//reg [D*(WIDTH+6)-1: 0] w;
//wire [D*(WIDTH+6)-1: 0] w_1;
//reg [D-1: 0] p;
//
//always@(posedge clock) begin
//    x <= x_in;
//    y <= y_in;
//    w <= w_in;
//    w_1_out <= w_1;
//    p_out <= p;
//end

generate
if(J == -3) begin
	wire [D*(J+4+1) -1: 0] y_j_1;
	reg [D*(WIDTH+6)-1: 0] w_1_n;

	rR_mult_pp #(.RADIX(RADIX), .J(J+1)) y_sel(
		.a(y[D*WIDTH-1 -: D*(J+1+3)]),
		.b(x[D*(WIDTH-J-3)-1 -: D]), 
		.pp(y_j_1));

	always@(y_j_1) begin
		//w_1_n[D*(WIDTH+6)-1 -: D*(J+1+3+6)] <= {12'b0,y_j_1};
		w_1_n[D*(WIDTH+6)-1 -: D*5] <= 128'b0;
		w_1_n[D*(WIDTH+1)-1 -: D*(J+1+4)] <= y_j_1;
		w_1_n[0 +: D*(WIDTH-J-4)] <= 128'b0;
		p <= 128'b0;
	end
	
	assign w_1 = w_1_n;

end

else if (J<0) begin
	reg [D*(WIDTH+6)-1: 0] pp_x;
	reg [D*(WIDTH+6)-1: 0] pp_y;
	reg [D*(WIDTH+6)-1: 0] w_shift;

	wire [D*(J+4) -1: 0] x_j;
	wire [D*(J+4+1) -1: 0] y_j_1;
	wire [D*(WIDTH+6)-1: 0] x_y;
	

	rR_mult_pp #(.RADIX(RADIX), .J(J)) x_sel(
		.a(x[D*WIDTH-1 -: D*(J+3)]),
		.b(y[D*(WIDTH-J-3)-1 -: D]), 
		.pp(x_j));
	rR_mult_pp #(.RADIX(RADIX), .J(J+1)) y_sel(
		.a(y[D*WIDTH-1 -: D*(J+1+3)]),
		.b(x[D*(WIDTH-J-3)-1 -: D]), 
		.pp(y_j_1));

	always @(x_j, y_j_1) begin
		assign_pp(x_j,y_j_1,pp_x,pp_y);
		p <= 128'b0;
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_xy(
		.x(pp_x),
		.y(pp_y),
		.s(x_y));

	always@(w) begin
		w_shift[0 +: D] <= 128'b0;
		w_shift[D*(WIDTH+6)-1 : D] <= w[0 +: D*(WIDTH+5)];
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_v(
		.x(w_shift),
		.y(x_y),
		.s(w_1));
end

else if(J<=WIDTH-4) begin
	reg [D*(WIDTH+6)-1: 0] pp_x;
	reg [D*(WIDTH+6)-1: 0] pp_y;
	reg [D*(WIDTH+6)-1: 0] p_val;
	reg [D*(WIDTH+6)-1: 0] w_shift;

	wire [D*(J+4) -1: 0] x_j;
	wire [D*(J+4+1) -1: 0] y_j_1;
	wire [D*(WIDTH+6)-1: 0] x_y;
	wire [D*(WIDTH+6)-1: 0] v;


	rR_mult_pp #(.RADIX(RADIX), .J(J)) x_sel(
		.a(x[D*WIDTH-1 -: D*(J+3)]),
		.b(y[D*(WIDTH-J-3)-1 -: D]), 
		.pp(x_j));
	rR_mult_pp #(.RADIX(RADIX), .J(J+1)) y_sel(
		.a(y[D*WIDTH-1 -: D*(J+1+3)]),
		.b(x[D*(WIDTH-J-3)-1 -: D]), 
		.pp(y_j_1));

	always @(x_j, y_j_1) begin
		assign_pp(x_j,y_j_1,pp_x,pp_y);
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_xy(
		.x(pp_x),
		.y(pp_y),
		.s(x_y));

	always@(w) begin
		w_shift[0 +: D] <= 128'b0;
		w_shift[D*(WIDTH+6)-1 : D] <= w[0 +: D*(WIDTH+5)];
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_v(
		.x(w_shift),
		.y(x_y),
		.s(v));

	always @(v) begin
		estimate(v,p,p_val);
		//p_val <= v;
		//p <= v[1:0];
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_w(
		.x(p_val),
		.y(v),
		.s(w_1));

end

else begin
	reg [D*(WIDTH+6)-1: 0] pp_x;
	reg [D*(WIDTH+6)-1: 0] pp_y;
	reg [D*(WIDTH+6)-1: 0] p_val;
	wire [D*(WIDTH+6)-1: 0] v;
	
	assign v[0 +: D] = 0;
	assign v[D*(WIDTH+6)-1 : D] = w[0 +: D*(WIDTH+5)];
	always @(v) begin
		estimate(v,p,p_val);
		//p_val <= v;
		//p <= v[1:0];
	end

	rRp_add #(.RADIX(RADIX), .WIDTH(WIDTH+6)) addr_w(
		.x(p_val),
		.y(v),
		.s(w_1));
end

endgenerate

task automatic assign_pp;
	input [D*(J+4) -1: 0] x_j;
	input [D*(J+4+1) -1: 0] y_j_1;
	output [D*(WIDTH+6)-1: 0] pp_x;
	output [D*(WIDTH+6)-1: 0] pp_y;
	begin
		pp_x[D*(WIDTH+6)-1 -: D*5] = 128'b0;
		pp_x[D*(WIDTH+1)-1 -: D*(J+4)] = x_j;
		pp_x[0 +: D*(WIDTH-J-3)] = 128'b0;

		pp_y[D*(WIDTH+6)-1 -: D*5] = 128'b0;
		pp_y[D*(WIDTH+1)-1 -: D*(J+1+4)] = y_j_1;
		if(J<WIDTH-4)
			pp_y[0 +: D*(WIDTH-J-4)] = 128'b0;
	end
endtask

// generate
// if(RADIX>2) begin
//     task automatic estimate;
//     	input [D*(WIDTH+6)-1: 0] v;
//     	output [D-1:0] p;
//     	output [D*(WIDTH+6)-1: 0] p_val;
//     	integer i;
//     	integer v_est;
//     	reg signed [D-1:0] v_i;
//     	begin
//     		v_est=0;
//     		for(i = 0; i<5; i=i+1) begin
//     			v_i = v[D*(WIDTH+6-i)-1 -: D];
//     			v_est = v_est + v_i*(RADIX**(4-i));
//     		end
//     		v_est = v_est + (RADIX*RADIX)/2;
//     		if(v_est>=(RADIX**3)) begin
//     			p = RADIX-1;
//     			p_val[D*(WIDTH+6)-1 -: 2*D] = 128'b0;
//     			p_val[D*(WIDTH+3) +: D] = (-1*(RADIX-1));
//     			p_val[0 +: D*(WIDTH+3)] = 128'b0;
//     		end
//     		else if(v_est<=(-1*RADIX*RADIX*(RADIX-1))) begin
//     			p = -1*(RADIX-1);
//     			p_val[D*(WIDTH+6)-1 -: 2*D] = 128'b0;
//     			p_val[D*(WIDTH+3) +: D] = (RADIX-1);
//     			p_val[0 +: D*(WIDTH+3)] = 128'b0;
//     		end
//     		else if(v_est>=0) begin
//     			p = v_est/(RADIX*RADIX);
//     			p_val[D*(WIDTH+6)-1 -: 2*D] = 128'b0;
//     			p_val[D*(WIDTH+3) +: D] = (-1*v_est/(RADIX*RADIX));
//     			p_val[0 +: D*(WIDTH+3)] = 128'b0;
//     		end
//     		else begin
//     			p = v_est/(RADIX*RADIX) - 1;
//     			p_val[D*(WIDTH+6)-1 -: 2*D] = 128'b0;
//     			p_val[D*(WIDTH+3) +: D] = (-1*(v_est/(RADIX*RADIX)-1));
//     			p_val[0 +: D*(WIDTH+3)] = 128'b0;
//     		end
//     	end
//     endtask
// end else begin
    task automatic estimate;
        input [D*(WIDTH+6)-1: 0] v;
        output [D-1:0] p;
        output [D*(WIDTH+6)-1: 0] p_val;
        begin
            case (v[D*(WIDTH+6)-1 -: 5*D])
                10'b0000000000: p = 2'b00;
                10'b0000000001: p = 2'b00;
                10'b0000000011: p = 2'b00;
                10'b0000000100: p = 2'b01;
                10'b0000000101: p = 2'b01;
                10'b0000000111: p = 2'b00;
                10'b0000001100: p = 2'b00;
                10'b0000001101: p = 2'b00;
                10'b0000001111: p = 2'b11;
                10'b0000010000: p = 2'b01;
                10'b0000010001: p = 2'b01;
                10'b0000010011: p = 2'b01;
                10'b0000010100: p = 2'b01;
                10'b0000010101: p = 2'b01;
                10'b0000010111: p = 2'b01;
                10'b0000011100: p = 2'b01;
                10'b0000011101: p = 2'b01;
                10'b0000011111: p = 2'b00;
                10'b0000110000: p = 2'b11;
                10'b0000110001: p = 2'b11;
                10'b0000110011: p = 2'b11;
                10'b0000110100: p = 2'b00;
                10'b0000110101: p = 2'b00;
                10'b0000110111: p = 2'b11;
                10'b0000111100: p = 2'b11;
                10'b0000111101: p = 2'b11;
                10'b0000111111: p = 2'b11;
                10'b0001000000: p = 2'b01;
                10'b0001000001: p = 2'b01;
                10'b0001000011: p = 2'b01;
                10'b0001000100: p = 2'b01;
                10'b0001000101: p = 2'b01;
                10'b0001000111: p = 2'b01;
                10'b0001001100: p = 2'b01;
                10'b0001001101: p = 2'b01;
                10'b0001001111: p = 2'b01;
                10'b0001010000: p = 2'b01;
                10'b0001010001: p = 2'b01;
                10'b0001010011: p = 2'b01;
                10'b0001010100: p = 2'b01;
                10'b0001010101: p = 2'b01;
                10'b0001010111: p = 2'b01;
                10'b0001011100: p = 2'b01;
                10'b0001011101: p = 2'b01;
                10'b0001011111: p = 2'b01;
                10'b0001110000: p = 2'b01;
                10'b0001110001: p = 2'b01;
                10'b0001110011: p = 2'b01;
                10'b0001110100: p = 2'b01;
                10'b0001110101: p = 2'b01;
                10'b0001110111: p = 2'b01;
                10'b0001111100: p = 2'b01;
                10'b0001111101: p = 2'b01;
                10'b0001111111: p = 2'b00;
                10'b0011000000: p = 2'b11;
                10'b0011000001: p = 2'b11;
                10'b0011000011: p = 2'b11;
                10'b0011000100: p = 2'b11;
                10'b0011000101: p = 2'b11;
                10'b0011000111: p = 2'b11;
                10'b0011001100: p = 2'b11;
                10'b0011001101: p = 2'b11;
                10'b0011001111: p = 2'b11;
                10'b0011010000: p = 2'b11;
                10'b0011010001: p = 2'b11;
                10'b0011010011: p = 2'b11;
                10'b0011010100: p = 2'b00;
                10'b0011010101: p = 2'b00;
                10'b0011010111: p = 2'b11;
                10'b0011011100: p = 2'b11;
                10'b0011011101: p = 2'b11;
                10'b0011011111: p = 2'b11;
                10'b0011110000: p = 2'b11;
                10'b0011110001: p = 2'b11;
                10'b0011110011: p = 2'b11;
                10'b0011110100: p = 2'b11;
                10'b0011110101: p = 2'b11;
                10'b0011110111: p = 2'b11;
                10'b0011111100: p = 2'b11;
                10'b0011111101: p = 2'b11;
                10'b0011111111: p = 2'b11;
                10'b0100000000: p = 2'b01;
                10'b0100000001: p = 2'b01;
                10'b0100000011: p = 2'b01;
                10'b0100000100: p = 2'b01;
                10'b0100000101: p = 2'b01;
                10'b0100000111: p = 2'b01;
                10'b0100001100: p = 2'b01;
                10'b0100001101: p = 2'b01;
                10'b0100001111: p = 2'b01;
                10'b0100010000: p = 2'b01;
                10'b0100010001: p = 2'b01;
                10'b0100010011: p = 2'b01;
                10'b0100010100: p = 2'b01;
                10'b0100010101: p = 2'b01;
                10'b0100010111: p = 2'b01;
                10'b0100011100: p = 2'b01;
                10'b0100011101: p = 2'b01;
                10'b0100011111: p = 2'b01;
                10'b0100110000: p = 2'b01;
                10'b0100110001: p = 2'b01;
                10'b0100110011: p = 2'b01;
                10'b0100110100: p = 2'b01;
                10'b0100110101: p = 2'b01;
                10'b0100110111: p = 2'b01;
                10'b0100111100: p = 2'b01;
                10'b0100111101: p = 2'b01;
                10'b0100111111: p = 2'b01;
                10'b0101000000: p = 2'b01;
                10'b0101000001: p = 2'b01;
                10'b0101000011: p = 2'b01;
                10'b0101000100: p = 2'b01;
                10'b0101000101: p = 2'b01;
                10'b0101000111: p = 2'b01;
                10'b0101001100: p = 2'b01;
                10'b0101001101: p = 2'b01;
                10'b0101001111: p = 2'b01;
                10'b0101010000: p = 2'b01;
                10'b0101010001: p = 2'b01;
                10'b0101010011: p = 2'b01;
                10'b0101010100: p = 2'b01;
                10'b0101010101: p = 2'b01;
                10'b0101010111: p = 2'b01;
                10'b0101011100: p = 2'b01;
                10'b0101011101: p = 2'b01;
                10'b0101011111: p = 2'b01;
                10'b0101110000: p = 2'b01;
                10'b0101110001: p = 2'b01;
                10'b0101110011: p = 2'b01;
                10'b0101110100: p = 2'b01;
                10'b0101110101: p = 2'b01;
                10'b0101110111: p = 2'b01;
                10'b0101111100: p = 2'b01;
                10'b0101111101: p = 2'b01;
                10'b0101111111: p = 2'b01;
                10'b0111000000: p = 2'b01;
                10'b0111000001: p = 2'b01;
                10'b0111000011: p = 2'b01;
                10'b0111000100: p = 2'b01;
                10'b0111000101: p = 2'b01;
                10'b0111000111: p = 2'b01;
                10'b0111001100: p = 2'b01;
                10'b0111001101: p = 2'b01;
                10'b0111001111: p = 2'b01;
                10'b0111010000: p = 2'b01;
                10'b0111010001: p = 2'b01;
                10'b0111010011: p = 2'b01;
                10'b0111010100: p = 2'b01;
                10'b0111010101: p = 2'b01;
                10'b0111010111: p = 2'b01;
                10'b0111011100: p = 2'b01;
                10'b0111011101: p = 2'b01;
                10'b0111011111: p = 2'b01;
                10'b0111110000: p = 2'b01;
                10'b0111110001: p = 2'b01;
                10'b0111110011: p = 2'b01;
                10'b0111110100: p = 2'b01;
                10'b0111110101: p = 2'b01;
                10'b0111110111: p = 2'b01;
                10'b0111111100: p = 2'b01;
                10'b0111111101: p = 2'b01;
                10'b0111111111: p = 2'b00;
                10'b1100000000: p = 2'b11;
                10'b1100000001: p = 2'b11;
                10'b1100000011: p = 2'b11;
                10'b1100000100: p = 2'b11;
                10'b1100000101: p = 2'b11;
                10'b1100000111: p = 2'b11;
                10'b1100001100: p = 2'b11;
                10'b1100001101: p = 2'b11;
                10'b1100001111: p = 2'b11;
                10'b1100010000: p = 2'b11;
                10'b1100010001: p = 2'b11;
                10'b1100010011: p = 2'b11;
                10'b1100010100: p = 2'b11;
                10'b1100010101: p = 2'b11;
                10'b1100010111: p = 2'b11;
                10'b1100011100: p = 2'b11;
                10'b1100011101: p = 2'b11;
                10'b1100011111: p = 2'b11;
                10'b1100110000: p = 2'b11;
                10'b1100110001: p = 2'b11;
                10'b1100110011: p = 2'b11;
                10'b1100110100: p = 2'b11;
                10'b1100110101: p = 2'b11;
                10'b1100110111: p = 2'b11;
                10'b1100111100: p = 2'b11;
                10'b1100111101: p = 2'b11;
                10'b1100111111: p = 2'b11;
                10'b1101000000: p = 2'b11;
                10'b1101000001: p = 2'b11;
                10'b1101000011: p = 2'b11;
                10'b1101000100: p = 2'b11;
                10'b1101000101: p = 2'b11;
                10'b1101000111: p = 2'b11;
                10'b1101001100: p = 2'b11;
                10'b1101001101: p = 2'b11;
                10'b1101001111: p = 2'b11;
                10'b1101010000: p = 2'b11;
                10'b1101010001: p = 2'b11;
                10'b1101010011: p = 2'b11;
                10'b1101010100: p = 2'b00;
                10'b1101010101: p = 2'b00;
                10'b1101010111: p = 2'b11;
                10'b1101011100: p = 2'b11;
                10'b1101011101: p = 2'b11;
                10'b1101011111: p = 2'b11;
                10'b1101110000: p = 2'b11;
                10'b1101110001: p = 2'b11;
                10'b1101110011: p = 2'b11;
                10'b1101110100: p = 2'b11;
                10'b1101110101: p = 2'b11;
                10'b1101110111: p = 2'b11;
                10'b1101111100: p = 2'b11;
                10'b1101111101: p = 2'b11;
                10'b1101111111: p = 2'b11;
                10'b1111000000: p = 2'b11;
                10'b1111000001: p = 2'b11;
                10'b1111000011: p = 2'b11;
                10'b1111000100: p = 2'b11;
                10'b1111000101: p = 2'b11;
                10'b1111000111: p = 2'b11;
                10'b1111001100: p = 2'b11;
                10'b1111001101: p = 2'b11;
                10'b1111001111: p = 2'b11;
                10'b1111010000: p = 2'b11;
                10'b1111010001: p = 2'b11;
                10'b1111010011: p = 2'b11;
                10'b1111010100: p = 2'b11;
                10'b1111010101: p = 2'b11;
                10'b1111010111: p = 2'b11;
                10'b1111011100: p = 2'b11;
                10'b1111011101: p = 2'b11;
                10'b1111011111: p = 2'b11;
                10'b1111110000: p = 2'b11;
                10'b1111110001: p = 2'b11;
                10'b1111110011: p = 2'b11;
                10'b1111110100: p = 2'b11;
                10'b1111110101: p = 2'b11;
                10'b1111110111: p = 2'b11;
                10'b1111111100: p = 2'b11;
                10'b1111111101: p = 2'b11;
                10'b1111111111: p = 2'b11;
                default: p = 0;
             endcase
             p_val[D*(WIDTH+6)-1 -: 2*D] = 128'b0;
             p_val[D*(WIDTH+3) +: D] = (~p+1);
             p_val[0 +: D*(WIDTH+3)] = 128'b0;
        end
    endtask
// end endgenerate

endmodule
