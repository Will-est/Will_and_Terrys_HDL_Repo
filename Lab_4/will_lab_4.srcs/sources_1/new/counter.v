`timescale 1ns / 1ps

module counter (
    // inputs
    input wire fsm_out,             // trigger from FSM module
    input wire clk_1hz,             // 1Hz clock signal
    input wire button_en,              // button input
    input wire switch_en,              // switch selector
    input wire [16:0] add_val,      // value to add when button pressed
    input wire [1:0] switch_values, // array of 2 reset values
    
    // outputs
    output reg [16:0] count_reg     // stored counter value
);

    initial count_reg = 17'd0;

    always @(posedge fsm_out) begin
        case ({switch_en, button_en, clk_1hz})
            3'b000: count_reg = count_reg;                                                                // hold
            3'b001: count_reg = count_reg - 17'd1;                       // clk only
            3'b010: count_reg = count_reg + add_val;                  // button only
            3'b011: count_reg = count_reg + (add_val - 17'd1);        // both high
            3'b100: count_reg = (switch_values[0]) ? 10 : 205;
            3'b101: count_reg = ((switch_values[0]) ? 10 : 205);
            3'b110: count_reg = ((switch_values[0]) ? 10 : 205);
            3'b111: count_reg = ((switch_values[0]) ? 10 : 205) ;
            default: count_reg = count_reg;                                           // covers all cases when the switches are high                                                                  
        endcase
        
        // if the result from count was negative, make it 0, because it should never be negative
        if(count_reg[16]==1'b1)
            count_reg = 17'd0;
        
        // makes sure that it doesn't saturate
        if(count_reg>=17'd9999)
            count_reg = 17'd9999;
    end

endmodule
