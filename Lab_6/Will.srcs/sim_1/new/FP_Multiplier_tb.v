`timescale 1ns / 1ps

module FP_Multiplier_tb;

    
    reg [7:0] matrix1;
    reg [7:0] matrix2;
    wire [7:0] result;
    reg [7:0] expected;

    // Instantiate UUT
    FP_Multiplier uut (
        .a(matrix1),
        .b(matrix2),
        .out(result)
    );

    // check_result task
    task check_result;
        input [7:0] a, b, e, r;
        begin
            if (r !== e)
                $display("FAIL: A=%b B=%b Expected=%b Got=%b", a, b, e, r);
            else
                $display("PASS: A=%b B=%b Result=%b", a, b, r);
        end
    endtask

    initial begin
        $display("===== Starting MatrixMult Assertion Testbench =====");

        // Test 1: Simple positive multiply
        // 1.5 * 2.0 = 3.0
        // A = (sign=0, exp=3+0, frac=1000) = 1.5
        // B = (sign=0, exp=4, frac=0000)   = 2.0
        // Result ≈ 3.0 → 0_100_1000
        matrix1 = 8'b0_011_1000; 
        matrix2 = 8'b0_100_0000;
        expected = 8'b0_100_1000; // 0x48
        #10 check_result(matrix1, matrix2, expected, result);

        // Test 2: Multiply by zero
        matrix1 = 8'b0_011_0100; // 1.25
        matrix2 = 8'b00000000;   // 0
        expected = 8'b00000000;
        #10 check_result(matrix1, matrix2, expected, result);

        // Test 3: Negative × positive
        // (-1.5) × (2.0) = -3.0
        matrix1 = 8'b1_011_1000;
        matrix2 = 8'b0_100_0000;
        expected = 8'b1_100_1000; // -3.0
        #10 check_result(matrix1, matrix2, expected, result);

        // Test 4: Positive × negative
        // (1.25) × (-1.5) = -1.875
        matrix1 = 8'b0_011_0100; // 1.25
        matrix2 = 8'b1_011_1000; // -1.5
        expected = 8'b1_011_1110; // approx -1.875
        #10 check_result(matrix1, matrix2, expected, result);

        // Test 5: Equal exponents, both positive
        // (1.5 * 1.5 = 2.25)
        // 2.25 → 1.125 × 2¹ → exp=4, frac=0010
        matrix1 = 8'b0_011_1000;
        matrix2 = 8'b0_011_1000;
        expected = 8'b0_100_0010; // 0x42
        #10 check_result(matrix1, matrix2, expected, result);

        // Test 6: Exponent scaling
        // (1.0 × 8.0 = 8.0)
        // 1.0: exp=3, frac=0000
        // 8.0: exp=6, frac=0000
        // 8.0 result: exp=6, frac=0000
        matrix1 = 8'b0_011_0000;
        matrix2 = 8'b0_110_0000;
        expected = 8'b0_110_0000; // 0x60
        #10 check_result(matrix1, matrix2, expected, result);

        // Test 7: Small fractions
        // (1.0625 × 1.125 = 1.195)
        // → exp=3, frac≈0011
        matrix1 = 8'b0_011_0001; // 1.0625
        matrix2 = 8'b0_011_0010; // 1.125
        expected = 8'b0_011_0011; // ~1.19
        #10 check_result(matrix1, matrix2, expected, result);

        // Test 8: Both large mantissas, check normalization
        // (1.9375 * 1.9375 ≈ 3.75 → 1.875 * 2¹)
        // → exp=4, frac=1110
        matrix1 = 8'b0_011_1111;
        matrix2 = 8'b0_011_1111;
        expected = 8'b0_100_1110; // ~3.75
        #10 check_result(matrix1, matrix2, expected, result);

        $display("===== All tests completed =====");
        #10 $finish;
    end

endmodule

