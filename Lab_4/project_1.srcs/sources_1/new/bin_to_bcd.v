`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 01:20:56 PM
// Design Name: 
// Module Name: bin_to_bcd
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


module bin_to_bcd(
    input  [13:0] bin,         // 0..9999
    output reg [3:0] th, hu, te, on
);
  integer i;
  reg [27:0] shift;          // [27:14] BCD, [13:0] bin
    always @* begin
        shift = {14'd0, bin};
        for (i = 0; i < 14; i = i+1) begin
            // add-3 to each BCD nibble if >= 5
            if (shift[27:24] >= 5) shift[27:24] = shift[27:24] + 4'd3;
            if (shift[23:20] >= 5) shift[23:20] = shift[23:20] + 4'd3;
            if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 4'd3;
            if (shift[15:12] >= 5) shift[15:12] = shift[15:12] + 4'd3;
            shift = shift << 1;
        end
        th = shift[27:24]; hu = shift[23:20]; te = shift[19:16]; on = shift[15:12];
    end
endmodule
