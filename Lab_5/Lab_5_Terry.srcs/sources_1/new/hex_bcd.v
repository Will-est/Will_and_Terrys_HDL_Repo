`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2025 10:00:40 PM
// Design Name: 
// Module Name: hex_bcd
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
/// Thanks Chat!@
//////////////////////////////////////////////////////////////////////////////////


module hex_bcd(
    input  [3:0] hex,
    output [6:0] seg     // {a,b,c,d,e,f,g}
);
    reg [6:0] s;

    always @* begin
        case (hex)
            4'h0: s = 7'b1111110;
            4'h1: s = 7'b0110000;
            4'h2: s = 7'b1101101;
            4'h3: s = 7'b1111001;
            4'h4: s = 7'b0110011;
            4'h5: s = 7'b1011011;
            4'h6: s = 7'b1011111;
            4'h7: s = 7'b1110000;
            4'h8: s = 7'b1111111;
            4'h9: s = 7'b1111011;
            4'hA: s = 7'b1110111;
            4'hB: s = 7'b0011111; // b
            4'hC: s = 7'b1001110; // C
            4'hD: s = 7'b0111101; // d
            4'hE: s = 7'b1001111; // E
            4'hF: s = 7'b1000111; // F
            default: s = 7'b0000001; // dash (or blank)
        endcase
    end

    // The above table is written as if '1' means segment ON.
    // Flip if active-low (common-anode).
    assign seg = ~s;
endmodule