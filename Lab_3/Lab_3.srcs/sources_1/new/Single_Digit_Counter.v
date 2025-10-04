`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2025
// Design Name: BCD Counter
// Module Name: BCD_Counter
// Target Devices: 
// Tool Versions: 
// Description: A decade (0-9) counter with load, enable, up/down, and carry-out.
// 
//////////////////////////////////////////////////////////////////////////////////

module sinlge_digit_counter(
// inputs
    input enable,        // counter enable
    input reset,         // asynchronous reset
    input clk,           // clock
    input [3:0] Data,
    
    // outputs
    output reg [3:0] OUT, // BCD output
    output reg CO        // carry out
);
    initial OUT = 3'b000;
    
    // Sequential logic
    // basically just a register that checks if enable is there before we increment

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset case
            OUT <= 4'd0;
            CO <= 1'b0;
        end 
        else if (enable) begin
            if (OUT == 4'd9) begin
                CO <= 1'b1;
                OUT <= 4'd0;
            end else begin
                OUT <= OUT + 1; // increments
                CO <= 1'b0;
            end
        end
    end
    
    
//    assign CO = (OUT == 4'd9) && (~reset) ;
endmodule