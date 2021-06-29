module dpRam 
(
input avalon_clock, ram_clock, resetn, read, write, we_arith,
input [4:0] address,
input [10:0] addr_arith,
input [31:0] writedata, 
input [DATA_WIDTH-1:0] data_arith,
output [DATA_WIDTH-1:0] q_arith,
output reg [31:0] readdata
);

parameter ID = 1;
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 11;
//localparam DIV_32 = (DATA_WIDTH+31)/32;

reg [10:0] addr_hps;
reg [511:0] data_hps;
wire [511:0] q_hps;
reg we_hps, w_inc, r_inc_inhibit;

integer i,j;

always@(posedge avalon_clock) begin
	w_inc <= 1'b0;
	r_inc_inhibit <= 1'b0;
	if(write) begin
		if(address==0) begin
			data_hps[31:0] <= writedata;
			w_inc<=1'b1;
		end
		else if(address==1) addr_hps <= writedata[10:0];
		else if(address==2) we_hps <= writedata[0];
		else begin
			for(i = 1; i<16; i= i+1) begin
				if(address==(i+3)) data_hps[i*32+:32] <= writedata;
			end
		end
	end
	if(read) begin
		if(address==0) begin
			readdata <= q_hps[31:0];
			if (~r_inc_inhibit)
				addr_hps <= addr_hps + 11'd1;
			r_inc_inhibit <= 1'b1;
		end
		else if (address==1) readdata <= addr_hps;
		else if (address==2) readdata <= we_hps;
		else if (address==3) readdata <= ID;
		else begin
			for(j = 1; j<16; j = j+1) begin
				if (address==(j+3)) readdata <= q_hps[32*j+:32];
			end
		end
	end
	if(w_inc) addr_hps <= addr_hps + 11'b1;
end

// always@(posedge avalon_clock) begin
// 	w_inc <= 1'b0;
// 	r_inc_inhibit <= 1'b0;
// 	if(write) begin
// 		case(address)
// 			0: begin
// 				data_hps <= writedata;
// 				w_inc<=1'b1;
// 			end
// 			1: addr_hps <= writedata[10:0];
// 			2: we_hps <= writedata[0];
// 			default: ;
// 		endcase
// 	end
// 	if(read) begin
// 			0: begin
// 				readdata <= q_hps[31:0];
// 				if (~r_inc_inhibit)
// 					addr_hps <= addr_hps + 11'd1;
// 				r_inc_inhibit <= 1'b1;
// 			end
// 			1: readdata <= addr_hps;
// 			2: readdata <= we_hps;
// 			3: readdata <= ID;
// 			default: ;
// 		endcase
// 	end
// 	if(w_inc) addr_hps <= addr_hps + 11'b1;
// end

// generate
// 	genvar i;
// 	for(i=1; i<16; i=i+1) begin : large_widths
// 		always@(posedge avalon_clock) begin
// 			if(write) begin
// 				if(address==(i+3)) data_hps[i*32 +: 32] <= writedata;
// 			end
// 			if(read) begin
// 				if(address==(i+3)) readdata <= q_hps[i*32 +: 32];
// 			end
// 		end
// 	end
// endgenerate

// generate
// if(DATA_WIDTH<=32) begin

// 	always@(posedge avalon_clock) begin
// 		w_inc <= 1'b0;
// 		r_inc_inhibit <= 1'b0;
// 		if(write) begin
// 			case(address)
// 				4'b0000: begin
// 					data_hps <= writedata[DATA_WIDTH-1:0];
// 					w_inc<=1'b1;
// 				end
// 				4'b0001: addr_hps <= writedata[10:0];
// 				4'b0010: we_hps <= writedata[0];
// 				default: ;
// 			endcase
// 		end
// 		if(read) begin
// 			case(address)
// 				4'b0000: begin
// 					readdata[DATA_WIDTH-1:0] <= q_hps;
// 					if (~r_inc_inhibit)
// 						addr_hps <= addr_hps + 11'd1;
// 					r_inc_inhibit <= 1'b1;
// 				end
// 				4'b0001: readdata <= addr_hps;
// 				4'b0010: readdata <= we_hps;
// 				4'b1010: readdata <= ID;
// 				default: ;
// 			endcase
// 		end
// 		if(w_inc) addr_hps <= addr_hps + 11'b1;
// 	end

// end else if(DATA_WIDTH>32 && DATA_WIDTH<=64) begin

// 	always@(posedge avalon_clock) begin
// 		w_inc <= 1'b0;
// 		r_inc_inhibit <= 1'b0;
// 		if(write) begin
// 			case(address)
// 				4'b0000: begin 
// 					data_hps[31:0] <= writedata;
// 					w_inc<=1'b1;
// 				end
// 				4'b0001: addr_hps <= writedata[10:0];
// 				4'b0010: we_hps <= writedata[0];
// 				4'b0011: data_hps[DATA_WIDTH-1:32] <= writedata[(DATA_WIDTH-32)-1:0];
// 				default: ;
// 			endcase
// 		end
// 		if(read) begin
// 			case(address)
// 				4'b0000: begin
// 					readdata <= q_hps[31:0];
// 					if (~r_inc_inhibit)
// 						addr_hps <= addr_hps + 11'd1;
// 					r_inc_inhibit <= 1'b1;
// 				end
// 				4'b0001: readdata <= addr_hps;
// 				4'b0010: readdata <= we_hps;
// 				4'b0011: readdata[(DATA_WIDTH-32)-1:0] <= q_hps[DATA_WIDTH-1:32];
// 				4'b1010: readdata <= ID;
// 				default: ;
// 			endcase
// 		end
// 		if(w_inc) addr_hps <= addr_hps + 11'b1;
// 	end

// end else if (DATA_WIDTH>64 && DATA_WIDTH<=96) begin

// 	always@(posedge avalon_clock) begin
// 		w_inc <= 1'b0;
// 		r_inc_inhibit <= 1'b0;
// 		if(write) begin
// 			case(address)
// 				4'b0000: begin 
// 					data_hps[31:0] <= writedata;
// 					w_inc<=1'b1;
// 				end
// 				4'b0001: addr_hps <= writedata[10:0];
// 				4'b0010: we_hps <= writedata[0];
// 				4'b0011: data_hps[63:32] <= writedata;
// 				4'b0100: data_hps[DATA_WIDTH-1:64] <= writedata[(DATA_WIDTH-64)-1:0];
// 				default: ;
// 			endcase
// 		end
// 		if(read) begin
// 			case(address)
// 				4'b0000: begin
// 					readdata <= q_hps[31:0];
// 					if (~r_inc_inhibit)
// 						addr_hps <= addr_hps + 11'd1;
// 					r_inc_inhibit <= 1'b1;
// 				end
// 				4'b0001: readdata <= addr_hps;
// 				4'b0010: readdata <= we_hps;
// 				4'b0011: readdata <= q_hps[63:32];
// 				4'b0100: readdata[(DATA_WIDTH-64)-1:0] <= q_hps[DATA_WIDTH-1:64];
// 				4'b1010: readdata <= ID;
// 				default: ;
// 			endcase
// 		end
// 		if(w_inc) addr_hps <= addr_hps + 11'b1;
// 	end

// end else if (DATA_WIDTH>96 && DATA_WIDTH<=128) begin

// 	always@(posedge avalon_clock) begin
// 		w_inc <= 1'b0;
// 		r_inc_inhibit <= 1'b0;
// 		if(write) begin
// 			case(address)
// 				4'b0000: begin 
// 					data_hps[31:0] <= writedata;
// 					w_inc<=1'b1;
// 				end
// 				4'b0001: addr_hps <= writedata[10:0];
// 				4'b0010: we_hps <= writedata[0];
// 				4'b0011: data_hps[63:32] <= writedata;
// 				4'b0100: data_hps[95:64] <= writedata;
// 				4'b0101: data_hps[DATA_WIDTH-1:96] <= writedata[(DATA_WIDTH-96)-1:0];
// 				default: ;
// 			endcase
// 		end
// 		if(read) begin
// 			case(address)
// 				4'b0000: begin
// 					readdata <= q_hps[31:0];
// 					if (~r_inc_inhibit)
// 						addr_hps <= addr_hps + 11'd1;
// 					r_inc_inhibit <= 1'b1;
// 				end
// 				4'b0001: readdata <= addr_hps;
// 				4'b0010: readdata <= we_hps;
// 				4'b0011: readdata <= q_hps[63:32];
// 				4'b0100: readdata <= q_hps[95:64];
// 				4'b0101: readdata[(DATA_WIDTH-96)-1:0] <= q_hps[DATA_WIDTH-1:96];
// 				4'b1010: readdata <= ID;
// 				default: ;
// 			endcase
// 		end
// 		if(w_inc) addr_hps <= addr_hps + 11'b1;
// 	end

// end else if (DATA_WIDTH>128 && DATA_WIDTH<=160) begin

// 	always@(posedge avalon_clock) begin
// 		w_inc <= 1'b0;
// 		r_inc_inhibit <= 1'b0;
// 		if(write) begin
// 			case(address)
// 				4'b0000: begin 
// 					data_hps[31:0] <= writedata;
// 					w_inc<=1'b1;
// 				end
// 				4'b0001: addr_hps <= writedata[10:0];
// 				4'b0010: we_hps <= writedata[0];
// 				4'b0011: data_hps[63:32] <= writedata;
// 				4'b0100: data_hps[95:64] <= writedata;
// 				4'b0101: data_hps[127:96] <= writedata;
// 				4'b0110: data_hps[DATA_WIDTH-1:128] <= writedata[(DATA_WIDTH-128)-1:0];
// 				default: ;
// 			endcase
// 		end
// 		if(read) begin
// 			case(address)
// 				4'b0000: begin
// 					readdata <= q_hps[31:0];
// 					if (~r_inc_inhibit)
// 						addr_hps <= addr_hps + 11'd1;
// 					r_inc_inhibit <= 1'b1;
// 				end
// 				4'b0001: readdata <= addr_hps;
// 				4'b0010: readdata <= we_hps;
// 				4'b0011: readdata <= q_hps[63:32];
// 				4'b0100: readdata <= q_hps[95:64];
// 				4'b0101: readdata <= q_hps[127:96];
// 				4'b0110: readdata[(DATA_WIDTH-128)-1:0] <= q_hps[DATA_WIDTH-1:128];
// 				4'b1010: readdata <= ID;
// 				default: ;
// 			endcase
// 		end
// 		if(w_inc) addr_hps <= addr_hps + 11'b1;
// 	end

// end else if (DATA_WIDTH>160 && DATA_WIDTH<=192) begin

// 	always@(posedge avalon_clock) begin
// 		w_inc <= 1'b0;
// 		r_inc_inhibit <= 1'b0;
// 		if(write) begin
// 			case(address)
// 				4'b0000: begin 
// 					data_hps[31:0] <= writedata;
// 					w_inc<=1'b1;
// 				end
// 				4'b0001: addr_hps <= writedata[10:0];
// 				4'b0010: we_hps <= writedata[0];
// 				4'b0011: data_hps[63:32] <= writedata;
// 				4'b0100: data_hps[95:64] <= writedata;
// 				4'b0101: data_hps[127:96] <= writedata;
// 				4'b0110: data_hps[159:128] <= writedata;
// 				4'b0111: data_hps[DATA_WIDTH-1:160] <= writedata[(DATA_WIDTH-160)-1:0];
// 				default: ;
// 			endcase
// 		end
// 		if(read) begin
// 			case(address)
// 				4'b0000: begin
// 					readdata <= q_hps[31:0];
// 					if (~r_inc_inhibit)
// 						addr_hps <= addr_hps + 11'd1;
// 					r_inc_inhibit <= 1'b1;
// 				end
// 				4'b0001: readdata <= addr_hps;
// 				4'b0010: readdata <= we_hps;
// 				4'b0011: readdata <= q_hps[63:32];
// 				4'b0100: readdata <= q_hps[95:64];
// 				4'b0101: readdata <= q_hps[127:96];
// 				4'b0110: readdata <= q_hps[159:128];
// 				4'b0111: readdata[(DATA_WIDTH-160)-1:0] <= q_hps[DATA_WIDTH-1:160];
// 				4'b1010: readdata <= ID;
// 				default: ;
// 			endcase
// 		end
// 		if(w_inc) addr_hps <= addr_hps + 11'b1;
// 	end

// end else if (DATA_WIDTH>192 && DATA_WIDTH<=224) begin

// 	always@(posedge avalon_clock) begin
// 		w_inc <= 1'b0;
// 		r_inc_inhibit <= 1'b0;
// 		if(write) begin
// 			case(address)
// 				4'b0000: begin 
// 					data_hps[31:0] <= writedata;
// 					w_inc<=1'b1;
// 				end
// 				4'b0001: addr_hps <= writedata[10:0];
// 				4'b0010: we_hps <= writedata[0];
// 				4'b0011: data_hps[63:32] <= writedata;
// 				4'b0100: data_hps[95:64] <= writedata;
// 				4'b0101: data_hps[127:96] <= writedata;
// 				4'b0110: data_hps[159:128] <= writedata;
// 				4'b0111: data_hps[191:160] <= writedata;
// 				4'b1000: data_hps[DATA_WIDTH-1:192] <= writedata[(DATA_WIDTH-192)-1:0];
// 				default: ;
// 			endcase
// 		end
// 		if(read) begin
// 			case(address)
// 				4'b0000: begin
// 					readdata <= q_hps[31:0];
// 					if (~r_inc_inhibit)
// 						addr_hps <= addr_hps + 11'd1;
// 					r_inc_inhibit <= 1'b1;
// 				end
// 				4'b0001: readdata <= addr_hps;
// 				4'b0010: readdata <= we_hps;
// 				4'b0011: readdata <= q_hps[63:32];
// 				4'b0100: readdata <= q_hps[95:64];
// 				4'b0101: readdata <= q_hps[127:96];
// 				4'b0110: readdata <= q_hps[159:128];
// 				4'b0111: readdata <= q_hps[191:160];
// 				4'b1000: readdata[(DATA_WIDTH-192)-1:0] <= q_hps[DATA_WIDTH-1:192];
// 				4'b1010: readdata <= ID;
// 				default: ;
// 			endcase
// 		end
// 		if(w_inc) addr_hps <= addr_hps + 11'b1;
// 	end

// end else begin

// 	always@(posedge avalon_clock) begin
// 		w_inc <= 1'b0;
// 		r_inc_inhibit <= 1'b0;
// 		if(write) begin
// 			case(address)
// 				4'b0000: begin 
// 					data_hps[31:0] <= writedata;
// 					w_inc<=1'b1;
// 				end
// 				4'b0001: addr_hps <= writedata[10:0];
// 				4'b0010: we_hps <= writedata[0];
// 				4'b0011: data_hps[63:32] <= writedata;
// 				4'b0100: data_hps[95:64] <= writedata;
// 				4'b0101: data_hps[127:96] <= writedata;
// 				4'b0110: data_hps[159:128] <= writedata;
// 				4'b0111: data_hps[191:160] <= writedata;
// 				4'b1000: data_hps[223:192] <= writedata;
// 				4'b1001: data_hps[DATA_WIDTH-1:224] <= writedata[(DATA_WIDTH-224)-1:0];
// 				default: ;
// 			endcase
// 		end
// 		if(read) begin
// 			case(address)
// 				4'b0000: begin
// 					readdata <= q_hps[31:0];
// 					if (~r_inc_inhibit)
// 						addr_hps <= addr_hps + 11'd1;
// 					r_inc_inhibit <= 1'b1;
// 				end
// 				4'b0001: readdata <= addr_hps;
// 				4'b0010: readdata <= we_hps;
// 				4'b0011: readdata <= q_hps[63:32];
// 				4'b0100: readdata <= q_hps[95:64];
// 				4'b0101: readdata <= q_hps[127:96];
// 				4'b0110: readdata <= q_hps[159:128];
// 				4'b0111: readdata <= q_hps[191:160];
// 				4'b1000: readdata <= q_hps[223:192];
// 				4'b1001: readdata[(DATA_WIDTH-224)-1:0] <= q_hps[DATA_WIDTH-1:224];
// 				4'b1010: readdata <= ID;
// 				default: ;
// 			endcase
// 		end
// 		if(w_inc) addr_hps <= addr_hps + 11'b1;
// 	end

// end endgenerate

true_dual_port_ram_dual_clock #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dpr(
.data_a(data_hps),
.data_b(data_arith),
.addr_a(addr_hps),
.addr_b(addr_arith),
.we_a(we_hps),
.we_b(we_arith),
.clk_a(avalon_clock),
.clk_b(ram_clock),
.q_a(q_hps),
.q_b(q_arith)
);


endmodule

// Quartus Prime Verilog Template
// True Dual Port RAM with single clock

// Quartus Prime Verilog Template
// True Dual Port RAM with dual clocks

module true_dual_port_ram_dual_clock
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk_a, clk_b,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge clk_a)
	begin
		// Port A 
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end

	always @ (posedge clk_b)
	begin
		// Port B 
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule


