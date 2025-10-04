`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2025
// Design Name: BCD Counter
// Module Name: BCD_Counter
// Target Devices: 
// Tool Versions: 
// Description: A decade (0-9) counter with load, enable, up/down, and carry-out.
// 
//////////////////////////////////////////////////////////////////////////////////

module big_counter(
// inputs
    input enable,        // counter enable
//    input in,
    input reset,         // asynchronous reset
    input clk,           // clock
    input [3:0] Data,
    
    // outputs
    output reg [16:0] OUT // BCD output
);
    initial OUT = 17'd0;
    
    // Define constant load value that can be overwritten for the 2-Digit BCD

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset case
            OUT <= 17'd0;
        end 
        else if (enable) begin
            // LOAD = 0 → increment
            OUT <= OUT + 1; // increments
        end 
    end
    
endmodule