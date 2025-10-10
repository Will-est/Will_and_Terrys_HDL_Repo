`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2025 10:17:58 PM
// Design Name: 
// Module Name: clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

// Note: this clk divider was made to rise on the same edge as the clk.


module clk_divider (
    //----------Ports----------
    input               clk,            
    input      [31:0]   clk_bit_select, 
    input               reset,
    output wire         slow_clk        
);

    //----------Internal Signals----------
    reg [31:0] counter;
    initial counter = 32'd0;

    reg [31:0] prev_clk_bit_select; // Store previous value
    initial prev_clk_bit_select = 32'd0;

    assign slow_clk = (counter == (clk_bit_select-1)) ;

    reg was_reset;
    initial was_reset = 1'b0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 32'd0;
            was_reset <= 1;
        end else if (was_reset) begin
            counter <= clk_bit_select - 1;
            was_reset <= 0;
        end else if (slow_clk) begin
            counter <= 32'd0;
        end else begin
            counter <= counter + 1'b1;
        end
    end

endmodule