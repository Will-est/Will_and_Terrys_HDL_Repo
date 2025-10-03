`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2025 03:58:03 PM
// Design Name: 
// Module Name: count32_9sec
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


module count32_9sec(
    input second_clk,
    input reset,
    input enabled,
//    input count_ready,
    input wire [31:0] divide_amount,
    output reg [3:0] hi_steps,
    output reg done9
    );

    reg [3:0] time_left;
    initial time_left = 4'd0;

//    reg cr1, cr2;
//    always @(posedge clk or posedge reset) begin
//        if (reset) {cr1,cr2} <= 2'b00;
//        else       {cr1,cr2} <= {count_ready, cr1};
//    end
//    wire count_ready_clk = cr1 & ~cr2; // 1-cycle pulse in clk domain

    always @(posedge second_clk or posedge reset) begin
        if(reset) begin
            time_left <= 4'd0;
            hi_steps <= 4'd0;
            done9 <= 4'd0;
        end
        else if(!done9) begin
            if((divide_amount < 32'd3125000) && (hi_steps < 4'd9) && enabled) begin //3125000
                hi_steps <= hi_steps + 4'd1;
                time_left <= time_left + 4'd1;
            end
            if(time_left == 4'd9)begin
                done9 <= 1'b1;
            end
        end
    end
endmodule