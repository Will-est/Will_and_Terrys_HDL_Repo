`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 01:00:16 AM
// Design Name: 
// Module Name: FSM
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


`timescale 1ns / 1ps

// This module was initially written by GPT and then modified
`timescale 1ns / 1ps


// Will's comment
module FSM(

    // inputs
    input wire clk, 
    input wire clk_1hz,
    input wire [16:0] count,
    input wire button_in,
    input wire switch_in,
    
    // outputs
    output wire [1:0] state,
    output wire fsm_out,
    output wire button_en,
    output wire switch_en
);


    // internal registers that make sure you only enable the button/switch once for a single press
    reg internal_button_en, internal_switch_en; // sets the buttons to be enabled
    reg handled_button, handled_switch; // checks to see if the buttons have been handled for this press
    initial begin
        internal_button_en = 0;
        internal_switch_en = 0;
        handled_button = 0;
        handled_switch =0;
    end
    
    
    
    // State encoding based on count
    // 00 → count == 0
    // 01 → count < 200
    // 10 → count >= 200
    assign state = (count == 17'd0)   ? 2'b00 :
                   (count <  17'd200) ? 2'b01 :
                                            2'b10;

    
    // Tells the counter that it needs to do something if either:
    //      The 1hz clk is high so it needs to decrement
    //      the button is enabled so it needs to do button stuff
    //      the switch is enabled so it needs to do switch stuff
    assign fsm_out = ((button_in || clk_1hz || switch_in) && (~clk));
    
    // these tell the fsm when it can look at the button/switch input. 
    // if we don't have any issues with our switch debouncers, then we might get rid of this
    // and just connect the input combinational straight to the counter
    assign button_en = button_in;
    assign switch_en = switch_in;
    
    

endmodule


