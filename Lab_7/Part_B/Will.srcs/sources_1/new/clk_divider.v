`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 01:10:30 AM
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


module clk_divider(clk, slowClk);
  input clk; //fast clock
  output slowClk; //slow clock

  reg[24:0] counter;
  assign slowClk= counter[24];  //(2^27 / 100E6) = 1.34seconds

  initial begin
    counter = 0;
  end

  always @ (posedge clk)
  begin
    counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
  end

endmodule
