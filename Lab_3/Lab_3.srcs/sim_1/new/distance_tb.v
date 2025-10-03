`timescale 1ns / 1ps

module distance_tb;

    // Testbench signals
    reg reset;
    reg pulse_out;
    reg [16:0] count;

    wire [3:0] decimal_out;
    wire [3:0] ones_miles;
    wire [3:0] tens_miles;
    
    wire miles;
    wire half_miles;
    // DUT instantiation
    distance DUT (
        .reset(reset),
        .pulse_out(pulse_out),
        .count(count),
        .decimal_out(decimal_out),
        .ones_miles(ones_miles),
        .tens_miles(tens_miles)
        //debugging
        ,
        .miles(miles),
        .half_miles(half_miles)
    );

    // Generate pulse_out clock
    initial begin
        pulse_out = 0;
        forever #5 pulse_out = ~pulse_out;  // 100MHz equivalent
    end

    // Stimulus
    initial begin
        // VCD dump
        $dumpfile("distance_tb.vcd");
        $dumpvars(0, distance_tb);

        // Init
        reset = 1;
        count = 2048;
        #20;
        reset = 0;

        // Increment count gradually
        repeat (200) begin
            @(posedge pulse_out);
            count = count + 1;
        end

        #10;
        $finish;
    end


endmodule
