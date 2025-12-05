`timescale 1ns / 1ps

module Seven_Segment(
    input clk,
    input reset,
    input [15:0] sw,
    output [3:0] an,
    output [6:0] sseg
);
    wire [6:0] in0, in1, in2, in3;
    wire slow_clk;
    
//    hexto7Segment Decoders
    HexToSeg hex1(.seg_in(sw[3:0]), .seg_out(in0));  
    HexToSeg hex2(.seg_in(sw[7:4]), .seg_out(in1));   
    HexToSeg hex3(.seg_in(sw[11:8]), .seg_out(in2));   
    HexToSeg hex4(.seg_in(sw[15:12]), .seg_out(in3));   
    
    //clock divider
    display_clk_divider c5 (.clk(clk), .reset(reset), .slow_clk(slow_clk));
    
    //mux
    Segment_Multiplexer x6(
    .clk(slow_clk),
    .reset (reset),
    .ones_lcd (in0),
    .tens_lcd (in1),
    .hundreds_lcd (in2),
    .thousands_lcd (in3),
    .enabled_lcd_out (an),
    .lcd_out (sseg)
    );    

endmodule


