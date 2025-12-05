`timescale 1ns / 1ps

// Written by GPT

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2025 11:30:49 PM
// Design Name: 
// Module Name: lcd_output
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


module lcd_output (
    input  wire [3:0] bcd,       // 4-bit decimal input (0-9)
    output reg  [6:0] segments   // 7-bit output: {a,b,c,d,e,f,g}
);

    always @(*) begin
        case (bcd)
                                   //7' abcedfg
            4'b0000: segments = 7'b0000001; // 0
            4'b0001: segments = 7'b1001111; // 1
            4'b0010: segments = 7'b0010010; // 2
            4'b0011: segments = 7'b0000110; // 3
            4'b0100: segments = 7'b1001100; // 4
            4'b0101: segments = 7'b0100100; // 5
            4'b0110: segments = 7'b0100000; // 6
            4'b0111: segments = 7'b0001111; // 7
            4'b1000: segments = 7'b0000000; // 8
            4'b1001: segments = 7'b0000100; // 9
            4'b1010: segments = 7'b1111011; // A
            4'b1011: segments = 7'b1100000; // B
            4'b1100: segments = 7'b0110001; // C
            4'b1101: segments = 7'b1000010; // D
            4'b1110: segments = 7'b0110000; // E
            4'b1111: segments = 7'b0111000; // F
        endcase
    end
endmodule
