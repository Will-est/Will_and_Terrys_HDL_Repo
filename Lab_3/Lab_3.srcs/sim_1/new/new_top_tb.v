`timescale 1ns / 1ps

module new_top_tb;

    // Testbench inputs
    reg enable;
    reg reset;
    reg clk;
    reg [1:0] mode;

    // Testbench outputs (wires)
    wire CO;
    wire [6:0] lcd_out;
    wire [3:0] enabled_lcd_out;

    // Module select
    wire [3:0] module_select;
    // Module 1 outputs
    wire [3:0] ones_out;
    wire [3:0] tens_out;
    wire [3:0] hundreds_out;
    wire [3:0] thousands_out;

    // Module 2 outputs
    wire [3:0] decimal_miles_out;
    wire [3:0] ones_miles_out;
    wire [3:0] tens_miles_out;
    wire [3:0] hundreds_miles_out;
    wire [16:0] count;

    // pulse generator outputs
    wire pulse_out_out;
    wire [31:0] div_out_out;
    wire one_hz_clk_out;
    wire [16:0] pulse_gen_count_out;

    // DUT instantiation
    top uut (
        .enable(enable),
        .reset(reset),
        .clk(clk),
        .mode(mode),
        .CO(CO),
        .lcd_out(lcd_out),
        .enabled_lcd_out(enabled_lcd_out),
    
        // debugging
        
        // Module select
        .module_select_out(module_select),
        
        // Module 1 outputs
        .ones_out(ones_out),
        .tens_out(tens_out),
        .hundreds_out(hundreds_out),
        .thousands_out(thousands_out),
    
        // Module 2 outputs
        .decimal_miles_out(decimal_miles_out),
        .ones_miles_out(ones_miles_out),
        .tens_miles_out(tens_miles_out),
        .hundreds_miles_out(hundreds_miles_out),
        .count(count),
    
        // pulse generator outputs
        .pulse_out_out(pulse_out_out),
        .div_out_out(div_out_out),
        .one_hz_clk_out(one_hz_clk_out),
        .pulse_gen_count_out(pulse_gen_count_out)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // init
        clk    = 0;
        reset  = 1;
        enable = 1;
        mode   = 2'b00;        // start in walk mode
        #100;

        // release reset
        reset = 0;

        // --- Run #1 with module 1 (walk mode) ---
        #100;

        // switch to module 2
        mode = 2'b01;          // jog mode
        #100;
    
        reset = 1;
        #10
        reset = 0;
        #40
        
        reset = 1;
        #10
        reset = 0;
        #40
        
        reset = 1;
        #40
        reset = 0;
        #40
        // back to module 1
        mode = 2'b00;          // walk
        #100;

        // --- Try run with different Data values ---
        #100;

        // Finish
        $stop;
    end

endmodule
