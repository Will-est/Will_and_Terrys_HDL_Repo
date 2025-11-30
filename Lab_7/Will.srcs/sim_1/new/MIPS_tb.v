`timescale 1ns / 1ps

module MIPS_tb();
  reg CLK;
  reg RST;
  wire CS;
  wire WE;
  wire [31:0] Mem_Bus;
  wire [31:0] Address;
  
  integer i;
  integer instruction_count;
  
  // Instantiate MIPS processor and Memory
  MIPS CPU(CLK, RST, CS, WE, Address, Mem_Bus);
  Memory MEM(CS, WE, CLK, Address, Mem_Bus);
  
  // Clock generation - 10ns period (100MHz)
  initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
  end
  
  initial begin
    $display("========================================");
    $display("MIPS Processor Testbench Starting...");
    $display("========================================");
    $display("Time: %0t", $time);
    
    // Initialize
    RST = 1;
    instruction_count = 0;
    
    // Load instructions from file into memory
    $display("\n[%0t] Loading instructions from file...", $time);
    $readmemh("instructions.txt", memory_init.txt);
    $display("[%0t] Instructions loaded successfully", $time);
    
    // Hold reset for 2 clock cycles
    @(posedge CLK);
    @(posedge CLK);
    
    // Release reset
    $display("\n[%0t] Releasing reset - Starting execution", $time);
    RST = 0;
    
    // Monitor execution for sufficient cycles
    // Adjust the number based on your program length
    repeat(100) begin
      @(posedge CLK);
      instruction_count = instruction_count + 1;
      
      // Display memory writes
      if (WE && CS) begin
        $display("[%0t] Cycle %0d: WRITE - Address=0x%h, Data=0x%h (%0d decimal)", 
                 $time, instruction_count, Address, Mem_Bus, Mem_Bus);
      end
      
      // Optional: Display PC progression
      // Uncomment if your MIPS module exposes PC
      // $display("[%0t] Cycle %0d: PC=0x%h", $time, instruction_count, CPU.PC);
    end
    
    $display("\n========================================");
    $display("Test Results Summary");
    $display("========================================");
    $display("Total cycles executed: %0d", instruction_count);
    $display("\nMemory Contents (Data Section):");
    $display("----------------------------------------");
    
    // Display relevant memory locations
    // Adjust addresses based on where your program stores results
    for (i = 128; i < 150; i = i + 1) begin
      if (MEM.Mem[i] !== 32'hxxxxxxxx && MEM.Mem[i] !== 32'h00000000) begin
        $display("Mem[%0d] = 0x%h (%0d decimal)", i, MEM.Mem[i], MEM.Mem[i]);
      end
    end
    
    $display("\n========================================");
    $display("TEST COMPLETE");
    $display("========================================");
    $stop;
  end
  
  // Optional: Timeout watchdog
  initial begin
    #50000; // 50us timeout
    $display("\n*** ERROR: Simulation timeout! ***");
    $stop;
  end
  
endmodule