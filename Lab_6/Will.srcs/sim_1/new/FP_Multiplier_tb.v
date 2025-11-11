`timescale 1ns / 1ps

module FP_Multiplier_tb;

    // Inputs
    reg [7:0] a;
    reg [7:0] b;

    // Output
    wire [7:0] out;

    // Instantiate the Unit Under Test (UUT)
    FP_Multiplier uut (
        .a(a),
        .b(b),
        .out(out)
    );

    initial begin
        // Initialize inputs
        a = 8'h00;
        b = 8'h00;
        #10;
        
        // Test 1: 1.0 * 1.0 = 1.0
        // a = 0x30 → +1.0
        // b = 0x30 → +1.0
        // expected out = 0x30 → +1.0
        a = 8'h30;
        b = 8'h30;
        #10;
        
        // Test 1: 2.0 * 2.0 = 4.0
        // a = 0x40 → +2.0
        // b = 0x40 → +2.0
        // expected out = 0x50 → +4.0
        a = 8'h40;
        b = 8'h40;
        #10;
        
        // Test 2: 1.5 * 0.5 = 0.75
        // a = 0x38 → +1.5
        // b = 0x20 → +0.5
        // expected out = 0x2C → +0.75
        a = 8'h38;
        b = 8'h20;
        #10;
        
        // Test 2: 1.325 * 16 = 21.2
        // a = 0x36 → +1.325
        // b = 0x+70 → +16.0
        // expected out = 
        a = 8'h36;
        b = 8'h70;
        #10;
        

        // End of simulation
        #20;
        $finish;
    end

endmodule
