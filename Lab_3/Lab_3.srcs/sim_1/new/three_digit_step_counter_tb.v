`timescale 1ns / 1ps

module three_digit_step_counter_tb;

    // Testbench inputs
    reg enable;
    reg reset;
    reg [3:0] Data;
    reg pulse;

    // Testbench outputs
    wire CO;
    wire [3:0] ones;
    wire [3:0] tens;
    wire [3:0] hundreds;

    // DUT instantiation
    three_digit_step_counter DUT (
        .enable(enable),
        .reset(reset),
        .Data(Data),
        .pulse(pulse),
        .CO(CO),
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds)
    );

    // Clock generation (pulse input)
    initial begin
        pulse = 0;
        forever #5 pulse = ~pulse;  // 100MHz equivalent
    end

    // Stimulus
    initial begin
        // VCD dump for simulation
        $dumpfile("three_digit_step_counter_tb.vcd");
        $dumpvars(0, three_digit_step_counter_tb);

        // Initialize
        enable = 0;
        reset  = 1;
        Data   = 4'd0;

        #20;
        reset = 0;   // release reset
        enable = 1;  // enable counting

        // Let it count for a while
        #(100);  // simulate some pulses

        // Force reset during counting
        reset = 1;
        #20;
        reset = 0;

        // Count again up through 999 and rollover test
        #(500);

        // Stop simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("t=%0t | reset=%b enable=%b | H=%d T=%d O=%d | CO=%b",
                 $time, reset, enable, hundreds, tens, ones, CO);
    end

endmodule
