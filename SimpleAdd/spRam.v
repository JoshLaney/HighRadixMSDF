module spRam (clock, resetn, writedata, readdata, write, read, address);

// signals for connecting to the Avalon fabric
input clock, resetn, read, write;
input [2:0] address;
input [31:0] writedata;
output [31:0] readdata;

reg [10:0] addr;
reg [31:0] readdata, ramword;
reg we, incr_inhibit;
(* ramstyle = "M10K" *) reg [31:0] ram[2**11-1:0];

always@(posedge clock) begin
	incr_inhibit <= 1'd0;
	if(write) begin
		case(address)
			3'b000: begin
				if(we)
				begin
					ram[addr] <= writedata;
					addr <= addr + 10'd1;
				end
			end
			3'b001: addr <= writedata[10:0];
			3'b010: we <= writedata[0];
			default: ;
		endcase
	end
	if(read) begin
		case(address)
			3'b000: begin
				readdata <= ramword;
				if (~incr_inhibit)
					addr <= addr + 10'd1;
				incr_inhibit <= 1'd1;
			end
			3'b001: readdata <= addr;
			3'b010: readdata <= we;
			3'b011: readdata <= 32'h87654321;
			default: ;
		endcase
	end
end

always@(posedge clock) begin
	ramword <= ram[addr];
end

endmodule
