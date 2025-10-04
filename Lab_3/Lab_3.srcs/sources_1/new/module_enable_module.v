`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2025 02:10:33 AM
// Design Name: 
// Module Name: module_enable_module
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


module module_enable_module(
    input clk,
    output wire [3:0] out
    );
    
    // LCD enable logic
    // keeps track of what we are enabling when not resetting
    reg [3:0] enabled_lcd_count;            
    
    // Start by enabling the first segment
    initial enabled_lcd_count = 4'b0001;
    
    // either output the count or enable all of them for the reset(active low)
    assign out = enabled_lcd_count;    

    // toggles which segment is enabled
    always@(posedge clk)
    begin                   
        // shift the toggle bit over 
        enabled_lcd_count = enabled_lcd_count << 1;     
        // set the count to 1 if the enable bit got shifted out                    
        if( enabled_lcd_count == 4'b0000) enabled_lcd_count = 4'b0001;   
    end
endmodule
