`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 01:13:13 AM
// Design Name: 
// Module Name: db_counter
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


module db_counter(
    input clk,
    output slow_clk_en
    );
    reg[31:0] counter = 0;
    always @(posedge clk) begin
        counter <= (counter >= 4999999)? 0 : counter + 1;
    end
    assign slow_clk_en = (counter == 499999) ? 1'b1 : 1'b0;
endmodule
