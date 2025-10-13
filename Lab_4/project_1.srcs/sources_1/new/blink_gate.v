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
    reg one_hz_phase, two_hz_phase;
    
    // 
    always @(posedge clk) begin
        if(tick_1hz)
            one_hz_phase <= ~one_hz_phase;
    end
    
    always @(posedge clk) begin
        if(tick_2hz)
            two_hz_phase <= ~two_hz_phase;
    end
        
    
    
    /* State Encoding
    00 -> count < 0             1 sec period 50% duty cycle
    01 -> 0 < count < 200       2 sec period 50% duty cycle
    10 -> count >= 200          no flash
    11 -> nothing               no flash
    */
    
    always @(*) begin
        case(mode)
            2'b00: show = two_hz_phase;
            2'b01: show = (seconds_bin[0] == 1'b0) & one_hz_phase;
            2'b10: show = 1'b1;
            2'b11: show = 1'b1;
        endcase
    end
endmodule
