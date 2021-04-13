module ramAdd (clock, resetn, writedata, readdata, write, read, address,
	data_a, addr_a, we_a, q_a,
	data_b, addr_b, we_b, q_b,
	data_c, addr_c, we_c, q_c
	);

// signals for connecting to the Avalon fabric 
input clock, resetn, read, write;
input [2:0] address;
input [31:0] writedata, q_a, q_b, q_c;
output we_a, we_b, we_c;
output [10:0] addr_a, addr_b, addr_c;
output [31:0] readdata, data_a, data_b, data_c;

reg [31:0] readdata;
reg [11:0] r_addr, w_addr, num;
wire[31:0] data_c;
reg go, we_c;

assign data_c = q_a + q_b;

assign addr_a = r_addr[10:0];
assign addr_b = r_addr[10:0];
assign addr_c = w_addr[10:0];

assign we_a = 1'b0;
assign we_b = 1'b0;

assign data_a = 32'b0;
assign data_b = 32'b0;

always@(posedge clock) begin
	if(!resetn) begin
		go <= 1'b0;
		we_c <= 1'b0;
		r_addr <= 12'b0;
		w_addr <= 12'b0;
	end
	else begin
		if(write) begin
			case(address)
				3'b000: begin
					go<=writedata[0];
				end
				3'b001: begin
					r_addr<={1'b0, writedata[10:0]};
				end
				3'b010: begin
					num<=writedata[11:0];
				end
				default: ;
			endcase
		end
		else if(go) begin
			if(r_addr<num) begin
				we_c<=1'b1;
				w_addr<=r_addr;
				r_addr<=r_addr+12'b1;
			end
			else begin
				go <= 1'b0;
				we_c <= 1'b0;
			end
		end

		if(read) begin
			case(address)
				3'b000: readdata <= go;
				3'b010: readdata <= num;
				3'b011: readdata <= 32'h12345678;
				default: ;
			endcase
		end
	end
end

endmodule
