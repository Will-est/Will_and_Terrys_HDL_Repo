`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 03:19:05 PM
// Design Name: 
// Module Name: top
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


module top(clk, RST, Halt, LEDS);
// This is your top module for synthesis.
  // You define what signals the top module needs.
    input clk;
    input RST;
    input Halt;
    output [7:0] LEDS;
    
    wire CS, WE;
    wire [6:0] ADDR;
    wire [31:0] Mem_Bus;
    wire slow_clk;
    
    clk_divider clk_divider(clk,slow_clk);
    MIPS CPU(slow_clk, RST, CS, WE, ADDR, Mem_Bus,Halt,LEDS);
    Memory MEM(CS, WE, slow_clk, ADDR, Mem_Bus);

endmodule
