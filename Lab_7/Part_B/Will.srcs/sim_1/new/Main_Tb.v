`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 03:22:28 PM
// Design Name: 
// Module Name: top_tb
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


// You can use this skeleton testbench code, the textbook testbench code, or your own
module Main_Tb ();
    parameter N = 60;
    // MIPS stuff
    reg CLK;
    wire CS;
    wire WE;
    wire [31:0] Mem_Bus_Wire;
    wire [6:0] Address;
    wire [7:0] LEDS;
    
   
    // tb stuff
    integer i;
    reg[31:0] expected[N:1];
    reg rst;
    
    MIPS CPU(.CLK(CLK), .RST(rst), .CS(CS), .WE(WE), .ADDR(Address), .Mem_Bus(Mem_Bus_Wire),.Halt(Halt), .LEDS(LEDS));
    Memory MEM(CS, WE, CLK, Address, Mem_Bus_Wire);
  
  
    always #5 CLK <= ~CLK;
    initial begin
      $display("Testing Beginning:");
      expected[1] = 32'h00000006; // $1 content=6 decimal
      expected[2] = 32'h00000012; // $2 content=18 decimal
      expected[3] = 32'h00000018; // $3 content=24 decimal
      expected[4] = 32'h0000000C; // $4 content=12 decimal
      expected[5] = 32'h00000002; // $5 content=2
      expected[6] = 32'h00000016; // $6 content=22 decimal
      expected[7] = 32'h00000001; // $7 content=1
      expected[8] = 32'h00000120; // $8 content=288 decimal
      expected[9] = 32'h00000003; // $9 content=3
      expected[10] = 32'h00412022; // $10 content=5th instr
      CLK = 1;    
    end
    initial
    begin
        #10 rst = 1;
        #10 rst = 0;
        i = 1;
        repeat(N) begin        
            @(posedge CLK);            
            $display ("Memory at Cycle %d Address %h was %h. CS was: %b WE was: %b", i, Address, Mem_Bus_Wire, CS, WE);            
            i = i + 1;
            // AddressTB = AddressTB + 1; // if you want to manually walk through memory
         end
             
        $display("TEST COMPLETE");
        $stop;
  end

endmodule
