module mult_tester_system(
	input avalon_clk, pll_clk, resetn,
	
	input read_rap, write_rap,
	input [4:0] address_rap,
	input [31:0] writedata_rap,
	output [31:0] readdata_rap,

	input read_ran, write_ran,
	input [4:0] address_ran,
	input [31:0] writedata_ran,
	output [31:0] readdata_ran,

	input read_rbp, write_rbp,
	input [4:0] address_rbp,
	input [31:0] writedata_rbp,
	output [31:0] readdata_rbp,

	input read_rbn, write_rbn,
	input [4:0] address_rbn,
	input [31:0] writedata_rbn,
	output [31:0] readdata_rbn,

	input read_rcp, write_rcp,
	input [4:0] address_rcp,
	input [31:0] writedata_rcp,
	output [31:0] readdata_rcp,

	input read_rcn, write_rcn,
	input [4:0] address_rcn,
	input [31:0] writedata_rcn,
	output [31:0] readdata_rcn,

	input read_tcu, write_tcu, pll_lock,
	input [2:0] address_tcu,
	input [31:0] writedata_tcu,
	output [31:0] readdata_tcu
);

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *)

localparam RADIX = 2;
localparam DIGITS = 31;
localparam ADDR_WIDTH = 9;
localparam DW = $clog2(RADIX)+1;
localparam BITS = DW*DIGITS;
localparam BITS_OUT = 2*BITS+DW;
localparam W32 = 128; //32*((BITS_OUT+32-1)/32);
localparam ADELAY = (DIGITS+3)/2; //celi((DIGITS+2)/2)

//INTERNAL CLOCKS
wire clk_neg, clk_pos;

//ADDRESSES
wire[ADDR_WIDTH-1:0] addr_ap, addr_an, addr_bp, addr_bn;
wire[ADDR_WIDTH-1:0] addr_cp_0, addr_cp_1, addr_cp_2, addr_cp_3, addr_cp_4, addr_cp_5;
wire[ADDR_WIDTH-1:0] addr_cn_0, addr_cn_1, addr_cn_2, addr_cn_3, addr_cn_4, addr_cn_5;
wire[ADDR_WIDTH-1:0] addr_pline_p[0:ADELAY], addr_pline_n[0:ADELAY];
wire we_cp_0, we_cp_1, we_cp_2, we_cp_3, we_cp_4, we_cp_5;
wire we_cn_0, we_cn_1, we_cn_2, we_cn_3, we_cn_4, we_cn_5;
wire we_pline_p[0:ADELAY], we_pline_n[0:ADELAY];

//DATA_INTO_MULT
wire[BITS-1:0] q_ap, q_an, q_bp, q_bn;
wire[BITS-1:0] in_a_0, in_a_1, in_a_2;
wire[BITS-1:0] in_b_0, in_b_1, in_b_2;

//DATA_OUT_OF_MULT
wire[BITS_OUT-1:0] prod;
wire[BITS_OUT-1:0] out_cp_0, out_cp_1, out_cp_2;
wire[BITS_OUT-1:0] out_cn_0, out_cn_1, out_cn_2;

genvar i;

//MULTIPLIER
rRp_mult #(.RADIX(RADIX), .WIDTH(DIGITS)) mult(
	.clock(pll_clk), .x_in(in_a_2), .y_in(in_b_2), .p_out(prod)
	);
//CLOCK DIVIDER
clock_div clk_div(
	.clock(pll_clk), .clk_pos(clk_pos), .clk_neg(clk_neg));

//RAMS
dpRam #(.ID(2), .DATA_WIDTH(W32), .ADDR_WIDTH(ADDR_WIDTH)) ram_ap(
	.avalon_clock(avalon_clk), .resetn(resetn), .read(read_rap), .write(write_rap), 
	.address(address_rap), .writedata(writedata_rap), .readdata(readdata_rap),
	.ram_clock(clk_pos), .we_arith(1'b0), .addr_arith(addr_ap), .q_arith(q_ap)
	);

dpRam #(.ID(3), .DATA_WIDTH(W32), .ADDR_WIDTH(ADDR_WIDTH)) ram_an(
	.avalon_clock(avalon_clk), .resetn(resetn), .read(read_ran), .write(write_ran), 
	.address(address_ran), .writedata(writedata_ran), .readdata(readdata_ran),
	.ram_clock(clk_neg), .we_arith(1'b0), .addr_arith(addr_an), .q_arith(q_an)
	);

dpRam #(.ID(4), .DATA_WIDTH(W32), .ADDR_WIDTH(ADDR_WIDTH)) ram_bp(
	.avalon_clock(avalon_clk), .resetn(resetn), .read(read_rbp), .write(write_rbp), 
	.address(address_rbp), .writedata(writedata_rbp), .readdata(readdata_rbp),
	.ram_clock(clk_pos), .we_arith(1'b0), .addr_arith(addr_bp), .q_arith(q_bp)
	);

dpRam #(.ID(5), .DATA_WIDTH(W32), .ADDR_WIDTH(ADDR_WIDTH)) ram_bn(
	.avalon_clock(avalon_clk), .resetn(resetn), .read(read_rbn), .write(write_rbn), 
	.address(address_rbn), .writedata(writedata_rbn), .readdata(readdata_rbn),
	.ram_clock(clk_neg), .we_arith(1'b0), .addr_arith(addr_bn), .q_arith(q_bn)
	);

dpRam #(.ID(6), .DATA_WIDTH(W32), .ADDR_WIDTH(ADDR_WIDTH)) ram_cp(
	.avalon_clock(avalon_clk), .resetn(resetn), .read(read_rcp), .write(write_rcp), 
	.address(address_rcp), .writedata(writedata_rcp), .readdata(readdata_rcp),
	.ram_clock(clk_pos), .we_arith(we_cp_5), .addr_arith(addr_cp_5), .data_arith(out_cp_2)
	);

dpRam #(.ID(7), .DATA_WIDTH(W32), .ADDR_WIDTH(ADDR_WIDTH)) ram_cn(
	.avalon_clock(avalon_clk), .resetn(resetn), .read(read_rcn), .write(write_rcn), 
	.address(address_rcn), .writedata(writedata_rcn), .readdata(readdata_rcn),
	.ram_clock(clk_neg), .we_arith(we_cn_5), .addr_arith(addr_cn_5), .data_arith(out_cn_2)
	);

//TEST CONTROL UNIT
testControlUnit #(.ID(8)) tcu(
	.avalon_clock(avalon_clk), .resetn(resetn), .read(read_tcu), .write(write_tcu), 
	.address(address_tcu), .writedata(writedata_tcu), .readdata(readdata_tcu),
	.pll_clock_pos(clk_pos), .pll_clock_neg(clk_neg), 
	.r_addr_a_pos(addr_ap), .r_addr_a_neg(addr_an), .r_addr_b_pos(addr_bp), .r_addr_b_neg(addr_bn),
	.we_pos(we_pline_p[0]), .w_addr_pos(addr_pline_p[0]),
	.we_neg(we_pline_n[0]), .w_addr_neg(addr_pline_n[0]),
	.pll_lock(pll_lock)
	);

//POSITIVE MULT DELAYS
generate
	if(RADIX>=1) begin
		for(i=0;i<ADELAY;i=i+1) begin: ad_pline_p
			addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cp(
				.pll_clock(clk_pos), .addr_in(addr_pline_p[i]), .addr_out(addr_pline_p[i+1]),
				.e_in(we_pline_p[i]), .e_out(we_pline_p[i+1])
				);
		end
		addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cp_0(
			.pll_clock(clk_pos), .addr_in(addr_pline_p[ADELAY]), .addr_out(addr_cp_1),
			.e_in(we_pline_p[ADELAY]), .e_out(we_cp_1)
		);
	end else begin
		addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cp_0(
			.pll_clock(clk_pos), .addr_in(addr_pline_p[0]), .addr_out(addr_cp_1),
			.e_in(we_pline_p[0]), .e_out(we_cp_1)
		);
	end
endgenerate


addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cp_1(
	.pll_clock(clk_pos), .addr_in(addr_cp_1), .addr_out(addr_cp_2),
	.e_in(we_cp_1), .e_out(we_cp_2)
	);
addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cp_2(
	.pll_clock(clk_pos), .addr_in(addr_cp_2), .addr_out(addr_cp_3),
	.e_in(we_cp_2), .e_out(we_cp_3)
	);
// addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cp_3(
// 	.pll_clock(clk_pos), .addr_in(addr_cp_3), .addr_out(addr_cp_4),
// 	.e_in(we_cp_3), .e_out(we_cp_4)
// 	);
addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cp_4(
	.pll_clock(clk_pos), .addr_in(addr_cp_3), .addr_out(addr_cp_5),
	.e_in(we_cp_3), .e_out(we_cp_5)
	);

//NEGATIVE MULT DELAYS
generate
	if(RADIX>=1) begin
		for(i=0;i<ADELAY;i=i+1) begin: ad_pline_n
			addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cn(
				.pll_clock(clk_neg), .addr_in(addr_pline_n[i]), .addr_out(addr_pline_n[i+1]),
				.e_in(we_pline_n[i]), .e_out(we_pline_n[i+1])
				);
		end
		addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cn_0(
			.pll_clock(clk_neg), .addr_in(addr_pline_n[ADELAY]), .addr_out(addr_cn_1),
			.e_in(we_pline_n[ADELAY]), .e_out(we_cn_1)
			);
	end else begin
		addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cn_0(
			.pll_clock(clk_neg), .addr_in(addr_pline_n[0]), .addr_out(addr_cn_1),
			.e_in(we_pline_n[0]), .e_out(we_cn_1)
			);
	end
endgenerate

addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cn_1(
	.pll_clock(clk_neg), .addr_in(addr_cn_1), .addr_out(addr_cn_2),
	.e_in(we_cn_1), .e_out(we_cn_2)
	);
addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cn_2(
	.pll_clock(clk_neg), .addr_in(addr_cn_2), .addr_out(addr_cn_3),
	.e_in(we_cn_2), .e_out(we_cn_3)
	);
// addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cn_3(
// 	.pll_clock(clk_neg), .addr_in(addr_cn_3), .addr_out(addr_cn_4),
// 	.e_in(we_cn_3), .e_out(we_cn_4)
// 	);
addr_delay #(.ADDR_WIDTH(ADDR_WIDTH)) ad_cn_4(
	.pll_clock(clk_neg), .addr_in(addr_cn_3), .addr_out(addr_cn_5),
	.e_in(we_cn_3), .e_out(we_cn_5)
	);

//DATA A PATH TO MULT
clocked_mux #(.IN_WIDTH(BITS), .OUT_WIDTH(BITS), .INVERT(1)) clocked_mux_a(
	.clock(pll_clk), .pos_in(q_ap), .neg_in(q_an), .q_out(in_a_1)
	);
// data_delay #(.WIDTH(BITS)) dd_a_0(
// 	.pll_clock(pll_clk), .data_in(in_a_0), .data_out(in_a_1)
// 	);
data_delay #(.WIDTH(BITS)) dd_a_1(
	.pll_clock(pll_clk), .data_in(in_a_1), .data_out(in_a_2)
	);

//DATA B PATH TO MULT
clocked_mux #(.IN_WIDTH(BITS), .OUT_WIDTH(BITS), .INVERT(1)) clocked_mux_b(
	.clock(pll_clk), .pos_in(q_bp), .neg_in(q_bn), .q_out(in_b_1)
	);
// data_delay #(.WIDTH(BITS)) dd_b_0(
// 	.pll_clock(pll_clk), .data_in(in_b_0), .data_out(in_b_1)
// 	);
data_delay #(.WIDTH(BITS)) dd_b_1(
	.pll_clock(pll_clk), .data_in(in_b_1), .data_out(in_b_2)
	);

//DATA C POS PATH FROM MULT
generate
if((((DIGITS+1)/2 - DIGITS/2) == 1) && RADIX>=2) begin //if odd number of pipeline stages, add extra data offset
	data_delay #(.WIDTH(BITS_OUT)) dd_cp_0(
		.pll_clock(pll_clk), .data_in(prod), .data_out(out_cp_0)
		);
	data_delay #(.WIDTH(BITS_OUT)) dd_cp_1(
		.pll_clock(pll_clk), .data_in(out_cp_0), .data_out(out_cp_1)
		);
end
else begin
	data_delay #(.WIDTH(BITS_OUT)) dd_cp_0(
	.pll_clock(pll_clk), .data_in(prod), .data_out(out_cp_1)
	);
end
endgenerate
mc_data_delay #(.WIDTH(BITS_OUT), .INVERT(1)) mc_dd_cp(
	.pll_clock(pll_clk), .div_clock(clk_pos), .data_in(out_cp_1), .data_out(out_cp_2)
	);

//DATA C NEG PATH FROM MULT
generate
if((((DIGITS+1)/2 - DIGITS/2) == 1) && RADIX>=2) begin //if odd number of pipeline stages, add extra data offset
	data_delay #(.WIDTH(BITS_OUT)) dd_cn_0(
		.pll_clock(pll_clk), .data_in(prod), .data_out(out_cn_0)
		);
	data_delay #(.WIDTH(BITS_OUT)) dd_cn_1(
		.pll_clock(pll_clk), .data_in(out_cn_0), .data_out(out_cn_1)
		);
end
else begin
	data_delay #(.WIDTH(BITS_OUT)) dd_cn_0(
	.pll_clock(pll_clk), .data_in(prod), .data_out(out_cn_1)
	);
end
endgenerate
mc_data_delay #(.WIDTH(BITS_OUT), .INVERT(0)) mc_dd_cn(
	.pll_clock(pll_clk), .div_clock(clk_neg), .data_in(out_cn_1), .data_out(out_cn_2)
	);

endmodule