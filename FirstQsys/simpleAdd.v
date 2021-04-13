module simpleAdd (clock, resetn, writedata, readdata, write, read, address);

// signals for connecting to the Avalon fabric 
input clock, resetn, read, write;
input [2:0] address;
input [31:0] writedata;
output [31:0] readdata;

reg [31:0] a,b, readdata;
wire [32:0] c;

assign c = a + b;

always@(posedge clock) begin
	if(!resetn) begin
		a <= 32'b0;
		b <= 32'b0;
	end
	else begin
		if(write) begin
			case(address)
				3'b000: begin
					a<=writedata;
					b<= b;
				end
				3'b001: begin
					a<= a;
					b<=writedata;
				end
				default: begin
					a<= a;
					b<= b;
				end
			endcase
		end
		if(read) begin
			if(address == 3'b011)
				readdata <= c;
		end
	end
end

endmodule
