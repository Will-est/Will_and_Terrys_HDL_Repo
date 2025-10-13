`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 03:49:26 PM
// Design Name: 
// Module Name: display_top
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


module display_top(
    input clk,
    input reset,
    input [13:0] bin,
    input [1:0] mode,
    input tick_1hz,
    input tick_2hz,
    output [3:0] An,
    output[6:0] Seg
    );
    
    
    // blink gate
    reg one_hz_phase, two_hz_phase;
    reg show;
    initial begin
        one_hz_phase = 1'b0;
        two_hz_phase = 1'b0;
    end
    
    always @(posedge clk) begin
        if(tick_1hz)
            one_hz_phase <= ~one_hz_phase;
        if(tick_2hz)
            two_hz_phase <= ~two_hz_phase;        
    end
    
    always @(*) begin
        show = 1'b1;
        case (mode)
            2'b00: show = two_hz_phase;
            2'b01: show = one_hz_phase;
            2'b10: show = 1'b1;
            2'b11: show = 1'b1;
            default: show = 1'b1;
        endcase
    end
    
    // bin to bcd
    reg [3:0] th,hu,te,on;
    //safety saturation
    wire [13:0] saturated_bin = (bin >= 14'd9999) ? 14'd9999 : bin;
    integer i;
    reg [27:0] shift;          // [27:14] BCD, [13:0] bin
    always @* begin
        shift = {14'd0, bin};
        for (i = 0; i < 14; i = i+1) begin
            // add-3 to each BCD nibble if >= 5
            if (shift[27:24] >= 5) shift[27:24] = shift[27:24] + 4'd3;
            if (shift[23:20] >= 5) shift[23:20] = shift[23:20] + 4'd3;
            if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 4'd3;
            if (shift[15:12] >= 5) shift[15:12] = shift[15:12] + 4'd3;
            shift = shift << 1;
        end
        th = shift[27:24]; hu = shift[23:20]; te = shift[19:16]; on = shift[15:12];
    end
    
    // output to lcd
    lcd_block l1(
        .clk(clk),
        .ones(on),
        .tens(te),
        .hundreds(hu),
        .thousands(th),
        .lcd_out(Seg),
        .enabled_lcd_out(An)
    );
endmodule
