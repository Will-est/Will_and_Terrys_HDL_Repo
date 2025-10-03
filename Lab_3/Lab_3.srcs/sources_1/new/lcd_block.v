`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2025 11:48:35 PM
// Design Name: 
// Module Name: lcd_block
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


module lcd_block(
    input clk,
    input [3:0] ones,
    input [3:0] tens,
    input [3:0] hundreds,
    input [3:0] thousands,
    
    output [6:0] lcd_out,
    output [3:0] enabled_lcd_out
    
    //debugging
//    ,
//    output [6:0] OUT
    );
    
    // Connecting Wires -----------------------------------------------------------------------------
    wire [6:0] ones_lcd;
    wire [6:0] tens_lcd;
    wire [6:0] hundreds_lcd;
    wire [6:0] thousands_lcd;
    
    // LCD switching  -------------------------------------------------------------------------
    
    // LCD enable logic
    // keeps track of what we are enabling when not resetting
    reg [3:0] enabled_lcd_count;            
    
    // Start by enabling the first segment
    initial enabled_lcd_count = 4'b0001;
    
    // either output the count or enable all of them for the reset(active low)
    assign enabled_lcd_out = (~enabled_lcd_count);    

    // toggles which segment is enabled
    always@(posedge clk)
    begin                   
        // shift the toggle bit over 
        enabled_lcd_count = enabled_lcd_count << 1;     
        // set the count to 1 if the enable bit got shifted out                    
        if( enabled_lcd_count == 4'b0000) enabled_lcd_count = 4'b0001;   
    end
    
    // Counter Outputs -----------------------------------------------------------------------
    lcd_output digit_decode_1(.bcd(ones), .segments(ones_lcd)); 
    lcd_output digit_decode_2(.bcd(tens), .segments(tens_lcd)); 
    lcd_output digit_decode_3(.bcd(hundreds), .segments(hundreds_lcd)); 
    lcd_output digit_decode_4(.bcd(thousands), .segments(thousands_lcd)); 
    
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
