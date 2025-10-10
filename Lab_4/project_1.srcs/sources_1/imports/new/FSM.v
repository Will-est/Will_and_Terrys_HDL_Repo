`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 01:00:16 AM
// Design Name: 
// Module Name: FSM
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


`timescale 1ns / 1ps

// This module was initially written by GPT and then modified
`timescale 1ns / 1ps


// Will's comment
module FSM (
    input wire clk, 
    input wire [13:0] count_1hz,
    input wire button,
    output wire [1:0] state,
    output wire fsm_out
);

    // State encoding based on count_1hz
    // 00 → count == 0
    // 01 → count < 200
    // 10 → count >= 200
    assign state = (count_1hz == 14'd0)   ? 2'b00 :
                   (count_1hz <  14'd200) ? 2'b01 :
                                            2'b10;

    // Sequential logic for fsm_out
//    always @(negedge clk) begin
//        if (button || (|count_1hz))  // if button is pressed OR count_1hz is nonzero
//            fsm_out <= 1'b1;
//        else
//            fsm_out <= 1'b0;
//    end
    assign fsm_out = ((button || count_1hz) && (~clk));
    

endmodule


