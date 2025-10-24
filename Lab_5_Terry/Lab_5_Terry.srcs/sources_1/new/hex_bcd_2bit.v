`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2025 10:12:10 PM
// Design Name: 
// Module Name: hex_bcd_2bit
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
//  Thanks chat
//////////////////////////////////////////////////////////////////////////////////


module hex_bcd_2bit(
    input clk,
    input [7:0] bin,
    output [6:0] seg,
    output [3:0] an
);
    reg sel = 0;
    reg [15:0] div = 0;
    
    always @(posedge clk) begin
        div <= div + 1;
        if(div == 0)
            sel <= ~sel;
    end
    
    wire[3:0] nib = sel ? bin[7:4] : bin[3:0];
    
    hex7seg h1(
        .hex(nib),
        .seg(seg)
    );
    
    assign an = sel ? 4'b1110 : 4'b1101;
endmodule
