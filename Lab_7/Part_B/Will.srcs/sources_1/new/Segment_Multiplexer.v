`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 05:22:32 AM
// Design Name: 
// Module Name: Segment_Multiplexer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Segment_Multiplexer(
    input clk,
    input reset,
    input [6:0] ones_lcd,
    input [6:0] tens_lcd,
    input [6:0] hundreds_lcd,
    input [6:0] thousands_lcd,
    output wire [3:0] enabled_lcd_out,
    output wire [6:0] lcd_out
);
//    // Connecting Wires -----------------------------------------------------------------------------
//    wire [6:0] ones_lcd;
//    wire [6:0] tens_lcd;
//    wire [6:0] hundreds_lcd;
//    wire [6:0] thousands_lcd;
    
    // LCD switching  -------------------------------------------------------------------------
    
    // LCD enable logic
    // keeps track of what we are enabling when not resetting
    reg [3:0] enabled_lcd_count;            
    
    // Start by enabling the first segment
    initial enabled_lcd_count = 4'b0001;
    
    // either output the count or enable all of them for the reset(active low)
    assign enabled_lcd_out = (reset) ? 7'hef : (~enabled_lcd_count);    

    // toggles which segment is enabled
    always@(posedge clk)
    begin                   
        // shift the toggle bit over 
        enabled_lcd_count = enabled_lcd_count << 1;     
        // set the count to 1 if the enable bit got shifted out                    
        if( enabled_lcd_count == 4'b0000) enabled_lcd_count = 4'b0001;   
    end
    
    // Counter Outputs -----------------------------------------------------------------------
//    lcd_output digit_decode_1(.bcd(in0), .segments(ones_lcd)); 
//    lcd_output digit_decode_2(.bcd(in1), .segments(tens_lcd)); 
//    lcd_output digit_decode_3(.bcd(in2), .segments(hundreds_lcd)); 
//    lcd_output digit_decode_4(.bcd(in3), .segments(thousands_lcd)); 
    
    // Output MUX ----------------------------------------------------------------------------
    // Brought to you by GPT
    assign lcd_out = (enabled_lcd_out == (~4'b0001)) ? ones_lcd :
                     (enabled_lcd_out == (~4'b0010)) ? tens_lcd :
                     (enabled_lcd_out == (~4'b0100)) ? hundreds_lcd :
                     (enabled_lcd_out == (~4'b1000)) ? thousands_lcd :
                     4'b0000;
                     
    // Debugging --------------------------------------------------------------------------------
    
    // Debugging BCD selection
//    assign OUT = (enabled_lcd_out == 4'b0001) ? ones :
//                     (enabled_lcd_out == 4'b0010) ? tens :
//                     (enabled_lcd_out == 4'b0100) ? hundreds :
//                     (enabled_lcd_out == 4'b1000) ? thousands :
//                     4'b0000;
//    assign OUT = ones_lcd;
endmodule
