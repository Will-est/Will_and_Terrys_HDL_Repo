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


// ==========================================
// Floating-Point MAC Cell for 8-bit Systolic Array
// ==========================================
module MAC (
    input wire clk,
    input wire reset,
    input wire [7:0] a_in,
    input wire [7:0] b_in,
    output reg [7:0] a_out,
    output reg [7:0] b_out,
    output reg [7:0] c_out
);

    wire [7:0] mult_res;
    wire [7:0] add_res;
    reg [7:0] acc;  // 8-bit floating point accumulator
    initial acc = 8'd0;

    // Instantiate combinational FP units
    FP_Multiplier u_mult (
        .a(a_in),
        .b(b_in),
        .out(mult_res)
    );

    FP_Adder u_add (
        .a(acc),
        .b(mult_res),
        .out(add_res)
    );

    always @(posedge clk or reset) 
    begin
        if(reset) begin
            acc <= 8'd0;
        end else begin
            // propagate input values through systolic grid
            a_out <= a_in;
            b_out <= b_in;
    
            // update accumulation with FP addition
            acc <= (^add_res === 1'bx) ? 8'd0 : add_res;
            c_out <= add_res;
        end
    end

endmodule
