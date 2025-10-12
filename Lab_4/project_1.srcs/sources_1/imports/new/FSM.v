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
    input wire [13:0] count,
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
    
    // FSM to make sure that buttons are only enabled once after you press.
    // Highly recommend that you shrink this if you aren't debugging it, it is very long
    always@(posedge clk)
    begin
        // button stuff
        
        // if you haven't handled the button yet, we need to set the internal_button_en = 1
        if(!handled_button && button_in)
        begin
            internal_button_en <= 1;
            handled_button <= 1;
            
        // if we have handled the button already, we need to check the current button input
        end else 
        begin
        
            // if the handled_button = 1 but the button is low, we need to reset handled_button
            if( !button_in) 
            begin
                handled_button <= 0;
                internal_button_en <= 0;
                
            // otherwise we keep handled_button the same
             end else
             begin  
                handled_button <= 1;
                internal_button_en <= 0;
             end
        end
        
        // switch stuff
        
        // if you haven't handled the button yet, we need to set the internal_button_en = 1
        if(!handled_switch && switch_in)
        begin
            internal_switch_en <= 1;
            handled_switch <= 1;
            
        // if we have handled the button already, we need to check the current button input
        end else 
        begin
        
            // if the handled_button = 1 but the button is low, we need to reset handled_button
            if( !switch_in) 
            begin
                handled_switch <= 0;
                internal_switch_en <= 0;
                
            // otherwise we keep handled_button the same
             end else
             begin  
                handled_switch <= 1;
                internal_switch_en <= 0;
             end
        end
    end
    
    
    // basically tells the counter that it can be looking at the button/switch input
    // this comes from/is a part of the stuff above
    assign button_en = internal_button_en;
    assign switch_en = internal_switch_en;
    
    
    // State encoding based on count
    // 00 → count == 0
    // 01 → count < 200
    // 10 → count >= 200
    assign state = (count == 14'd0)   ? 2'b00 :
                   (count <  14'd200) ? 2'b01 :
                                            2'b10;

    
    // Tells the counter that it needs to do something if either:
    //      The 1hz clk is high so it needs to decrement
    //      the button is enabled so it needs to do button stuff
    //      the switch is enabled so it needs to do switch stuff
    assign fsm_out = ((internal_button_en || clk_1hz || internal_button_en) && (~clk));
    
    

endmodule


