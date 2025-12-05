`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 10:07:03 PM
// Design Name: 
// Module Name: display_clk_divider
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


module display_clk_divider(clk, slow_clk, reset);
    input clk;
    input reset;
    output wire slow_clk;
    
    reg[15:0] count;
    reg pulse;
    
    initial count <= 0;

    assign slow_clk = count[15];

    always @(posedge clk)
    begin
        count = count + 1; 
    end


    
    assign slow_clk = pulse;


endmodule

