`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 10:21:16 PM
// Design Name: 
// Module Name: top_2
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
module top (
    input wire clk,
    input wire start,
    input wire reset,
    // Matrix A
    input wire [7:0] arr_A0_0, arr_A0_1, arr_A0_2,
    input wire [7:0] arr_A1_0, arr_A1_1, arr_A1_2,
    input wire [7:0] arr_A2_0, arr_A2_1, arr_A2_2,
    // Matrix B
    input wire [7:0] arr_B0_0, arr_B0_1, arr_B0_2,
    input wire [7:0] arr_B1_0, arr_B1_1, arr_B1_2,
    input wire [7:0] arr_B2_0, arr_B2_1, arr_B2_2,
    // Matrix C
    output wire [7:0] arr_C0_0, arr_C0_1, arr_C0_2,
    output wire [7:0] arr_C1_0, arr_C1_1, arr_C1_2,
    output wire [7:0] arr_C2_0, arr_C2_1, arr_C2_2,
    output reg done
    
    //debugging
    ,
    output [2:0] i_out
);
    
     // initial arrays you are given
    reg [7:0] Big_Arr_A [5:0][2:0];
    reg [7:0] Big_Arr_B [5:0][2:0];
    
    // previous values of the arrays
    reg [7:0] Big_Arr_A_Prev [5:0][2:0];
    reg [7:0] Big_Arr_B_Prev [5:0][2:0];
    reg [7:0] Buffered_Output_Matrix [2:0][2:0];
    
    // Values of the 
    reg [7:0] Systolic_top[2:0];
    reg [7:0] Systolic_left[2:0];
    
    // Intermediate Values
    reg [2:0] i;
    reg internal_reset;
    initial 
    begin
        i = 3'd0;
        internal_reset = 1'b0;
    end
    
    
    wire net_reset;
    assign net_reset = internal_reset || reset;
    
    
    // Fills Matrices that we work with
    always @(*) begin
        // Matrix A → Big_Arr_A
        Big_Arr_A[0][0] = arr_A0_0; Big_Arr_A[0][1] = 8'd0;     Big_Arr_A[0][2] = 8'd0;
        Big_Arr_A[1][0] = arr_A1_0; Big_Arr_A[1][1] = arr_A0_1; Big_Arr_A[1][2] = 8'd0;
        Big_Arr_A[2][0] = arr_A2_0; Big_Arr_A[2][1] = arr_A1_1; Big_Arr_A[2][2] = arr_A0_2;
        Big_Arr_A[3][0] = 8'd0;     Big_Arr_A[3][1] = arr_A2_1; Big_Arr_A[3][2] = arr_A1_2;
        Big_Arr_A[4][0] = 8'd0;     Big_Arr_A[4][1] = 8'd0;     Big_Arr_A[4][2] = arr_A2_2;
        Big_Arr_A[5][0] = 8'd0;     Big_Arr_A[5][1] = 8'd0;     Big_Arr_A[5][2] = 8'd0;
        
        // Matrix B → Big_Arr_B
        Big_Arr_B[0][0] = arr_B0_0; Big_Arr_B[0][1] = 8'd0;     Big_Arr_B[0][2] = 8'd0;
        Big_Arr_B[1][0] = arr_B0_1; Big_Arr_B[1][1] = arr_B1_0; Big_Arr_B[1][2] = 8'd0;
        Big_Arr_B[2][0] = arr_B0_2; Big_Arr_B[2][1] = arr_B1_1; Big_Arr_B[2][2] = arr_B2_0;
        Big_Arr_B[3][0] = 8'd0;     Big_Arr_B[3][1] = arr_B1_2; Big_Arr_B[3][2] = arr_B2_1;
        Big_Arr_B[4][0] = 8'd0;     Big_Arr_B[4][1] = 8'd0;     Big_Arr_B[4][2] = arr_B2_2;
        Big_Arr_B[5][0] = 8'd0;     Big_Arr_B[5][1] = 8'd0;     Big_Arr_B[5][2] = 8'd0;
    end

    // Shifts through the row/column of the matrices when inputs change
    always @(posedge clk or posedge reset )
    begin
        // asynch reset
        if(reset)
        begin
             i <= 0; internal_reset <= 1'b1; done <= 1'b0;
        end
        else begin
            // If you are here, you are currently running data through the systolic array
            if((start) && (i<3'd6) )
            begin
                // increments i
                i <= i + 3'd1; internal_reset <= 1'b0; done <= 1'b0;
            end
            else begin
            // if you are here, then you have either restarted, or you have saturated your counting
                if(!start)
                begin
                // You go here if you reset your start
                    i <= 1'b0; internal_reset <= 1'b1; done <= 0;
                end else begin
                // You go here if you have saturated your counter but not restarted yet
                    i <= i; internal_reset <= internal_reset; done <= 1'b1;
                end
            end
        end
    end
    
    // loading Systolic Array from Buffer Arrays
    always@(negedge clk)
    begin
        if((start) && (i<3'd6) )
        begin
            // writes to top row of systolic array with new row from A
            Systolic_top[0] <= Big_Arr_A[i][0]; Systolic_top[1] <= Big_Arr_A[i][1]; Systolic_top[2] <= Big_Arr_A[i][2];
            
            // writes to the left side of the systolic array with a new column from B
            Systolic_left[0] <= Big_Arr_B[i][0]; Systolic_left[1] <= Big_Arr_B[i][1]; Systolic_left[2] <= Big_Arr_B[i][2];
        end
     end      
    

    // Internal interconnect wires (manually flattened)
    wire [7:0] a_00, a_01, a_02, a_10, a_11, a_12, a_20, a_21;
    wire [7:0] b_00, b_10, b_20, b_01, b_11, b_21;
    
   // Row 0
    MAC mac00 (.clk(clk), .reset(net_reset),
           .a_in(Systolic_top[0]), .b_in(Systolic_left[0]),
           .a_out(a_00), .b_out(b_00), .c_out(arr_C0_0));
    MAC mac01 (.clk(clk), .reset(net_reset),
           .a_in(Systolic_top[1]), .b_in(b_00),
           .a_out(a_01), .b_out(b_01), .c_out(arr_C0_1));
    MAC mac02 (.clk(clk), .reset(net_reset),
           .a_in(Systolic_top[2]), .b_in(b_01),
           .a_out(a_02), .b_out(), .c_out(arr_C0_2));
    // Row 1
    MAC mac10 (.clk(clk), .reset(net_reset),
           .a_in(a_00), .b_in(Systolic_left[1]),
           .a_out(a_10), .b_out(b_10), .c_out(arr_C1_0));
    MAC mac11 (.clk(clk), .reset(net_reset),
           .a_in(a_01), .b_in(b_10),
           .a_out(a_11), .b_out(b_11), .c_out(arr_C1_1));
    MAC mac12 (.clk(clk), .reset(net_reset),
           .a_in(a_02), .b_in(b_11),
           .a_out(a_12), .b_out(), .c_out(arr_C1_2));
    // Row 2
    MAC mac20 (.clk(clk), .reset(net_reset),
           .a_in(a_10), .b_in(Systolic_left[2]),
           .a_out(a_20), .b_out(b_20), .c_out(arr_C2_0));
    MAC mac21 (.clk(clk), .reset(net_reset),
           .a_in(a_11), .b_in(b_20),
           .a_out(a_21), .b_out(b_21), .c_out(arr_C2_1));
    MAC mac22 (.clk(clk), .reset(net_reset),
           .a_in(a_12), .b_in(b_21),
           .a_out(), .b_out(), .c_out(arr_C2_2));
           
           
           
// Debugging wires
assign i_out = i;
endmodule
