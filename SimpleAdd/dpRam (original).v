module dpRam 
(
	clock, resetn, writedata, readdata, write, read, address,
	data_arith, addr_arith, we_arith, q_arith
);

// signals for connecting to the Avalon fabric
input clock, resetn, read, write, we_arith;
input [2:0] address;
input [10:0] addr_arith;
input [31:0] writedata, data_arith;
output [31:0] readdata, q_arith;

reg [10:0] addr;
reg [31:0] readdata, ramword, writeword, q_arith;
reg we, incr_inhibit;
(* ramstyle = "M10K" *) reg [31:0] ram[2**11-1:0];

always@(posedge clock) begin
	incr_inhibit <= 1'd0;
	if(write) begin
		case(address)
			3'b000: begin
				if(we)
				begin
					writeword <= writedata;
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
	if(we) begin
		ram[addr] <= writeword;
		ramword <= writeword;
	end
	else ramword <= ram[addr];
end

always@(posedge clock) begin
	if(we_arith) begin
		ram[addr_arith] = data_arith;
		q_arith <= data_arith;
	end
	else q_arith <= ram[addr_arith];
end

endmodule
