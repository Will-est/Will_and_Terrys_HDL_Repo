`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 01:34:50 PM
// Design Name: 
// Module Name: sevenseg_mux
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


module sevenseg_mux(
    input clk, input reset,
    input [3:0] th, hu, te, on,
    input        show,           // gate for blink/blank
    output reg [3:0] AN,         // anodes
    output reg [6:0] SEG
);
    reg [15:0] div;
    reg [1:0]  sel;
    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            div <= 0; 
            sel <= 0; 
        end else begin 
            div <= div + 1; 
            if (div == 0) 
                sel <= sel + 1; 
        end
    end

    always @* begin
        AN  = 4'b1111;  // all off 
        SEG = 7'b1111111;
        if (show) begin
            case (sel)
                2'd0: begin AN = 4'b1110; SEG = seg7_decode(on); end
                2'd1: begin AN = 4'b1101; SEG = seg7_decode(te); end
                2'd2: begin AN = 4'b1011; SEG = seg7_decode(hu); end
                2'd3: begin AN = 4'b0111; SEG = seg7_decode(th); end
            endcase
        end
    end
    
    function [6:0] seg7_decode; // {a,b,c,d,e,f,g}, adjust for your polarity
        input [3:0] d;
        case (d)
            4'd0: seg7_decode = 7'b0000001;
            4'd1: seg7_decode = 7'b1001111;
            4'd2: seg7_decode = 7'b0010010;
            4'd3: seg7_decode = 7'b0000110;
            4'd4: seg7_decode = 7'b1001100;
            4'd5: seg7_decode = 7'b0100100;
            4'd6: seg7_decode = 7'b0100000;
            4'd7: seg7_decode = 7'b0001111;
            4'd8: seg7_decode = 7'b0000000;
            4'd9: seg7_decode = 7'b0000100;
            default: seg7_decode = 7'b1111110; // dash/blank as needed
        endcase
    endfunction
endmodule



