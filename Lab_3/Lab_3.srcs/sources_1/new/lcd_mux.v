`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2025 07:41:54 PM
// Design Name: 
// Module Name: lcd_mux
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

// brought to you by gpt
`timescale 1ns / 1ps


module lcd_mux (
    // Group 0
    input  wire [3:0] in0_0,
    input  wire [3:0] in0_1,
    input  wire [3:0] in0_2,
    input  wire [3:0] in0_3,

    // Group 1
    input  wire [3:0] in1_0,
    input  wire [3:0] in1_1,
    input  wire [3:0] in1_2,
    input  wire [3:0] in1_3,

    // Group 2
    input  wire [3:0] in2_0,
    input  wire [3:0] in2_1,
    input  wire [3:0] in2_2,
    input  wire [3:0] in2_3,

    // Group 3
    input  wire [3:0] in3_0,
    input  wire [3:0] in3_1,
    input  wire [3:0] in3_2,
    input  wire [3:0] in3_3,

    // One-hot select
    input  wire [3:0] sel,

    // Outputs (4×4-bit group)
    output reg [3:0] out0,
    output reg [3:0] out1,
    output reg [3:0] out2,
    output reg [3:0] out3
);

    always @(*) begin
        case (sel)
            4'b0001: begin
                out0 = in0_0; out1 = in0_1; out2 = in0_2; out3 = in0_3;
//                out0 = in1_0; out1 = in1_1; out2 = in1_2; out3 = in1_3;
//                out0 = in2_0; out1 = in2_1; out2 = in2_2; out3 = in2_3;
//                out0 = in3_0; out1 = in3_1; out2 = in3_2; out3 = in3_3;
                
            end
            4'b0010: begin
//                out0 = in0_0; out1 = in0_1; out2 = in0_2; out3 = in0_3;
                out0 = in1_0; out1 = in1_1; out2 = in1_2; out3 = in1_3;
//                out0 = in2_0; out1 = in2_1; out2 = in2_2; out3 = in2_3;
//                out0 = in3_0; out1 = in3_1; out2 = in3_2; out3 = in3_3;
            end
            4'b0100: begin
//                out0 = in0_0; out1 = in0_1; out2 = in0_2; out3 = in0_3;
//                out0 = in1_0; out1 = in1_1; out2 = in1_2; out3 = in1_3;
                out0 = in2_0; out1 = in2_1; out2 = in2_2; out3 = in2_3;
//                out0 = in3_0; out1 = in3_1; out2 = in3_2; out3 = in3_3;
            end
            4'b1000: begin
//                out0 = in0_0; out1 = in0_1; out2 = in0_2; out3 = in0_3;
//                out0 = in1_0; out1 = in1_1; out2 = in1_2; out3 = in1_3;
//                out0 = in2_0; out1 = in2_1; out2 = in2_2; out3 = in2_3;
                out0 = in3_0; out1 = in3_1; out2 = in3_2; out3 = in3_3;
            end
            default: begin
                out0 = 4'b0000; out1 = 4'b0000; out2 = 4'b0000; out3 = 4'b0000;
            end
        endcase
    end

endmodule

