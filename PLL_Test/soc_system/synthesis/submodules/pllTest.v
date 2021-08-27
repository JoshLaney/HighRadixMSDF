module pllTest (avalon_clock, pll_clock, resetn, writedata, readdata, 
	write, read, address, locked);

parameter ID = 1;
// signals for connecting to the Avalon fabric 
input avalon_clock, pll_clock, resetn, read, write, locked;
input [3:0] address;
input [31:0] writedata;
output [31:0] readdata;

reg [31:0] readdata;
reg [31:0] ref_count, c0_count;
reg go, clear;
reg [31:0] count_num;


always@(posedge avalon_clock) begin
	if(!resetn) begin
		go <= 1'b0;
		count_num <= 32'b0;
		ref_count <= 32'b1;
		clear <= 1'b1;
	end
	else begin
		if(write) begin
			case(address)
				4'b0000: begin
					go <= writedata[0];
					clear <= 1'b0;
				end
				4'b0001: begin
					count_num <= writedata;
				end
				4'b0010: begin
					ref_count <= 32'b1;
					clear <= 1'b1;
				end
				default: ;
			endcase
		end
		if(read) begin
			case(address)
				4'b0000: readdata <= go;
				4'b0001: readdata <= count_num;
				4'b0010: readdata <= clear;
				4'b0011: readdata <= ref_count;
				4'b0100: readdata <= c0_count;
				4'b0101: readdata <= locked;
				4'b0110: readdata <= ID;
				default: ;
			endcase
		end
		if(go) begin
			if(ref_count<count_num) begin
				ref_count <= ref_count + 32'b1;
			end
			else begin
				go <= 1'b0;
			end
		end
	end
end

always@(posedge pll_clock) begin
	if(go) begin
		c0_count <= c0_count + 32'b1;
	end
	if(clear) begin
		c0_count <= 32'b0;
	end
end

endmodule


