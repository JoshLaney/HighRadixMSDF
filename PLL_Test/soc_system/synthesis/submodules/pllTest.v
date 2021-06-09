module pllTest (avalon_clock, pll_clock_0, pll_clock_1, pll_clock_2, resetn, writedata, readdata, 
	write, read, address, locked, pll_reset);

parameter ID = 1;
// signals for connecting to the Avalon fabric 
input avalon_clock, pll_clock_0, pll_clock_1, pll_clock_2, resetn, read, write, locked;
input [3:0] address;
input [31:0] writedata;
output [31:0] readdata;
output pll_reset;

reg [31:0] readdata;
reg [31:0] ref_count, c0_count, c1_count, c2_count, pr0_count, pr1_count, p01_count;
reg go, clear, phase_a, phase_b, phase_c, phase_d, phase_e, phase_f, pll_reset;
reg [31:0] count_num;
wire p_reset_1, p_reset_2, p_reset_3;


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
				4'b1011: begin
					pll_reset <= writedata[0];
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
				4'b0101: readdata <= c1_count;
				4'b0110: readdata <= c2_count;
				4'b0111: readdata <= pr0_count;
				4'b1000: readdata <= pr1_count;
				4'b1001: readdata <= p01_count;
				4'b1010: readdata <= locked;
				4'b1011: readdata <= pll_reset;
				4'b1100: readdata <= ID;
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

always@(posedge pll_clock_0) begin
	if(go) begin
		c0_count <= c0_count + 32'b1;
	end
	if(clear) begin
		c0_count <= 32'b0;
	end
end

always@(posedge pll_clock_1) begin
	if(go) begin
		c1_count <= c1_count + 32'b1;
	end
	if(clear) begin
		c1_count <= 32'b0;
	end
end

always@(posedge pll_clock_2) begin
	if(go) begin
		c2_count <= c2_count + 32'b1;
	end
	if(clear) begin
		c2_count <= 32'b0;
	end
end

//phase detector 1, ref clock vs clock 0
assign p_reset_1 = (phase_a & phase_b) | clear;

always@(posedge avalon_clock or posedge p_reset_1) begin
	if(p_reset_1) phase_a<=1'b0;
	else phase_a <= 1'b1;
end

always@(posedge pll_clock_0 or posedge p_reset_1) begin
	if(p_reset_1) phase_b<=1'b0;
	else phase_b <= 1'b1;
end

//sample phase detector
always@(negedge pll_clock_2) begin
	if(go & (phase_a | phase_b)) pr0_count <= pr0_count + 32'b1;
	else if(clear) pr0_count <= 32'b0;
	else pr0_count <= pr0_count;
end

//phase detector 2, ref clock vs clock 1
assign p_reset_2 = (phase_c & phase_d) | clear;

always@(posedge avalon_clock or posedge p_reset_2) begin
	if(p_reset_2) phase_c<=1'b0;
	else phase_c <= 1'b1;
end

always@(posedge pll_clock_1 or posedge p_reset_2) begin
	if(p_reset_2) phase_d<=1'b0;
	else phase_d <= 1'b1;
end

//sample phase detector
always@(negedge pll_clock_2) begin
	if(go & (phase_c | phase_d)) pr1_count <= pr1_count + 32'b1;
	else if(clear) pr1_count <= 32'b0;
	else pr1_count <= pr1_count;
end

//phase detector 3, clock 0 vs clock 1
assign p_reset_3 = (phase_e & phase_f) | clear;

always@(posedge pll_clock_0 or posedge p_reset_3) begin
	if(p_reset_3) phase_e<=1'b0;
	else phase_e <= 1'b1;
end

always@(posedge pll_clock_1 or posedge p_reset_3) begin
	if(p_reset_3) phase_f<=1'b0;
	else phase_f <= 1'b1;
end

//sample phase detector
always@(negedge pll_clock_2) begin
	if(go & (phase_e | phase_f)) p01_count <= p01_count + 32'b1;
	else if(clear) p01_count <= 32'b0;
	else p01_count <= p01_count;
end


endmodule


