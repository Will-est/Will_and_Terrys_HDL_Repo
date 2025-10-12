`timescale 1ns / 1ps
module top_tb;

    // Inputs
    reg clk;
    reg buttonU, buttonL, buttonR, buttonD;
    reg switch0, switch1;

    // Outputs
    wire [3:0] AN;
    wire [6:0] SEG;

    // Instantiate DUT
    top uut (
        .clk(clk),
        .buttonU(buttonU),
        .buttonL(buttonL),
        .buttonR(buttonR),
        .buttonD(buttonD),
        .switch0(switch0),
        .switch1(switch1),
        .AN(AN),
        .SEG(SEG)
    );

    // Clock generation: 10ns period (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize all inputs
        buttonU = 0; buttonL = 0; buttonR = 0; buttonD = 0;
        switch0 = 0; switch1 = 0;

        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // Wait 20 ns before starting
        #20;

        // --- Button presses ---
        $display("Pressing Button U (10 ns)");
        buttonU = 1; #10; buttonU = 0;

        #20;
        $display("Pressing Button L (20 ns)");
        buttonL = 1; #20; buttonL = 0;

        #20;
        $display("Pressing Button R (15 ns)");
        buttonR = 1; #15; buttonR = 0;

        #20;
        $display("Pressing Button D (30 ns)");
        buttonD = 1; #30; buttonD = 0;

        // --- Switch toggles ---
        #20;
        $display("Toggling switches");
        switch0 = 1; #10;
        switch1 = 1; #10;
        switch0 = 0; #10;
        switch1 = 0; #10;

        // --- Multiple buttons pressed ---
        #20;
        $display("Pressing Button U + L together");
        buttonU = 1; buttonL = 1; #20;
        buttonU = 0; buttonL = 0;

        #30;
        $display("Simulation finished.");
        $finish;
    end

endmodule
