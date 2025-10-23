`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 05:13:09 PM
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
    input clk,
    input  wire buttonU,   // Add 10 seconds
    input  wire buttonL,   // Add 180 seconds
    input  wire buttonR,   // Add 200 seconds
    input  wire buttonD,   // Add 550 seconds

    input  wire switch0,
    input  wire switch1,
    output wire [3:0] AN,
    output wire [6:0] SEG
    
    // debugging
//    ,
//    output [13:0] count_out,
//    output fsm_out_out,
//    output debouncedU_out,
//    output debouncedL_out,
//    output debouncedR_out,
//    output debouncedD_out,
//    output debounced_switch0_out,
//    output debounced_switch1_out,
//    output [1:0] state_out
    );
    //-----------------------------------------------------------------------------------------
    // clks
    //-----------------------------------------------------------------------------------------
    wire clk_1hz, clk_2hz, clk_4hz;
    reg [31:0] one_hz_div_val = 32'd100000000;
    reg [31:0] two_hz_div_val = 32'd50000000;
    reg [31:0] four_hz_div_val = 32'd25000000;
    
    // 1 Hz clk
    clk_divider one_hz_clk(.clk(clk),.clk_bit_select(one_hz_div_val),.reset(1'b0),.slow_clk(clk_1hz));
    // 2 Hz clk
    clk_divider two_hz_clk(.clk(clk),.clk_bit_select(two_hz_div_val),.reset(1'b0),.slow_clk(clk_2hz));
    // 4 Hz clk
    clk_divider four_hz_clk(.clk(clk),.clk_bit_select(four_hz_div_val),.reset(1'b0),.slow_clk(clk_4hz));
    
    //-----------------------------------------------------------------------------------------
    // debounced inputs 
    //-----------------------------------------------------------------------------------------
    wire debouncedU, debouncedL, debouncedR, debouncedD, debounced_switch0, debounced_switch1;
    
    // buttons
    DebounceSP debouncer_u(.clk(clk),.btn_in(buttonU),.btn_out(debouncedU));
    DebounceSP debouncer_l(.clk(clk),.btn_in(buttonL),.btn_out(debouncedL));
    DebounceSP debouncer_r(.clk(clk),.btn_in(buttonR),.btn_out(debouncedR));
    DebounceSP debouncer_d(.clk(clk),.btn_in(buttonD),.btn_out(debouncedD));
    
    //switches
    DebounceSP debouncer_sw0(.clk(clk),.btn_in(switch0),.btn_out(debounced_switch0));
    DebounceSP debouncer_sw1(.clk(clk),.btn_in(switch1),.btn_out(debounced_switch1));
    
    //-----------------------------------------------------------------------------------------
    // combinational Logic to output the inputs to the counter for the add logic and the switch logic
    //-----------------------------------------------------------------------------------------
    wire [13:0] button_sum;     // total seconds (max = 940)
    wire [1:0] switch_concat;  // {switch1, switch0}
    wire       latched_button; // high if any button is pressed
    wire       latched_switch; 
    
    input_combinational input_comb(
        // inputs
        .buttonU(debouncedU),
        .buttonL(debouncedL),
        .buttonR(debouncedR),
        .buttonD(debouncedD),
        .switch0(debounced_switch0),
        .switch1(debounced_switch1),
        
        // outputs
        .button_sum(button_sum),
        .switch_concat(switch_concat),
        .latched_button(latched_button),
        .latched_switch(latched_switch)
    );
            
    //-----------------------------------------------------------------------------------------
    // FSM
    //-----------------------------------------------------------------------------------------  
    // counter wire because the counter feeds into the FSM and visa-versa
    wire [13:0] count;
    
    // FSM wires
    wire [1:0] state;
    wire fsm_out;
    wire button_en;
    wire switch_en;
    
    FSM fsm(
        // inputs
        .clk(clk), 
        .clk_1hz(clk_1hz),
        .count(count),
        .button_in(latched_button),
        .switch_in(latched_switch),
    
        // outputs
        .state(state),
        .fsm_out(fsm_out),
        .button_en(button_en),
        .switch_en(switch_en)
    );
    
    //-----------------------------------------------------------------------------------------
    // counter module
    //-----------------------------------------------------------------------------------------  
    counter counter_reg(
        // inputs
        .fsm_out(fsm_out),             // trigger from FSM module
        .clk_1hz(clk_1hz),             // 1Hz clock signal
        .button_en(button_en),              // button input
        .switch_en(switch_en),              // switch selector
        .add_val(button_sum),      // value to add when button pressed
        .switch_values(switch_concat), // array of 2 reset values
        
        // outputs
        .count_reg(count)
    ); 
    //-----------------------------------------------------------------------------------------
    // BCD
    //-----------------------------------------------------------------------------------------  
    
    display_top d1(
        .clk(clk),              // sysclk
        .bin(count),            // saturated once in counter, once in display
        .mode(state),           // state for output
        .tick_1hz(clk_1hz),     // 1 hz clk
        .tick_2hz(clk_2hz),  // Will I'm pretty sure it's 2 hz lol
        .An(AN),
        .Seg(SEG)
    );
    
    //-----------------------------------------------------------------------------------------
    // Debugging
    //-----------------------------------------------------------------------------------------  
//    // comment out if you don't need
//    assign count_out = count;
//    assign fsm_out_out = fsm_out;
//    assign debouncedU_out = debouncedU;
//    assign debouncedL_out = debouncedL;
//    assign debouncedR_out = debouncedR;
//    assign debouncedD_out = debouncedD;
//    assign debounced_switch0_out = debounced_switch0;
//    assign debounced_switch1_out = debounced_switch1;
//    assign state_out = state;
    
endmodule
