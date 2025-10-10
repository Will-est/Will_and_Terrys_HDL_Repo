`timescale 1ns / 1ps

module counter (
    input wire fsm_out,             // trigger from FSM module
    input wire clk_1hz,             // 1Hz clock signal
    input wire button,              // button input
    input wire switch,              // switch selector
    input wire [13:0] add_val,      // value to add when button pressed
    input wire [1:0] switch_values, // array of 2 reset values
    output reg [13:0] count_reg     // stored counter value
);

    initial count_reg = 14'd0;

    always @(posedge fsm_out) begin
        case ({switch, button, clk_1hz})
            3'b000: count_reg <= count_reg;                                                                // hold
            3'b001: count_reg <= (count_reg > 14'd0)    ? count_reg - 14'd1 : 14'd0;                       // clk only
            3'b010: count_reg <= (count_reg < 14'd9999) ? count_reg + add_val : 14'd9999;                  // button only
            3'b011: count_reg <= (count_reg < 14'd9999) ? count_reg + (add_val - 14'd1) : 14'd9999;        // both high
            default: count_reg <= (switch_values[0]) ? 10 : 205;                                           // covers all cases when the switches are high
                                                                    
        endcase
    end

endmodule
