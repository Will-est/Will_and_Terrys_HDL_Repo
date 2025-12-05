module top(clk, reset, Halt, LEDS, BTNL, BTNR, AN, SEGS, SW, reset_out);
  // This is your top module for synthesis.
  // You define what signals the top module needs.
  input clk;
  input reset;
  input Halt;
  input BTNL;
  input BTNR;
  
  output [3:0] AN;
  output [6:0] SEGS;
  output wire [7:0] LEDS;
  output wire reset_out;
  input wire [2:0] SW;

  wire CS, WE;
  wire [6:0] Address;
  wire [31:0] Mem_Bus;
  wire [31:0] R1Val, R2Val;
  wire BTNLdb, BTNRdb;
  wire [15:0] regVal;
  
  
  Seven_Segment Display(clk, reset, regVal, AN, SEGS);
  MIPS CPU(clk, reset, CS, WE, Address, Halt, Mem_Bus, R1Val, R2Val, SW);
  Memory MEM(CS, WE, clk, Address, Mem_Bus);
  
  //assign regVal = ((BTNLdb) ? ((BTNRdb) ? (R2Val[31:16]) : (R2Val[15:0])) : (R1Val[15:0]));
 assign regVal = (BTNR) ? (R2Val[31:16]) : (R2Val[15:0]);
 assign reset_out = reset;
endmodule
