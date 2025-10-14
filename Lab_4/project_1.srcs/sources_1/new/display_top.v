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
    input [16:0] bin,
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
    wire [16:0] saturated_bin = (bin >= 17'd9999) ? 17'd9999 : bin;
    wire [13:0] bin14 = (bin > 17'd9999) ? 14'd9999 : bin[13:0];
    integer i;
    reg [27:0] shift;          // [27:17] BCD, [13:0] bin
    
    always @(*) begin
        th = 4'd0; hu = 4'd0; te = 4'd0; on = 4'd0;
        for (i = 13; i >= 0; i = i - 1) begin
      // add-3 to any digit >=5
            if (th >= 5) th = th + 4'd3;
            if (hu >= 5) hu = hu + 4'd3;
            if (te >= 5) te = te + 4'd3;
            if (on >= 5) on = on + 4'd3;

      // shift left the whole BCD vector by 1, bring in next binary bit
            th = {th[2:0], hu[3]};
            hu = {hu[2:0], te[3]};
            te = {te[2:0], on[3]};
            on = {on[2:0], bin14[i]};
        end
    end
    
    // output to lcd
    // LCD clk stuff
    wire lcd_clk;
    reg [31:0] lcd_clk_val = 32'd200011;
    clk_divider one_hz_clk(.clk(clk),.clk_bit_select(lcd_clk_val),.reset(1'b0),.slow_clk(lcd_clk));
    
    wire [6:0] seg_raw;
    wire [3:0] an_raw;
    
    lcd_block l1(
        .clk(lcd_clk),
        .ones(on),
        .tens(te),
        .hundreds(hu),
        .thousands(th),
        .lcd_out(seg_raw),
        .enabled_lcd_out(an_raw)
    );
    
    assign Seg = show ? seg_raw : 7'b1111111;
    assign An = show ? an_raw : 4'b1111;
    
endmodule
