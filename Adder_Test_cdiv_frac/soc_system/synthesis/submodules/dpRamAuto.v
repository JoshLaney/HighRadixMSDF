module dpRam 
(
input avalon_clock, ram_clock, resetn, read, write, we_arith,
input [2:0] address,
input [10:0] addr_arith,
input [31:0] writedata, data_arith,
output [31:0] q_arith,
output reg [31:0] readdata
);

parameter ID = 1;

reg [10:0] addr_hps;
reg [31:0] data_hps;
wire [31:0] q_hps;
reg we_hps, w_inc, r_inc_inhibit;

always@(posedge avalon_clock) begin
	w_inc <= 1'b0;
	r_inc_inhibit <= 1'b0;
	if(write) begin
		case(address)
			3'b000: begin
				data_hps <= writedata;
				w_inc <= 1'b1;
			end
			3'b001: addr_hps <= writedata[10:0];
			3'b010: we_hps <= writedata[0];
			default: ;
		endcase
	end
	if(read) begin
		case(address)
			3'b000: begin
				readdata <= q_hps;
				if (~r_inc_inhibit)
					addr_hps <= addr_hps + 11'd1;
				r_inc_inhibit <= 1'b1;
			end
			3'b001: readdata <= addr_hps;
			3'b010: readdata <= we_hps;
			3'b011: readdata <= ID;
			default: ;
		endcase
	end
	if(w_inc) addr_hps <= addr_hps + 11'b1;
end

true_dual_port_ram_dual_clock #(.DATA_WIDTH(32), .ADDR_WIDTH(11)) dpr(
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


