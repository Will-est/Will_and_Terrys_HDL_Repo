`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 02:23:40 AM
// Design Name: 
// Module Name: MAC_tb
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

module MAC_tb;
    // Testbench signals
    reg clk;
    reg reset;
    reg [7:0] a_in;
    reg [7:0] b_in;
    wire [7:0] a_out;
    wire [7:0] b_out;
    wire [7:0] c_out;
    
    // Instantiate the MAC unit
    MAC uut (
        .clk(clk),
        .reset(reset),
        .a_in(a_in),
        .b_in(b_in),
        .a_out(a_out),
        .b_out(b_out),
        .c_out(c_out)
    );
    
    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Helper function to convert 8-bit FP to real for display
    function real fp8_to_real;
        input [7:0] fp;
        real mantissa;
        integer exp;
        integer sign;
        begin
            sign = fp[7];
            exp = fp[6:4] - 3;  // Biased by 3
            mantissa = 1.0 + (fp[3:0] / 16.0);  // 1.xxxx
            fp8_to_real = (sign ? -1.0 : 1.0) * mantissa * (2.0 ** exp);
        end
    endfunction
    
    // Helper function to create 8-bit FP from components
    function [7:0] create_fp8;
        input sign;
        input [2:0] exp;
        input [3:0] mant;
        begin
            create_fp8 = {sign, exp, mant};
        end
    endfunction
    
    // Test stimulus
    initial begin
        $display("========================================");
        $display("MAC Unit Testbench");
        $display("========================================");
        $display("Time\t\ta_in\t\tb_in\t\tc_out\t\tDecimal Values");
        $display("----------------------------------------");
        
        // Initialize
        reset = 1;
        a_in = 8'h00;
        b_in = 8'h00;
        
        // Release reset - wait for 2 rising edges
        @(posedge clk);
        @(posedge clk);
        reset = 0;
        
        // Test 1: Simple multiplication and accumulation
        // 0.25 * 0.25 = 0.0125 (accumulates to 0.0125)
        @(negedge clk);
        $display("\n--- Test 1: 0.25 * 0.25 ---");
        a_in = 8'b0_001_0000;  // 0.25 (exp=-2, mant=1.0)
        b_in = 8'b0_001_0000;  // 0.25
        @(posedge clk);
        @(negedge clk);
        $display("%0t\t%b\t%b\t%b\t\ta=%.4f, b=%.4f, c=%.4f", 
                 $time, a_in, b_in, c_out, 
                 fp8_to_real(a_in), fp8_to_real(b_in), fp8_to_real(c_out));
        
        // Test 2: Continue accumulation
        // 0.5 * 0.5 = 0.25, accumulated = 0.0125 + 0.25
        $display("\n--- Test 2: 0.5 * 0.5 (accumulate) ---");
        a_in = 8'b0_010_0000;  // 0.5 (exp=-1, mant=1.0)
        b_in = 8'b0_010_0000;  // 0.5
        @(posedge clk);
        @(negedge clk);
        $display("%0t\t%b\t%b\t%b\t\ta=%.4f, b=%.4f, c=%.4f", 
                 $time, a_in, b_in, c_out, 
                 fp8_to_real(a_in), fp8_to_real(b_in), fp8_to_real(c_out));
        
        // Test 3: Larger numbers
        // 2.0 * 1.5 = 3.0
        $display("\n--- Test 3: 2.0 * 1.5 (accumulate) ---");
        a_in = 8'b0_100_0000;  // 2.0 (exp=1, mant=1.0)
        b_in = 8'b0_011_1000;  // 1.5 (exp=0, mant=1.5)
        @(posedge clk);
        @(negedge clk);
        $display("%0t\t%b\t%b\t%b\t\ta=%.4f, b=%.4f, c=%.4f", 
                 $time, a_in, b_in, c_out, 
                 fp8_to_real(a_in), fp8_to_real(b_in), fp8_to_real(c_out));
        
        // Test 4: Negative numbers
        // -1.0 * 2.0 = -2.0
        $display("\n--- Test 4: -1.0 * 2.0 (accumulate) ---");
        a_in = 8'b1_011_0000;  // -1.0 (exp=0, mant=1.0)
        b_in = 8'b0_100_0000;  // 2.0
        @(posedge clk);
        @(negedge clk);
        $display("%0t\t%b\t%b\t%b\t\ta=%.4f, b=%.4f, c=%.4f", 
                 $time, a_in, b_in, c_out, 
                 fp8_to_real(a_in), fp8_to_real(b_in), fp8_to_real(c_out));
        
        // Test 5: Reset accumulator
        $display("\n--- Test 5: Reset ---");
        reset = 1;
        reset = 0;
        a_in = 8'b0_011_0000;  // 1.0
        b_in = 8'b0_011_0000;  // 1.0
        @(posedge clk);
         @(negedge clk);
        $display("%0t\t%b\t%b\t%b\t\ta=%.4f, b=%.4f, c=%.4f", 
                 $time, a_in, b_in, c_out, 
                 fp8_to_real(a_in), fp8_to_real(b_in), fp8_to_real(c_out));
        
        // Test 6: Verify passthrough (a_out, b_out)
        $display("\n--- Test 6: Verify Passthrough ---");
        a_in = 8'b0_100_1010;
        b_in = 8'b0_101_0101;
        @(posedge clk);
        @(negedge clk);
        $display("a_in=%b, a_out=%b (match=%b)", a_in, a_out, (a_in==a_out));
        $display("b_in=%b, b_out=%b (match=%b)", b_in, b_out, (b_in==b_out));
        
        // Test 7: Multiple accumulations
        $display("\n--- Test 7: Sequential Accumulations ---");
        reset = 1;
        @(posedge clk);
        @(negedge clk);
        reset = 0;
        
        repeat(5) begin
            a_in = 8'b0_010_0000;  // 0.5
            b_in = 8'b0_010_0000;  // 0.5 (product = 0.25)
            @(posedge clk);
            @(negedge clk);
            $display("%0t\t%b\t%b\t%b\t\tacc=%.4f", 
                     $time, a_in, b_in, c_out, fp8_to_real(c_out));
        end
        
        // Test 8: Zero multiplication
        $display("\n--- Test 8: Multiply by zero ---");
        reset = 1;
        @(posedge clk);
        reset = 0;
        a_in = 8'b0_011_0000;  // 1.0
        b_in = 8'b0_000_0000;  // 0.0
        @(posedge clk);
        @(negedge clk);
        $display("%0t\t%b\t%b\t%b\t\ta=%.4f, b=%.4f, c=%.4f", 
                 $time, a_in, b_in, c_out, 
                 fp8_to_real(a_in), fp8_to_real(b_in), fp8_to_real(c_out));
        
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $display("\n========================================");
        $display("Testbench Complete");
        $display("========================================");
        $finish;
    end
    
    // Monitor for debugging (optional - can comment out if too verbose)
    /*
    initial begin
        $monitor("Time=%0t clk=%b reset=%b a_in=%h b_in=%h a_out=%h b_out=%h c_out=%h",
                 $time, clk, reset, a_in, b_in, a_out, b_out, c_out);
    end
    */
    
endmodule
