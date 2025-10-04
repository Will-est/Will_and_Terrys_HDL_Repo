`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2025 10:17:58 PM
// Design Name: 
// Module Name: clk_divider
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

// made by gpt
module miles_divider (
    //----------Ports----------
    input               clk,            // Main input clock (e.g., 100MHz)
    input      [31:0]   clk_bit_select, // Selects counter bit [0-24] for the output
    input               reset,
    output wire         slow_clk        // Single-pulse output
    
);

    //----------Internal Signals----------
    // 25-bit register to act as the counter
    reg [31:0] counter;
    initial counter = 32'd0;
    //----------Logic----------
    // Continuously assign the selected bit of the counter to the output.
    // This is a combinational assignment.
    assign slow_clk = (counter == (clk_bit_select-1)) ;
    
    // This clocked block describes the behavior of the counter. 
    always @(posedge clk or posedge reset) begin
        if( reset == 1) begin
            // enables asynch reset
            counter <= 32'd0;
        end else if (slow_clk) begin
            // If the output is high, reset the counter on the next clock cycle.
            counter <= 32'd0;
        end
        else begin
            // If not in reset, increment the counter by 1 on each clock edge.
            counter <= counter + 1'b1;
        end        
    end
endmodule

