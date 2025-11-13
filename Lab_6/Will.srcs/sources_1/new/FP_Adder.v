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
    // unpack inputs
    wire        a_sign = a[7];
    wire  [2:0] a_exp  = a[6:4];
    wire  [3:0] a_frac = a[3:0];
    
    wire        b_sign = b[7];
    wire  [2:0] b_exp  = b[6:4];
    wire  [3:0] b_frac = b[3:0];
    
    wire a_is_zero = (a_exp == 3'b000);
    wire b_is_zero = (b_exp == 3'b000);
    
    wire both_zero   = a_is_zero && b_is_zero;
    wire only_a_zero = a_is_zero && !b_is_zero;
    wire only_b_zero = !a_is_zero && b_is_zero;
    
    // significands
    wire [4:0] a_sig = a_is_zero ? 5'b0 : {1'b1, a_frac};
    wire [4:0] b_sig = b_is_zero ? 5'b0 : {1'b1, b_frac};
    
    // larger operand is x
    wire a_gt_b = (a_exp > b_exp) || ((a_exp == b_exp) && (a_sig >= b_sig));
    
    wire        x_sign = a_gt_b ? a_sign : b_sign;
    wire  [2:0] x_exp  = a_gt_b ? a_exp  : b_exp;
    wire  [4:0] x_sig  = a_gt_b ? a_sig  : b_sig;
    
    wire        y_sign = a_gt_b ? b_sign : a_sign;
    wire  [2:0] y_exp  = a_gt_b ? b_exp  : a_exp;
    wire  [4:0] y_sig  = a_gt_b ? b_sig  : a_sig;
    
    wire [3:0] exp_diff_uncapped = (x_exp >= y_exp) ? (x_exp - y_exp) : 4'd0;
    wire [2:0] exp_diff = (exp_diff_uncapped > 3'd5) ? 3'd5 : exp_diff_uncapped[2:0];
    
    // Right shift with sticky bit
    reg  [4:0] y_sig_aligned;
    reg        y_sticky;
    reg  [4:0] shift_temp;
    reg        sticky_temp;
    integer    i;
    
    always @* begin
        shift_temp  = y_sig;
        sticky_temp = 1'b0;
        
        for (i = 0; i < 5; i = i + 1) begin
            if (i < exp_diff) begin
                sticky_temp = sticky_temp | shift_temp[0];
                shift_temp  = {1'b0, shift_temp[4:1]};
            end
        end
        
        y_sig_aligned = shift_temp;
        y_sticky      = sticky_temp;
    end
    
    // + or -
    wire [4:0] op_large = x_sig;
    wire [4:0] op_small = y_sig_aligned;
    
    reg  [5:0] sum_result;
    reg        result_sign;
    reg  [2:0] result_exp;
    reg  [5:0] result_sig;
    
    always @* begin
        result_exp = x_exp;
        
        if (x_sign == y_sign) begin
            sum_result  = {1'b0, op_large} + {1'b0, op_small};
            result_sign = x_sign;
        end else begin
            sum_result  = {1'b0, op_large} - {1'b0, op_small};
            result_sign = x_sign;
        end
        
        result_sig = sum_result;
    end
    
    // normalize
    reg  [4:0] norm_sig;
    reg  [3:0] norm_exp;
    reg        is_zero;
    reg  [4:0] sig_temp;
    reg  [3:0] exp_temp;
    
    always @* begin
        is_zero  = (result_sig[5:0] == 6'b0);
        norm_sig = 5'b0;
        norm_exp = {1'b0, result_exp};
        
        if (is_zero) begin
            norm_sig = 5'b0;
            norm_exp = 4'b0000;
        end else if (result_sig[5]) begin
            norm_sig = result_sig[5:1];
            norm_exp = {1'b0, result_exp} + 4'd1;
        end else begin
            sig_temp = result_sig[4:0];
            exp_temp = {1'b0, result_exp};
            
            if (sig_temp[4]) begin
                norm_sig = sig_temp;
                norm_exp = exp_temp;
            end else if (sig_temp[3]) begin
                norm_sig = {sig_temp[3:0], 1'b0};
                if (exp_temp >= 4'd1) 
                    norm_exp = exp_temp - 4'd1;
                else begin
                    norm_exp = 4'd0;
                    is_zero  = 1'b1;
                end
            end else if (sig_temp[2]) begin
                norm_sig = {sig_temp[2:0], 2'b00};
                if (exp_temp >= 4'd2) 
                    norm_exp = exp_temp - 4'd2;
                else begin
                    norm_exp = 4'd0;
                    is_zero  = 1'b1;
                end
            end else if (sig_temp[1]) begin
                norm_sig = {sig_temp[1:0], 3'b000};
                if (exp_temp >= 4'd3) 
                    norm_exp = exp_temp - 4'd3;
                else begin
                    norm_exp = 4'd0;
                    is_zero  = 1'b1;
                end
            end else if (sig_temp[0]) begin
                norm_sig = {sig_temp[0], 4'b0000};
                if (exp_temp >= 4'd4) 
                    norm_exp = exp_temp - 4'd4;
                else begin
                    norm_exp = 4'd0;
                    is_zero  = 1'b1;
                end
            end else begin
                norm_sig = 5'b0;
                norm_exp = 4'b0000;
                is_zero  = 1'b1;
            end
        end
    end
    
    // ----- Pack result -----
    reg [7:0] packed;
    
    always @* begin
        if (both_zero) begin
            packed = 8'b0;
        end else if (only_a_zero) begin
            packed = b;
        end else if (only_b_zero) begin
            packed = a;
        end else if (is_zero || (norm_exp == 4'b0000) || (norm_sig == 5'b0)) begin
            packed = 8'b0;
        end else if (norm_exp >= 4'd7) begin
            packed = {result_sign, 3'b111, 4'b1111};
        end else begin
            packed = {result_sign, norm_exp[2:0], norm_sig[3:0]};
        end
    end
    
    assign y = packed;

endmodule


