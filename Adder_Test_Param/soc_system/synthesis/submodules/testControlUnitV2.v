module testControlUnit (avalon_clock, pll_clock_pos, pll_clock_neg, resetn, writedata, readdata, write, read, address,
	r_addr_a_pos, r_addr_a_neg, r_addr_b_pos, r_addr_b_neg, w_addr_pos, w_addr_neg, we_pos, we_neg, we_read_a_pos, we_read_a_neg,
	we_read_b_pos, we_read_b_neg, pll_lock
	);

parameter ID = 1;
// signals for connecting to the Avalon fabric 
input avalon_clock, pll_clock_pos, pll_clock_neg, resetn, read, write, pll_lock;
input [2:0] address;
input [31:0] writedata;
output we_pos, we_neg, we_read_a_pos, we_read_a_neg, we_read_b_pos, we_read_b_neg;
output [10:0] r_addr_a_pos, r_addr_a_neg, r_addr_b_pos, r_addr_b_neg, w_addr_pos, w_addr_neg;
output [31:0] readdata;

reg [31:0] readdata;
reg [11:0] r_addr_pos_cnt, r_addr_neg_cnt, w_addr_pos_cnt, w_addr_neg_cnt, num, set_addr;
(* preserve="true" *) reg [11:0] set_addr_pos_1, set_addr_pos_2, set_addr_neg_1, set_addr_neg_2;
(* preserve="true" *) reg [11:0] num_pos_1, num_pos_2, num_neg_1, num_neg_2;
(* preserve="true" *) reg [11:0] w_addr_pos_delay, w_addr_neg_delay;
reg go_pos, go_neg, we_pos, we_neg, done_pos, done_neg;
(* preserve="true" *) reg we_pos_delay, we_neg_delay, go_pos_1, go_pos_2, go_neg_1, go_neg_2;
(* preserve="true" *) reg done_pos_1, done_pos_2, done_neg_1, done_neg_2;
 

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
				3'b011: readdata <= pll_lock;
				3'b100: readdata <= ID;
				default: ;
			endcase
		end
		//prvent metastability
		done_pos_1 <= done_pos;
		done_pos_2 <= done_pos_1;
		done_neg_1 <= done_neg;
		done_neg_2 <= done_neg_1;

		if(done_pos_2) go_pos <= 1'b0;
		if(done_neg_2) go_neg <= 1'b0;
	end
end

always@(posedge pll_clock_pos) begin
	//prevent metastability
	num_pos_1 <= num;
	go_pos_1 <= go_pos;
	go_pos_2 <= go_pos_1;
	num_pos_2 <= num_pos_1;
	set_addr_pos_1 <= set_addr;
	set_addr_pos_2 <= set_addr_pos_1;

	if(go_pos_2 && !done_pos) begin
		if(r_addr_pos_cnt!=num_pos_2) begin //assume r_addr_pos < num_pos
			we_pos_delay <= 1'b1;
			we_pos <= we_pos_delay;

			r_addr_pos_cnt <= r_addr_pos_cnt+12'b1;
			w_addr_pos_delay <= r_addr_pos_cnt;
			w_addr_pos_cnt <= w_addr_pos_delay;
		end
		else begin
			we_pos_delay <= 1'b0;
			we_pos <= we_pos_delay;

			w_addr_pos_delay <= r_addr_pos_cnt;
			w_addr_pos_cnt <= w_addr_pos_delay;

			done_pos <= ~we_pos_delay;
		end
	end
	else if(!go_pos_2) begin
		we_pos_delay <= 1'b0;
		we_pos <= we_pos_delay;

		r_addr_pos_cnt <= set_addr_pos_2;
		w_addr_pos_delay <= r_addr_pos_cnt;

		w_addr_pos_cnt <= w_addr_pos_delay;
		done_pos <= 1'b0;
	end
end

always@(posedge pll_clock_neg) begin
	//prevent metastability
	go_neg_1 <= go_neg;
	go_neg_2 <= go_neg_1;
	num_neg_1 <= num;
	num_neg_2 <= num_neg_1;
	set_addr_neg_1 <= set_addr;
	set_addr_neg_2 <= set_addr_neg_1;

	if(go_neg_2 && !done_neg) begin
		if(r_addr_neg_cnt!=num_neg_2) begin
			we_neg_delay <= 1'b1;
			we_neg <= we_neg_delay;

			r_addr_neg_cnt <= r_addr_neg_cnt+12'b1;
			w_addr_neg_delay <= r_addr_neg_cnt;
			w_addr_neg_cnt <= w_addr_neg_delay;
		end
		else begin
			we_neg_delay <= 1'b0;
			we_neg <= we_neg_delay;

			w_addr_neg_delay <= r_addr_neg_cnt;
			w_addr_neg_cnt <= w_addr_neg_delay;

			done_neg <= ~we_neg_delay;
		end
	end
	else if(!go_neg_2) begin
		we_neg_delay <= 1'b0;
		we_neg <= we_neg_delay;

		r_addr_neg_cnt <= set_addr_neg_2;
		w_addr_neg_delay <= r_addr_neg_cnt;
		w_addr_neg_cnt <= w_addr_neg_delay;

		done_neg <= 1'b0;
	end
end

endmodule