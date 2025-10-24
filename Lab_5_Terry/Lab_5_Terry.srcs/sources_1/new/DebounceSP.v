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
//  copied from last lab!
//////////////////////////////////////////////////////////////////////////////////


module DebounceSP(
    input clk,
    input btn_in,
    output btn_out
);
    
    reg Q1, Q2, Q3, Q3_bar;
    initial
    begin
        Q1 = 0;
        Q2 = 0;
        Q3 = 0;
    end

    always@(posedge clk)
    begin
        Q1 <=btn_in;
        Q2 <=Q1;
        Q3 <=Q2;
    end
    
//    assign Q3_bar = ~Q3;
    assign btn_out = Q2 & (~Q3);
endmodule

