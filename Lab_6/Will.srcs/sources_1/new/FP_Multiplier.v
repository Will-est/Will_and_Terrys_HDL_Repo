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

// Brought to you by GPT
// ==========================================
// 8-bit Floating-Point Multiplier (Combinational)
// Format: [7]=Sign | [6:3]=Exponent | [2:0]=Mantissa
// Bias = 7
// ==========================================
module FP_Multiplier (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Split fields
    wire sign_a = a[7];
    wire [3:0] exp_a = a[6:3];
    wire [2:0] frac_a = a[2:0];

    wire sign_b = b[7];
    wire [3:0] exp_b = b[6:3];
    wire [2:0] frac_b = b[2:0];

    // Compute sign of result
    wire sign_out = sign_a ^ sign_b;

    // Implicit leading 1
    wire [4:0] mant_a = {1'b1, frac_a};  // 1.FA (5 bits)
    wire [4:0] mant_b = {1'b1, frac_b};  // 1.FB (5 bits)

    // Multiply mantissas (5x5 -> 10 bits)
    wire [9:0] mant_mult = mant_a * mant_b;

    // Normalize: check if result >= 2.0
    wire norm_shift = mant_mult[9];   // If MSB is 1, normalization needed

    // Normalized mantissa (take top 4 bits after normalization)
    wire [3:0] frac_out = norm_shift ? mant_mult[8:5] : mant_mult[7:4];

    // Exponent sum and bias adjust
    wire [4:0] exp_sum = exp_a + exp_b - 7 + norm_shift;

    // Handle overflow/underflow
    wire [3:0] exp_out = (exp_sum[4]) ? 4'b0000 : exp_sum[3:0];  // crude underflow clamp
    wire overflow = (exp_sum > 15);  // overflow detection

    // Construct final output
    assign out = (overflow) ? {sign_out, 4'b1111, 3'b000} : {sign_out, exp_out, frac_out};

endmodule
