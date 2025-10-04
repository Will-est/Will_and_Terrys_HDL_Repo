`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 04:03:57 PM
// Design Name: 
// Module Name: distance
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
// Made by GPT


`timescale 1ns / 1ps

module distance(
    input reset,
    input  wire pulse_out,              // digit 0 (not used in math, but included per request)
    input  wire [16:0] count,           // 13-bit binary value
    output reg  [3:0] decimal_out,      // 5 if part2 > part1, else 0
    output wire [3:0] decimal_point,
    output  wire [3:0] ones_miles,             // digit 0
    output  wire [3:0] tens_miles            // digit 1
    
    //debugging
    ,
    output wire miles,
    output wire half_miles
);
    
    //decimal point
    assign decimal_point = 4'd10;
    // Holds the value of the count we are on + half of what we shift all shifted by 11( divide by 2048)
    reg [16:0] decimal_count;
    
    // Decimal Logic Block
    always @(*) begin
        // Computing the decimal digit
        decimal_count = (count) >> 10; //10
        
        if (decimal_count[0] == 1'b1) begin
            decimal_out = 4'd5;
        end else begin
            decimal_out = 4'd0;
        end
    end
    
    // Normal Digits
    reg miles_pulse;
    always@(*)begin
        if(count < 17'd2048)begin
            miles_pulse = 0;
        end else begin
            miles_pulse = ~decimal_count[0];
        end
    end
    
    three_digit_step_counter BCD_miles_out(
        .enable(1'b1),
        .reset(reset),
        .pulse(miles_pulse),
        .CO(CO),
        .Data(4'd0),
        .ones(ones_miles),
        .tens(tens_miles)
    );
    
    assign miles = decimal_count[1];
    assign half_miles = decimal_count[0];
    
endmodule

