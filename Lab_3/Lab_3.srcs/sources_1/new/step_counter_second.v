`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2025
// Design Name: Step Counter
// Module Name: step_counter_second
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Counts input pulses within each second, latches count on 1 Hz tick
// 
// Dependencies: 
// 
// Revision:
// Revision 0.02 - Cleaned up non-blocking assignments, clarified reset, added comments
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module step_counter_second(
    input  wire       clk,             // system clock
    input  wire       reset,           // async reset (active high)
    input  wire       pulse_out,       // incoming step pulse
    input  wire       one_hz_clk_out,  // 1 Hz reference clock
    output reg [15:0] steps_this_sec,  // latched steps from last second
    output reg        count_ready      // pulses ready flag (1 cycle)
);

    // Synchronizers for edge detection
    reg p_out1, p_out2;
    reg one_hz1, one_hz2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p_out1   <= 1'b0;
            p_out2   <= 1'b0;
            one_hz1  <= 1'b0;
            one_hz2  <= 1'b0;
        end else begin
            // shift registers for edge detection
            p_out1   <= pulse_out;
            p_out2   <= p_out1;
            one_hz1  <= one_hz_clk_out;
            one_hz2  <= one_hz1;
        end
    end

    // Rising edge detection
    wire pulse_step  =  p_out1  & ~p_out2;
    wire one_sec_tick = one_hz1 & ~one_hz2;

    // Step counter
    reg [15:0] step_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            step_count     <= 16'd0;
            steps_this_sec <= 16'd0;
            count_ready    <= 1'b0;
        end else begin
            count_ready <= 1'b0; // default low each cycle

            // Increment count on rising edge of pulse_out
            if (pulse_step)
                step_count <= step_count + 16'd1;

            // On 1 Hz tick, latch and reset
            if (one_sec_tick) begin
                steps_this_sec <= step_count;
                step_count     <= 16'd0;
                count_ready    <= 1'b1; // goes high for one clk cycle
            end
        end
    end

endmodule
