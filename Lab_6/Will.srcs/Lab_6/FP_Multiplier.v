// ==========================================
// 8-bit Floating Point Multiplier
// Format: [7] Sign | [6:4] Exponent (3 bits) | [3:0] Mantissa (4 bits)
// Bias = 3  (since 3-bit exponent)
// ==========================================
module FP_Multiplier (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Split fields
    wire sign_a = a[7];
    wire [2:0] exp_a = a[6:4];
    wire [3:0] frac_a = a[3:0];

    wire sign_b = b[7];
    wire [2:0] exp_b = b[6:4];
    wire [3:0] frac_b = b[3:0];

    // Compute sign of result
    wire sign_out = sign_a ^ sign_b;
    
    // Add implicit leading 1 to mantissas -> 1.xxxxx (5 bits)
    wire [4:0] mant_a = {1'b1, frac_a};  // 1 + 4-bit mantissa = 5 bits
    wire [4:0] mant_b = {1'b1, frac_b};

    // Multiply mantissas (5x5 -> 10 bits)
    wire [9:0] mant_mult = mant_a * mant_b;

    // Normalize (if result >= 2.0, shift right and increase exponent)
    wire norm_shift = mant_mult[9]; // top bit = overflow from 1.xxxx * 1.xxxx

    // Normalized mantissa (take top 4 bits after normalization)
    wire [3:0] frac_out = norm_shift ? mant_mult[8:5] : mant_mult[7:4];

    // Exponent sum and bias correction
    // exp_out = exp_a + exp_b - bias + norm_shift
    wire [3:0] pre_processed_sum = {1'b0,exp_a} + {1'b0,exp_b} + norm_shift;
    wire greater_than_bias = (pre_processed_sum >= 4'd3);
    wire [3:0] exp_sum = greater_than_bias ? (pre_processed_sum - 4'd3) : 4'd0;

    // Handle overflow/underflow
    wire overflow = (exp_sum[3] == 1'b1); // negative result from subtraction

    wire [2:0] exp_out = exp_sum[2:0];

    // Construct final output
    assign out = ( (a == 8'd0) || (b == 8'd0) || (!greater_than_bias) )  ? 8'd0: 
                 ( (exp_a == 3'b111) || (exp_b == 3'b111) ) ? 8'b01110000: 
                 (overflow)  ? {sign_out, 3'b111, 4'b0000}   :
                 {sign_out, exp_out, frac_out};

endmodule
