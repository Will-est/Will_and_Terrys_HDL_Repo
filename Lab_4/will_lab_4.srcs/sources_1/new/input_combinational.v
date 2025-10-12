`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10/10/2025
// Design Name:    Input Combinational Logic
// Module Name:    input_combinational
// Description:    Adds time values based on button presses and concatenates
//                 switch inputs. Also generates latch signals.
//
//////////////////////////////////////////////////////////////////////////////////

module input_combinational(
    input  wire buttonU,   // Add 10 seconds
    input  wire buttonL,   // Add 180 seconds
    input  wire buttonR,   // Add 200 seconds
    input  wire buttonD,   // Add 550 seconds

    input  wire switch0,
    input  wire switch1,

    output wire [13:0] button_sum,     // total seconds (max = 940)
    output wire [1:0] switch_concat,  // {switch1, switch0}
    output wire       latched_button, // high if any button is pressed
    output wire       latched_switch  // high if any switch is high
);

    // Button addition logic (weighted by their assigned seconds)
    assign button_sum =  (buttonU ? 14'd10  : 14'd0) +
                         (buttonL ? 14'd180 : 14'd0) +
                         (buttonR ? 14'd200 : 14'd0) +
                         (buttonD ? 14'd550 : 14'd0);

    // Concatenate switches
    assign switch_concat = {switch1, switch0};

    // Latch signals
    assign latched_button = buttonU | buttonL | buttonR | buttonD;
    assign latched_switch = switch0 | switch1;

endmodule
