`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2025 11:53:38 PM
// Design Name: 
// Module Name: top
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


module top(
    input enable,           // counter enable            
    input reset,            // asynchronous reset
    input clk,
//    input [3:0] Data,         // Value you load into each digit  
    input [1:0] mode,
    
    output wire CO,          // final carry out   
    output [6:0] lcd_out,
    output [3:0] enabled_lcd_out
    
    // debugging
    ,
////     Module Select
//    output wire [3:0] module_select_out,
//    // Module 1 outputs
//    output wire [3:0] ones_out,
//    output wire [3:0] tens_out,
//    output wire [3:0] hundreds_out,
//    output wire [3:0] thousands_out,
//    // Module 2 outputs
//    output wire [3:0] decimal_miles_out,
//    output wire [3:0] ones_miles_out,
//    output wire [3:0] tens_miles_out,
//    output wire [3:0] hundreds_miles_out,
//    output [16:0] count,
    // pulse generator output
//    output pulse_out_out,               // this is high for hardware debugging
//    output [31:0] div_out_out,
//    output one_hz_clk_out,               // this is high for hardware debugging
//    output [16:0] pulse_gen_count_out
    output [3:0] state_out
    );
     
    // clk stuff
//    wire counter_clk;
//    clk_divider counter_divider(.clk(clk), .slow_clk(counter_clk),.reset(1'b0), .clk_bit_select(32'd1)); //25
    
    reg [3:0] Data;
    initial Data = 4'd0;
    // Pulse Generator
    // comment these out for debugging
    wire [31:0] div_value;
    wire       one_hz_clk;
    wire [16:0] pulse_gen_count;
    wire [3:0] state;
    
    pulse_generator dut (
        .clk(clk),
        .START(enable),
        .MODE(mode),
        .reset(reset),
        .pulse_out(pulse_out)
        
        //debugging
        ,
        .div_value_out(div_value),
        .one_hz_clk_out(one_hz_clk),
        .count_out(pulse_gen_count),
        .state(state)
        
    );
    

   // Module 1 --------------------------------------------------------------------- 
    // comment out for debugging
    wire [3:0] ones;
    wire [3:0] tens;
    wire [3:0] hundreds;
    wire [3:0] thousands;
    wire [16:0] combined_OUT;
    
    step_counter uut (
        .pulse(pulse_out),
        .enable(enable),
        .reset(reset),
        .CO(CO),
        .Data(Data),
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds),
        .thousands(thousands)
         );
     
   // Module 2 ----------------------------------------------------------------------
     big_counter step_counter_combined(
        .enable(enable), 
        .reset(reset),
        .clk(pulse_out), // used to have counter_clk here
        .Data(Data),
        .OUT(combined_OUT)
        );
     
     // Distance guy 
     wire [3:0] miles_ones;
     wire [3:0] miles_tens;
     wire [3:0] miles_decimal_point;
     wire [3:0] miles_decimal;
     
     distance miles_out(
        .reset(reset),
        .pulse_out(pulse_out),
        .count(combined_OUT),          // 13-bit binary input

        .decimal_out(miles_decimal),   // 5 if part2 > part1, else 0

        .ones_miles(miles_ones),             // digit 0
        .tens_miles(miles_tens),             // digit 1
        .decimal_point(miles_decimal_point)      // digit 2
);
    // per second step counter
    wire count_ready;
    wire [15:0] steps_this_sec;
    
//    wire one_hz_clk_mode_3;
//    clk_divider mode3_one_hz_divider(
//        .clk(clk),
//        .slow_clk(one_hz_clk_mode_3),
//        .clk_bit_select(32'd100000000),   // 100 MHz / 100000000 = 1 Hz
////      .clk_bit_select(32'd2), // for debugging/simulating
//        .reset(reset)
//    );
    
//    step_counter_second step_counter (
//        .clk(clk),
//        .reset(reset),
//        .pulse_out(pulse_out),
//        .one_hz_clk_out(one_hz_clk_mode_3),
//        .count_ready(count_ready),
//        .steps_this_sec(steps_this_sec)
//    );
    // Module 3 ----------------------------------------------------------------------
    wire[3:0] over32_in9;
    wire done9;
    

    // 1Hz clk
    wire one_hz_clk_mode_3;
    clk_divider one_hz_divider(
        .clk(clk),
        .slow_clk(one_hz_clk_mode_3),
        .clk_bit_select(32'd100000000),   // 100 MHz / 100000000 = 1 Hz
//      .clk_bit_select(32'd2), // for debugging/simulating
        .reset(reset)
    );

    count32_9sec part3 (
        .second_clk(one_hz_clk_mode_3),
        .reset(reset),
        .enabled(enable),
        .divide_amount(div_value),
        .hi_steps(over32_in9),
        .done9(done9)
    );
    
    // Module 4 ----------------------------------------------------------------------
    wire [31:0] high_activity_s;
    
        high_activity part4 (
        .clk(clk),
        .reset(reset),
        .speed(speed),
        .one_hz_tick(one_hz_clk_mode_3),
        .hi_time(high_activity_s)
    );
    wire [3:0] ha_hundreds, ha_tens, ha_ones;
    // Module 4 binary -> BCD
    bin_to_bcd_14 converter (
        .bin(high_activity_s),
        .hundreds(ha_hundreds), .tens(ha_tens), .ones(ha_ones)
    );
     // LCD stuff  ----------------------------------------------------------
      
     // 2 second Counter
     wire two_hz_clk;
     clk_divider module_one_hz_divider(
        .clk(clk),
        .slow_clk(two_hz_clk),
        .clk_bit_select(32'd200020000),   // 100kHz / 500000 = 2 Hz
//        .clk_bit_select(32'd10), // for debugging/simulating
        .reset(reset)
    );
     
    // Module Enable Stuff
    wire [3:0] module_select;
//    reg [3:0] module_select;
//    initial module_select = 4'b0001;
    module_enable_module module_enable_block(
        two_hz_clk, 
        module_select
    );
    
    // LCD MUX
    wire [3:0] lcd_out0;
    wire [3:0] lcd_out1;
    wire [3:0] lcd_out2;
    wire [3:0] lcd_out3;
    
    lcd_mux module_enable(
        // Group 0: counter digits
        .in0_0(ones),
        .in0_1(tens),
        .in0_2(hundreds),
        .in0_3(thousands),

        // Group 1: distance digits
        .in1_0(miles_decimal),
        .in1_1(miles_decimal_point),
        .in1_2(miles_ones),
        .in1_3(miles_tens),   // placeholder

        // Group 2: all zeros for now
        .in2_0(over32_in9),
        .in2_1(4'b0000),
        .in2_2(4'b0000),
        .in2_3(4'b0000),

        // Group 3: all zeros for now
        .in3_0(ha_ones),
        .in3_1(ha_tens),
        .in3_2(ha_hundreds),
        .in3_3(ha_thousands),

        // One-hot select modules 1 starts on LSB
        .sel(module_select),

        // Outputs
        .out0(lcd_out0),
        .out1(lcd_out1),
        .out2(lcd_out2),
        .out3(lcd_out3)
    );

     // LCD clk
    wire lcd_clk;
    clk_divider lcd_divider(
        .clk(clk), 
        .slow_clk(lcd_clk), 
        .reset(1'b0), 
        .clk_bit_select(32'd576541) //2^19
    ); // 19
    
    // Actual LCD output
     lcd_block lcds(
        .clk(lcd_clk),
        .ones(lcd_out0),
        .tens(lcd_out1),
        .hundreds(lcd_out2),
        .thousands(lcd_out3),
        .lcd_out(lcd_out),
        .enabled_lcd_out(enabled_lcd_out)
//     , .OUT(OUT) // uncomment for debugging
        );
     
     // Debugging
     
////      module select
//     assign module_select_out = module_select;
//     // module 1
//     assign ones_out           = ones;
//     assign tens_out           = tens;
//     assign hundreds_out       = hundreds;
//     assign thousands_out      = thousands;
     
//     // module 2
//     assign count = combined_OUT;
//     assign ones_miles_out     = miles_ones;
//     assign tens_miles_out     = miles_tens;
//     assign hundreds_miles_out = miles_decimal_point;
//     assign decimal_miles_out = miles_decimal;
     
     // pulse gen
//     assign pulse_out_out = pulse_out;              // debugging for hardware
//     assign div_out_out = div_value ;
//     assign one_hz_clk_out = one_hz_clk;            // debugging for hardware
//     assign pulse_gen_count_out = pulse_gen_count; 
     assign state_out = state;

        
endmodule
