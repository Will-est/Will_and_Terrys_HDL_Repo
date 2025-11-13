`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 02:23:40 AM
// Design Name: 
// Module Name: FP_Adder_tb
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


module FP_Adder_tb;
// Inputs
    reg [7:0] matrix1;
    reg [7:0] matrix2;

    // Output
    wire [7:0] result;

    // Instantiate the Unit Under Test (UUT)
    FP_Adder uut (
        .a(matrix1),
        .b(matrix2),
        .out(result)
    );

    // Simple task to display results
    task display_result;
        input [7:0] a;
        input [7:0] b;
        input [7:0] r;
        input [7:0] e;
        begin
           if (r !== e) begin
                $display("FAIL: A=%b | B=%b | expected=%b got=%b", a, b, e, r);
            end else begin
                $display("PASS: A=%b | B=%b | result=%b", a, b, r);
            end
        end
    endtask

    initial begin
        $display("========== Starting MatrixAdd Testbench ==========");
        $monitor("Time=%0t | matrix1=%b | matrix2=%b | result=%b", 
                 $time, matrix1, matrix2, result);

        // Initialize
        matrix1 = 0;
        matrix2 = 0;
        #10;

        // Test 1: Simple addition with equal exponents
        // Example: (sign=0 exp=3 frac=0101) + (sign=0 exp=3 frac=0011)
        matrix1 = 8'b0_011_0101;  // +1.0101 * 2^(3-3) = 1.33
        matrix2 = 8'b0_011_0011;  // +1.0011 * 2^(3-3) = 1.19
        #10 display_result(matrix1, matrix2, result, 8'b0_100_0100);

        // Test 2: Different exponents
        matrix1 = 8'b0_101_0100;  // +1.0100 * 2^(5-3) = 5.0
        matrix2 = 8'b0_010_0100;  // +1.0100 * 2^(2-3) = 0.625
        #10 display_result(matrix1, matrix2, result, 8'b0_101_0110);

        // Test 3: Addition with opposite signs (should perform subtraction)
        matrix1 = 8'b0_100_1000;  // +1.1000 * 2^(4-3) = 3.0
        matrix2 = 8'b1_100_0100;  // -1.0100 * 2^(4-3) = -2.5
        #10 display_result(matrix1, matrix2, result, 8'b0_010_0000);

        // Test 4: Exact cancel to zero
        matrix1 = 8'b0_011_0001;  // +1.0001 * 2^(3-3)
        matrix2 = 8'b1_011_0001;  // -1.0001 * 2^(3-3)
        #10 display_result(matrix1, matrix2, result, 8'b0_000_0000);

        // Test 5: Large exponent difference (one number should dominate)
        matrix1 = 8'b0_110_1111;  // +1.1111 * 2^(6-3)
        matrix2 = 8'b0_001_0001;  // +1.0001 * 2^(1-3)
        #10 display_result(matrix1, matrix2, result, 8'b0_110_1111);

        // Test 6: Overflow case (check normalization)
        matrix1 = 8'b0_011_1111;  // +1.1111 * 2^(3-3)
        matrix2 = 8'b0_011_1111;  // +1.1111 * 2^(3-3)
        #10 display_result(matrix1, matrix2, result, 8'b0_100_1111);

        // Test 7: One input is zero
        matrix1 = 8'b0_011_0100;
        matrix2 = 8'b00000000;
        #10 display_result(matrix1, matrix2, result, 8'b0_011_0100);

        $display("========== Testbench Finished ==========");
        #20 $finish;
    end

endmodule

