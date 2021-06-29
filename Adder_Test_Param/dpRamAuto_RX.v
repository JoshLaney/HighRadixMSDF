module dpRamRX 
(
input avalon_clock, ram_clock, resetn, read, write, we_arith,
input [2:0] address,
input [10:0] addr_arith,
input [31:0] writedata, data_arith,
output reg [31:0] readdata
);

parameter ID = 1;

reg [10:0] addr_hps;
wire [31:0] q_hps;
reg r_inc_inhibit;

always@(posedge avalon_clock) begin
	r_inc_inhibit <= 1'b0;
	if(write) begin
		case(address)
			3'b001: addr_hps <= writedata[10:0];
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
			3'b011: readdata <= ID;
			default: ;
		endcase
	end
end


true_dual_port_ram_single_clock_rx #(.DATA_WIDTH(32), .ADDR_WIDTH(11)) dpr(
.data_b(data_arith),
.addr_a(addr_hps),
.addr_b(addr_arith),
.we_b(we_arith),
.clk(ram_clock),
.q_a(q_hps)
);



endmodule

// Quartus Prime Verilog Template
// True Dual Port RAM with single clock

module true_dual_port_ram_single_clock_rx
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Port A 
	always @ (posedge clk)
	begin
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

	// Port B 
	always @ (posedge clk)
	begin
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

