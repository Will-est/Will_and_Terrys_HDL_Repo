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
    // unpack wires
    wire a_s = a[7];
    wire [2:0] a_e = a[6:4];
    wire [3:0] a_f = a[3:0];
    
    wire b_s = b[7];
    wire [2:0] b_e = b[6:4];
    wire [3:0] b_f = b[3:0];
    
    localparam BIAS = 3;
    
    // zeroes
    wire a_zero = (a_e == 3'b000);
    wire b_zero = (b_e == 3'b000);
    
    wire a_sig = a_zero ? 5'b0 : {1'b1, a_f};
    wire b_sig = b_zero ? 5'b0 : {1'b1, b_f};
    
    // which operand is bigger 
    wire a_gt = (a_e > b_e) || ((a_e == b_e) && (a_sig >=  b_sig));
    
    wire x_s = a_gt ? a_s : b_s;
    wire [2:0] x_e = a_gt ? a_e : b_e;
    wire [4:0] x_sig = a_gt ? a_sig : b_sig;
    
    wire y_s = a_gt ? b_s : a_s;
    wire [2:0] y_e = a_gt ? b_e : a_e;
    wire [4:0] y_sig = a_gt ? b_sig : a_sig;
    
    // alignment
    wire [3:0] exp_diff_uncapped = (x_e >= y_e) ? (x_e - y_e) : 4'b0;
    wire [2:0] exp_diff = (exp_diff_uncapped > 3'd5) ? 3'd5: exp_diff_uncapped[2:0]; // only 5 shifts matter
    
    // right shift w sticky bit
    reg [4:0] y_sig_aligned;
    reg y_sticky;
    integer i;
    
    always @* begin:
        y_sig_aligned = y_sig;
        y_sticky = 1'b0;
        if (exp_diff
        
    
    
    
endmodule


