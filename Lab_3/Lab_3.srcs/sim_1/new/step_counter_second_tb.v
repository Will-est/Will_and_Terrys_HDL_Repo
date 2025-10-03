

// GPT
`timescale 1ns/1ps

module step_counter_second_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg pulse_out;
    reg one_hz_clk_out;
    wire [15:0] steps_this_sec;
    wire count_ready;

    // Instantiate DUT
    step_counter_second dut (
        .clk(clk),
        .reset(reset),
        .pulse_out(pulse_out),
        .one_hz_clk_out(one_hz_clk_out),
        .steps_this_sec(steps_this_sec),
        .count_ready(count_ready)
    );

    // Clock generation (100 MHz -> 10ns period for example)
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        pulse_out = 0;
        one_hz_clk_out = 0;

        // Hold reset
        #20;
        reset = 0;

        // Generate some pulses before 1 Hz tick
        repeat(3) begin
            #30 pulse_out = 1;  // pulse high
            #10 pulse_out = 0;  // pulse low
        end

        // First one_hz rising edge -> should latch 3
        #50 one_hz_clk_out = 1;
        #10 one_hz_clk_out = 0;

        // Generate more pulses (5 pulses this time)
        repeat(5) begin
            #40 pulse_out = 1;
            #10 pulse_out = 0;
        end

        // Second one_hz rising edge -> should latch 5
        #60 one_hz_clk_out = 1;
        #10 one_hz_clk_out = 0;

        // Idle, no pulses
        #200 one_hz_clk_out = 1;
        #10 one_hz_clk_out = 0;

        // End simulation
        #100 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | steps_this_sec=%0d | count_ready=%b | step_count internal=%0d", 
                  $time, steps_this_sec, count_ready, dut.step_count);
    end

endmodule
