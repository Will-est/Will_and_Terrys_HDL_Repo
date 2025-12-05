`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 05:02:51 AM
// Design Name: 
// Module Name: debounce
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
module debounce (
    input clk,
    input button_in, // raw button input
    output button_out // debounced button output
    );
    
    reg QA;
    reg Kd;
    
     always @(posedge clk) begin
         QA <= button_in ;
         Kd <= QA;
     end
     
     assign button_out = (Kd && !QA);

endmodule