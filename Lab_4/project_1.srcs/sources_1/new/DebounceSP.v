`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 04:16:01 PM
// Design Name: 
// Module Name: DebounceSP
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


module DebounceSP(
    input clk,
    input btn_in,
    output btn_out
);
    
    wire Q1, Q2, Q3, Q3_bar;
    // Debounce in Q2
    d_ff d1(.ff_clk(clk), .D(btn_in), .Q(Q1));
    d_ff d2(.ff_clk(clk), .D(Q1), .Q(Q2));
    // Single Pulse output
    d_ff d3(.ff_clk(clk), .D(Q2), .Q(Q3));
    
    assign Q3_bar = ~Q3;
    assign btn_out = Q2 & Q3_bar;
endmodule

