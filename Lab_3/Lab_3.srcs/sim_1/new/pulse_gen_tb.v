`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/25/2025 03:55:10 PM
// Design Name:
// Module Name: pulse_gen_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Testbench for pulse_generator and clk_divider (waveform only)
//
// Dependencies:
// This testbench requires the Verilog source files for the following modules
// to be included in the project:
// 1. pulse_generator.v
// 2. clk_divider.v
// 3. big_counter.v
//
//////////////////////////////////////////////////////////////////////////////////

module pulse_gen_tb;

    //-- Clock Generation --
    parameter CLK_PERIOD = 10; // 10 ns period -> 100 MHz clock
    reg clk;

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    //===========================================================================
    // 1. PULSE GENERATOR TEST SIGNALS & INSTANTIATION
    //===========================================================================
    reg START;
    reg [1:0] MODE;
    reg tb_reset; // Main reset for the test environment
    wire pulse_out;
    wire [31:0] div_value;
    wire one_hz_clk;
    wire [16:0] count;
    wire clk_div_out;

    //-- Instantiate DUT Reset Generator --
    clk_divider dut_reset_gen (
        .clk(clk),
        .slow_clk(clk_div_out),
        .clk_bit_select(32'd2),
        .reset(tb_reset)
    );

    //-- Instantiate the pulse_generator (DUT) --
    pulse_generator dut (
        .clk(clk),
        .START(START),
        .MODE(MODE),
        .reset(tb_reset),
        .pulse_out(pulse_out)
        
        //debugging
        ,
        .div_value_out(div_value),
        .one_hz_clk_out(one_hz_clk),
        .count_out(count)
        
    );


    //===========================================================================
    // 3. TEST SEQUENCE
    //===========================================================================
    initial begin
        //-- Initialization --
        #2; // slight offset from the start
        tb_reset        = 1;
        START           = 0;
        MODE            = 2'b00;
        #(CLK_PERIOD * 5);

        tb_reset = 0;
        #(CLK_PERIOD * 1);

        //-- Test the pulse_generator DUT --
        START = 1;
        #(CLK_PERIOD * 2);
    
        // Mode 00
        MODE = 2'b00;
        #(CLK_PERIOD * 2);
        
        tb_reset = 1;
        #(CLK_PERIOD * 1);
        tb_reset = 0;
        #(CLK_PERIOD * 1);

        // Mode 01
        MODE = 2'b01;
        #(CLK_PERIOD * 2);

        // Mode 10
        MODE = 2'b10;
        #(CLK_PERIOD * 2);
        
        // Mode 11
        MODE = 2'b11;
        #(CLK_PERIOD * 20);
        
        

        //-- Apply reset to the test divider --
        tb_reset = 1;
        #(CLK_PERIOD * 1);
        tb_reset = 0;
        #(CLK_PERIOD * 1);

        //-- Finish Simulation --
        $finish;
    end

endmodule