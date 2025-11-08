`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 02:19:04 AM
// Design Name: 
// Module Name: FP_Multiplier
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


module FP_Adder (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Decompose input A
    wire signA = a[7];
    wire [2:0] expA = a[6:4];
    wire [3:0] fracA = a[3:0];

    // Decompose input B
    wire signB = b[7];
    wire [2:0] expB = b[6:4];
    wire [3:0] fracB = b[3:0];

    // Add hidden bit (1 for normalized values)
    wire [5:0] mantA = (|expA) ? {1'b1, fracA} : {1'b0, fracA};
    wire [5:0] mantB = (|expB) ? {1'b1, fracB} : {1'b0, fracB};

    // Align exponents
    wire [2:0] expDiff_AB = (expA >= expB) ? (expA - expB) : (expB - expA);
    wire swap = (expB > expA);

    wire [5:0] mant_large = swap ? mantB : mantA;
    wire [5:0] mant_small = swap ? mantA : mantB;
    wire sign_large = swap ? signB : signA;
    wire sign_small = swap ? signA : signB;
    wire [2:0] exp_large = swap ? expB : expA;

    // Shift smaller mantissa for exponent alignment
    wire [5:0] mant_small_shifted = mant_small >> expDiff_AB;

    // Add or subtract mantissas depending on sign
    wire [6:0] mant_sum = (sign_large == sign_small) ?
                          ({1'b0, mant_large} + {1'b0, mant_small_shifted}) :
                          ({1'b0, mant_large} - {1'b0, mant_small_shifted});

    // Normalization
    reg [5:0] mant_norm;
    reg [2:0] exp_norm;
    reg sign_out;

    always @(*) begin
        sign_out = sign_large;
        exp_norm = exp_large;

        if (mant_sum[6]) begin
            // Mantissa overflow → shift right, increment exponent
            mant_norm = mant_sum[6:1];
            exp_norm = exp_large + 1;
        end else if (mant_sum[5:1] == 0) begin
            // Zero result
            mant_norm = 0;
            exp_norm = 0;
            sign_out = 0;
        end else begin
            // Normalized mantissa
            mant_norm = mant_sum[5:0];
            // Normalize if MSB not 1
            if (!mant_norm[5] && exp_norm > 0) begin
                mant_norm = mant_norm << 1;
                exp_norm = exp_norm - 1;
            end
        end
    end

    // Pack result: [sign | exponent | fraction]
    assign out = {sign_out, exp_norm, mant_norm[4:1]};

endmodule


