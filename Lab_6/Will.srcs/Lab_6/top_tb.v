`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 02:23:40 AM
// Design Name: 
// Module Name: top_tb
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


module top_tb;
    reg clk;
    reg start; 
    reg reset;
    reg [7:0] a00, a01, a02, a10, a11, a12, a20, a21, a22;
    reg [7:0] b00, b01, b02, b10, b11, b12, b20, b21, b22;
    
    wire done;
    wire [7:0] M1_out, M2_out, M3_out, M4_out, M5_out, M6_out, M7_out, M8_out, M9_out;
    
    //debuggging
    wire [2:0] i_out;

    // Clock generation
    always #5 clk <= ~clk;
    
    // Expected output values
    reg [7:0] exp_M1, exp_M2, exp_M3, exp_M4, exp_M5, exp_M6, exp_M7, exp_M8, exp_M9;

    // ---------------------- ASSERTION TASK ----------------------
    task assert_result;
        input [7:0] expected;
        input [7:0] actual;
        input [31:0] index;
        begin
            if (expected !== actual)
                $display("M%0d FAILED: expected = %b, got = %b  (time=%0t)", index, expected, actual, $time);
            else
                $display("M%0d PASSED: %b == %b  (time=%0t)", index, expected, actual, $time);
        end
    endtask

    // ---------------------- TEST SEQUENCE ----------------------
    initial begin
        clk = 0;
        start = 0;
        reset = 1;

        a00 = 8'b00100000; a01 = 8'b00110000; a02 = 8'b00111000;    //  0.5    1    1.5
        a10 = 8'b00110000; a11 = 8'b01000000; a12 = 8'b01001000;    //   1     2     3
        a20 = 8'b10100000; a21 = 8'b10110000; a22 = 8'b10111000;    // -0.5   -1   -1.5
    
        b00 = 8'b00100000; b01 = 8'b00110000; b02 = 8'b00111000;    //  0.5    1    1.5
        b10 = 8'b00100000; b11 = 8'b00110000; b12 = 8'b00111000;    //  0.5    1    1.5
        b20 = 8'b00100000; b21 = 8'b00110000; b22 = 8'b00111000;    //  0.5    1    1.5

        // Expected outputs
        exp_M1 = 8'b00111000; exp_M2 = 8'b01001000; exp_M3 = 8'b01010010;
        exp_M4 = 8'b01001000; exp_M5 = 8'b01011000; exp_M6 = 8'b01100010;
        exp_M7 = 8'b10111000; exp_M8 = 8'b11001000; exp_M9 = 8'b11010010;
        
        #10 reset = 0;
        #10 start = 1;
        reset = 0;
        
        // Wait until computation finishes
        @(posedge done);
        #5;
        
        // Run assertions
        $display("---- Checking Matrix Output ----");
        assert_result(exp_M1, M1_out, 1);
        assert_result(exp_M2, M2_out, 2);
        assert_result(exp_M3, M3_out, 3);
        assert_result(exp_M4, M4_out, 4);
        assert_result(exp_M5, M5_out, 5);
        assert_result(exp_M6, M6_out, 6);
        assert_result(exp_M7, M7_out, 7);
        assert_result(exp_M8, M8_out, 8);
        assert_result(exp_M9, M9_out, 9);
        
        $display("All checks complete.");
        $finish;
    end

    // DUT Instantiation
    top DUT(
    .clk(clk),
    .start(start),
    .reset(reset),
    .arr_A0_0(b00), .arr_A0_1(b01), .arr_A0_2(b02),
    .arr_A1_0(b10), .arr_A1_1(b11), .arr_A1_2(b12),
    .arr_A2_0(b20), .arr_A2_1(b21), .arr_A2_2(b22),
    
    .arr_B0_0(a00), .arr_B0_1(a01), .arr_B0_2(a02),
    .arr_B1_0(a10), .arr_B1_1(a11), .arr_B1_2(a12),
    .arr_B2_0(a20), .arr_B2_1(a21), .arr_B2_2(a22),
    
    .arr_C0_0(M1_out), .arr_C0_1(M2_out), .arr_C0_2(M3_out),
    .arr_C1_0(M4_out), .arr_C1_1(M5_out), .arr_C1_2(M6_out),
    .arr_C2_0(M7_out), .arr_C2_1(M8_out), .arr_C2_2(M9_out),
    .done(done),
    .i_out(i_out)
);

endmodule
