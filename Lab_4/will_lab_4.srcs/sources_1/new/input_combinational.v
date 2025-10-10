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

    output wire [9:0] button_sum,     // total seconds (max = 940)
    output wire [1:0] switch_concat,  // {switch1, switch0}
    output wire       latched_button, // high if any button is pressed
    output wire       latched_switch  // high if any switch is high
);

    // Button addition logic (weighted by their assigned seconds)
    assign button_sum =  (buttonU ? 10  : 0) +
                         (buttonL ? 180 : 0) +
                         (buttonR ? 200 : 0) +
                         (buttonD ? 550 : 0);

    // Concatenate switches
    assign switch_concat = {switch1, switch0};

    // Latch signals
    assign latched_button = buttonU | buttonL | buttonR | buttonD;
    assign latched_switch = switch0 | switch1;

endmodule
