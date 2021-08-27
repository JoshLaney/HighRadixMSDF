module dpRamTX
(
input avalon_clock, ram_clock, resetn, read, write,
input [2:0] address,
input [10:0] addr_arith,
input [31:0] writedata,
output [31:0] q_arith,
output reg [31:0] readdata
);

parameter ID = 1;

reg [10:0] addr_hps;
reg [31:0] data_hps;
reg we_hps, w_inc;

always@(posedge avalon_clock) begin
	w_inc <= 1'b0;
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
			3'b011: readdata <= ID;
			default: ;
		endcase
	end
	if(w_inc) addr_hps <= addr_hps + 11'b1;
end


true_dual_port_ram_single_clock_tx #(.DATA_WIDTH(32), .ADDR_WIDTH(11)) dpr(
.data_a(data_hps),
.addr_a(addr_hps),
.addr_b(addr_arith),
.we_a(we_hps),
.clk(ram_clock),
.q_b(q_arith)
);

endmodule

// Quartus Prime Verilog Template
// True Dual Port RAM with single clock

module true_dual_port_ram_single_clock_tx
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

