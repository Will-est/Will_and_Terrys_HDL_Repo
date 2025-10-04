`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2025 08:49:18 PM
// Design Name: 
// Module Name: high_activity
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


module high_activity #( 
    parameter [7:0] step_thresh = 8'd64,
    parameter [7:0] time_thresh = 8'd1
)(
    input  clk,
    input  reset,
    input  [7:0] speed,
    input  one_hz_tick,          // 1-cycle pulse in clk domain
    output reg [6:0] hi_time
);

    reg  [7:0] streak;
    reg  [7:0] speed_now, speed_prev; 
    wire       hi = (speed_prev >= step_thresh);

    // temp for the saturating add check
    reg  [7:0] sum8;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            speed_now  <= 8'd0;
            speed_prev <= 8'd0;
            streak     <= 8'd0;
            hi_time    <= 7'd0;
        end else if (one_hz_tick) begin
            // sample speed once per second
            speed_prev <= speed_now;
            speed_now  <= speed;

            if (hi) begin
                if (streak == (time_thresh - 1)) begin
                    // do an 8-bit add and check the carry-out bit [7]
                    sum8 = {1'b0, hi_time} + time_thresh;  // hi_time zero-extended to 8 bits
                    if (sum8[7])
                        hi_time <= 7'd127;                 // saturate
                    else
                        hi_time <= sum8[6:0];
                    streak <= time_thresh;                  // enter "qualified" state
                end else if (streak >= time_thresh) begin
                    // already qualified: +1 per high second, saturating
                    if (hi_time != 7'd127)
                        hi_time <= hi_time + 7'd1;
                    streak <= streak + 8'd1;
                end else begin
                    // building toward qualification
                    streak <= streak + 8'd1;
                end
            end else begin
                // any low second breaks the run
                streak <= 8'd0;
            end
        end
    end

endmodule