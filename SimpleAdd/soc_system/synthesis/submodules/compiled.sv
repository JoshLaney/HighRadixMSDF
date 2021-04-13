// !!!!!! This generated VQM is intended for Academic use or Internal Altera use only !!!!!!
// Functionality may not be correct on the programmed device or in simulation


// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus II License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// VENDOR "Altera"
// PROGRAM "Quartus II 64-Bit"
// VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Full Version"

// DATE "09/11/2015 22:29:56"

module 	compiled (
	avs_s0_address,
	avs_s0_read,
	avs_s0_readdata,
	avs_s0_write,
	avs_s0_writedata,
	avs_s0_waitrequest,
	clock_clk,
	reset_reset,
	fclk,
//	fclk_inst_si,
//	fclk_inst_en,
//	fclk_inst_mode,
//	fclk_inst_sen,
	fclk_s);
input 	[7:0] avs_s0_address;
input 	avs_s0_read;
output 	[31:0] avs_s0_readdata;
input 	avs_s0_write;
input 	[31:0] avs_s0_writedata;
output 	avs_s0_waitrequest;
input 	clock_clk;
input 	reset_reset;
input 	fclk;
/*input*/ wire fclk_inst_si;
/*output*/ wire fclk_inst_en;
/*output*/ wire fclk_inst_mode;
/*output*/ wire fclk_inst_sen;
input 	fclk_s;

parameter ndsps = 0;

generate
if (ndsps == 0) begin
`include "compiled/dsp0/wrapper_inst.vqm"
end
else if (ndsps == 5) begin
`include "compiled/dsp5/wrapper_inst.vqm"
end
else if (ndsps == 9) begin
`include "compiled/dsp9/wrapper_inst.vqm"
end
else if (ndsps == 13) begin
`include "compiled/dsp13/wrapper_inst.vqm"
end
else if (ndsps == 17) begin
`include "compiled/dsp17/wrapper_inst.vqm"
end
else if (ndsps == 21) begin
`include "compiled/dsp21/wrapper_inst.vqm"
end
else if (ndsps == 25) begin
`include "compiled/dsp25/wrapper_inst.vqm"
end
endgenerate

endmodule 

(* altera_attribute = "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW" *)
module scan_counter(
        input clk, 
        input en, 
        input in, 
        input si,
        input se,
        output so);

wire [1:0] ff;
dffeas \ff[0] ( 
        .d(in),
        .clk(clk),
        //.asdata(),
        //.sload(fclk_inst_mode),
        .ena(en),
        .q(ff[0])
);
dffeas \ff[1] ( 
        .d(ff[0]),
        .clk(clk),
        //.asdata(),
        //.sload(fclk_inst_mode),
        .ena(en),
        .q(ff[1])
);

wire inc;
assign inc = ff[0] & ~ff[1];

parameter nbits = 9;
wire [nbits:0] sdata, q;
genvar i;
generate for (i=0; i < nbits; i=i+1) begin : g
dffeas f(.clk(clk), .ena(en & (inc | se)), .sload(1'b1), .asdata(sdata[i]), .q(sdata[i+1]));
defparam f.power_up = "low";
defparam f.is_wysiwyg = "true";
defparam f.dont_touch = "true";
end
endgenerate
assign sdata[0] = se ? si : sdata[9] ~^ sdata[5];
assign so = sdata[nbits];

endmodule
