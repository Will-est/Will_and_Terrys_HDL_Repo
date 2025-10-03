`timescale 1ns / 1ps

module step_counter(
    input enable,           // counter enable
    input reset,            // asynchronous reset
    input [3:0] Data,  
    input pulse,           
    
    output wire CO,          // final carry out
    output wire [3:0] ones,
    output wire [3:0] tens,
    output wire [3:0] hundreds,
    output wire [3:0] thousands
    );

    // Internal carry signals
    wire co_ones;
    wire co_tens;
    wire co_hundreds;
    wire co_thousands;
    
    wire internal_enable;

    // Internal raw outputs from digit counters
    wire [3:0] ones_raw;
    wire [3:0] tens_raw;
    wire [3:0] hundreds_raw;
    wire [3:0] thousands_raw;

    // Modified enable (prevents counter from wrapping around at 9999)
    assign internal_enable = enable && ~(CO);
    
    // Counters -------------------------------------------------------------------
    // Ones digit counter
    sinlge_digit_counter U1 (
        .enable(internal_enable),
        .reset(reset),
        .clk(pulse),
        .Data(Data),
        .OUT(ones_raw),
        .CO(co_ones)
    );

    // Tens digit counter
    sinlge_digit_counter U2 (
        .enable(internal_enable),
        .reset(reset),
        .clk(co_ones),
        .Data(Data),
        .OUT(tens_raw),
        .CO(co_tens)
    );
    
    // Hundreds digit counter
    sinlge_digit_counter U3 (
        .enable(internal_enable),
        .reset(reset),
        .clk(co_tens),
        .Data(Data),
        .OUT(hundreds_raw),
        .CO(co_hundreds)
    );
    
    // Thousands digit counter
    sinlge_digit_counter U4 (
        .enable(internal_enable),
        .reset(reset),
        .clk(co_hundreds),
        .Data(Data),
        .OUT(thousands_raw),
        .CO(co_thousands)
    );

    // Final carry: when thousands rolls over
    assign CO = co_thousands;

    // Override logic: when CO = 1, force digits to 9
    assign ones      = (CO) ? 4'd9 : ones_raw;
    assign tens      = (CO) ? 4'd9 : tens_raw;
    assign hundreds  = (CO) ? 4'd9 : hundreds_raw;
    assign thousands = (CO) ? 4'd9 : thousands_raw;

endmodule
