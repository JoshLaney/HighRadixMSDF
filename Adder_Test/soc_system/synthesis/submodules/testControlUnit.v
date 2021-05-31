module testControlUnit (avalon_clock, pll_clock_pos, pll_clock_neg, resetn, writedata, readdata, write, read, address,
	r_addr_a_pos, r_addr_a_neg, r_addr_b_pos, r_addr_b_neg, w_addr_pos, w_addr_neg, we_pos, we_neg, we_read_a_pos, we_read_a_neg,
	we_read_b_pos, we_read_b_neg
	);

parameter ID = 1;
// signals for connecting to the Avalon fabric 
input avalon_clock, pll_clock_pos, pll_clock_neg, resetn, read, write;
input [2:0] address;
input [31:0] writedata;
output we_pos, we_neg, we_read_a_pos, we_read_a_neg, we_read_b_pos, we_read_b_neg;
output [10:0] r_addr_a_pos, r_addr_a_neg, r_addr_b_pos, r_addr_b_neg, w_addr_pos, w_addr_neg;
output [31:0] readdata;

reg [31:0] readdata;
reg [11:0] r_addr_pos_cnt, r_addr_neg_cnt, w_addr_pos_cnt, w_addr_neg_cnt, num, set_addr;
(* preserve="true" *) reg [11:0] w_addr_pos_delay, w_addr_neg_delay;
reg go_pos, go_neg, we_pos, we_neg, done_pos, done_neg;
(* preserve="true" *) reg pos_delay, neg_delay;


assign r_addr_a_pos = r_addr_pos_cnt[10:0];
assign r_addr_a_neg = r_addr_neg_cnt[10:0];
assign r_addr_b_pos = r_addr_a_pos;
assign r_addr_b_neg = r_addr_a_neg;

assign w_addr_pos = w_addr_pos_cnt[10:0];
assign w_addr_neg = w_addr_neg_cnt[10:0];

assign we_read_a_pos = 1'b0;
assign we_read_a_neg = 1'b0;
assign we_read_b_pos = we_read_a_pos;
assign we_read_b_neg = we_read_a_neg; 



always@(posedge avalon_clock) begin
	if(!resetn) begin
		go_pos <= 1'b0;
		go_neg <= 1'b0;
		set_addr <= 12'b0;
		num <= 12'b0;
	end
	else begin
		if(write) begin
			case(address)
				3'b000: begin
					go_pos <= writedata[0];
					go_neg <= writedata[0];
				end
				3'b001: begin
					set_addr <= {1'b0, writedata[10:0]};
				end
				3'b010: begin
					num <= writedata[11:0];
				end
				default: ;
			endcase
		end
		if(read) begin
			case(address)
				3'b000: readdata <= (go_pos & go_neg);
				3'b010: readdata <= num;
				3'b011: readdata <= ID;
				default: ;
			endcase
		end
		if(done_pos) go_pos <= 0;
		if(done_neg) go_neg <= 0;
	end
end

always@(posedge pll_clock_pos) begin
	if(go_pos && !done_pos) begin
		if(r_addr_pos_cnt<num) begin
			we_pos <= 1'b1;
			w_addr_pos_cnt <= w_addr_pos_delay;
			w_addr_pos_delay <= r_addr_pos_cnt;
			r_addr_pos_cnt <= r_addr_pos_cnt+12'b1;
		end
		else begin
			w_addr_pos_cnt <= w_addr_pos_delay;
			done_pos <= pos_delay;
			we_pos <= ~pos_delay;
			pos_delay <= 1'b1;
		end
	end
	else if(!go_pos) begin
		done_pos <= 0;
		pos_delay <= 1'b0;
		r_addr_pos_cnt <= set_addr;
		w_addr_pos_delay <= r_addr_pos_cnt;
		w_addr_pos_cnt <= w_addr_pos_delay;
	end
end

always@(posedge pll_clock_neg) begin
	if(go_neg && !done_neg) begin
		if(r_addr_neg_cnt<num) begin
			we_neg <= 1'b1;
			w_addr_neg_cnt <= w_addr_neg_delay;
			w_addr_neg_delay <= r_addr_neg_cnt;
			r_addr_neg_cnt <= r_addr_neg_cnt+12'b1;
		end
		else begin
			w_addr_neg_cnt <= w_addr_neg_delay;
			done_neg <= neg_delay;
			we_neg <= ~neg_delay;
			neg_delay <= 1'b1;
		end
	end
	else if(!go_neg) begin
		done_neg <= 0;
		neg_delay <= 1'b0;
		r_addr_neg_cnt <= set_addr;
		w_addr_neg_delay <= r_addr_neg_cnt;
		w_addr_neg_cnt <= w_addr_neg_delay;
	end
end

endmodule
