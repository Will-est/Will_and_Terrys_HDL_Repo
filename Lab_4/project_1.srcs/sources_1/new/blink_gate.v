`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 01:40:07 PM
// Design Name: 
// Module Name: blink_gate
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


module blink_gate(
    input clk, reset,
    input [1:0] mode,
    input tick_1hz,
    input tick_2hz,
    input [13:0] seconds_bin,
    output reg show 
    );
    
endmodule
