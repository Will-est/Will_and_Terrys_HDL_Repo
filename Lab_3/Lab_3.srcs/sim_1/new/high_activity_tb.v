`timescale 1ns / 1ps

module tb_high_activity;

    // Parameters
    parameter STEP_THRESH = 64;
    parameter TIME_THRESH = 5; // Use a small value for easier simulation

    // Inputs
    reg clk;
    reg reset;
    reg count_ready;
    reg [15:0] steps_this_sec;

    // Outputs
    wire [31:0] hi_time;

    // Instantiate the module
    high_activity #(
        .step_thresh(STEP_THRESH),
        .time_thresh(TIME_THRESH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .count_ready(count_ready),
        .steps_this_sec(steps_this_sec),
        .hi_time(hi_time)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock for example

    // Test stimulus
    initial begin
        // Initialize inputs
        reset = 1;
        count_ready = 0;
        steps_this_sec = 0;

        // Apply reset
        #10;
        reset = 0;

        // Test 1: steps below threshold
        steps_this_sec = 50;
        count_ready = 1;
        #50;

        // Test 2: steps above threshold, streak should start
        steps_this_sec = 70;
        #50;

        // Keep steps above threshold for multiple cycles to reach TIME_THRESH
        repeat (TIME_THRESH + 2) begin
            #10;
        end

        // Test 3: break streak
        steps_this_sec = 30;
        #20;

        // Test 4: start streak again
        steps_this_sec = 80;
        #50;

        // Finish simulation
        $display("Final hi_time = %d", hi_time);
        $stop;
    end

endmodule
