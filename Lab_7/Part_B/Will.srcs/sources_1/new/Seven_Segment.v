
`timescale 1ns / 1ps

module Seven_Segment(
    input clk,
    input reset,
    input [15:0] sw,
    output [3:0] an,
    output [6:0] sseg
);
    wire [6:0] in0, in1, in2, in3;
    wire slow_clk;
    
    //hexto7Segment Decoders
    HexToSeg c1(.x(sw[3:0]), .r(in0));  
    HexToSeg c2(.x(sw[7:4]), .r(in1));   
    HexToSeg c3(.x(sw[11:8]), .r(in2));   
    HexToSeg c4(.x(sw[15:12]), .r(in3));   
    
    //clock divider
    clk_div_disp c5 (.clk(clk), .reset(reset), .slow_clk(slow_clk));
    
    //mux
    Segment_Multiplexer x6(
    .clk(slow_clk),
    .reset (reset),
    .in0 (in0),
    .in1 (in1),
    .in2 (in2),
    .in3 (in3),
    .an (an),
    .sseg (sseg)
    );    
endmodule


module clk_div_disp(clk, slow_clk, reset);
    input clk;
    input reset;
    output wire slow_clk;
    
    reg[15:0] count;
    reg pulse;
    
    initial count <= 0;

    assign slow_clk = count[15];

    always @(posedge clk)
    begin
        count = count + 1; 
    end


    
    assign slow_clk = pulse;


endmodule