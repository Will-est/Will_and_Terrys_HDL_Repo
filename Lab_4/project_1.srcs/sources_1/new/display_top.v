`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 03:49:26 PM
// Design Name: 
// Module Name: display_top
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


module display_top(
    input clk,
    input reset,
    input [13:0] bin,
    input [1:0] mode,
    input tick_1hz,
    input tick_2hz,
    output [3:0] An,
    output[6:0] Seg
    );
    
    wire [3:0] th,hu,te,on;
    //safety saturation
    wire [13:0] saturated_bin = (bin >= 14'd9999) ? 14'd9999 : bin;
    bin_to_bcd  b1 (.bin(saturated_bin), .th(th), .hu(hu), .te(te), .on(on));
    
    wire show;
    
    blink_gate g1 (.clk(clk), .mode(mode), .tick_1hz(tick_1hz), .tick_2hz(tick_2hz), .seconds_bin(saturated_bin), .show(show));
    sevenseg_mux m1 (.clk(clk), .th(th), .hu(hu), .te(te), .on(on), .show(show), .AN(AN), .SEG(SEG));
endmodule
