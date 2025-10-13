`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2025 04:25:34 PM
// Design Name: 
// Module Name: tb_display_top
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


module tb_display_top;
    // ports for input to display
    reg         clk      = 1'b0;
    reg  [1:0]  mode     = 2'b00;
    reg         tick_1hz = 1'b0;     // single-cycle pulses
    reg         tick_2hz = 1'b0;     // single-cycle pulses
    reg  [13:0] bin      = 14'd0;
    
    wire [3:0] AN;
    wire [6:0] SEG;
    
    // === Time-scaled tick generators (for fast sim) ===
  // 1 "second" every 1000 clk cycles (~10 us) and 2 Hz every 500 cycles (~5 us)
  localparam integer HZ1_DIV = 1000;
  localparam integer HZ2_DIV =  500;

  integer c1 = 0, c2 = 0;
  always @(posedge clk) begin
    // 1 Hz tick (1-cycle pulse)
    if (c1 == HZ1_DIV-1) begin
      c1       <= 0;
      tick_1hz <= 1'b1;
    end else begin
      c1       <= c1 + 1;
      tick_1hz <= 1'b0;
    end

    // 2 Hz tick (1-cycle pulse)
    if (c2 == HZ2_DIV-1) begin
      c2       <= 0;
      tick_2hz <= 1'b1;
    end else begin
      c2       <= c2 + 1;
      tick_2hz <= 1'b0;
    end
  end
  
  initial begin
    $timeformat(-9,3," ns",10);
    $display(" time        mode  bin   AN    SEG");
    forever begin
      @(posedge clk);
      if ($time % 2000 == 0) // print every ~2 us to reduce spam
        $display("%t  %b   %0d   %b  %b", $realtime, mode, bin, AN, SEG);
    end
  end
  // === Stimulus plan ===
  // 1) mode=00 (2 Hz blink): keep bin steady and watch SEG/AN blank/show at 2 Hz
  // 2) mode=01 (even-second gate & 1 Hz phase):
  //      - drive bin odd/even around the 1 Hz phase to see ON only when even & phase=1
  // 3) mode=10 (solid): verify steady show
  // 4) mode=11 (solid): again steady show; also sweep bin to see decoder changes
  initial begin
    // VCD (xsim supports it; if not needed, you can ignore)
    $dumpfile("tb_display_top.vcd");
    $dumpvars(0, tb_display_top);

    // ---- 1) 2 Hz blink (mode 00) ----
    mode = 2'b00;   bin = 14'd42;         // arbitrary value
    #(250_000);                            // ~250 us (many 2 Hz phases @ sim scale)

    // ---- 2) Even&phase gate (mode 01) ----
    mode = 2'b01;
    bin  = 14'd198;  #(120_000);          // even (<200) → visible only when 1 Hz phase is high
    bin  = 14'd199;  #(120_000);          // odd  (<200) → always blank regardless of phase
    bin  = 14'd200;  #(120_000);          // >=200 → your blink_gate ignores even/odd in this mode? (we're still in mode=01, so still gated by even&phase)
    bin  = 14'd198;  #(200_000);          // back to even to confirm behavior

    // ---- 3) Solid (mode 10) ----
    mode = 2'b10;   bin = 14'd1234;       // steady show; no blanking
    #(250_000);

    // ---- 4) Solid (mode 11) + quick sweeps ----
    mode = 2'b11;   bin = 14'd4321;       // steady show
    #(150_000);
    bin  = 14'd9876; #(150_000);
    bin  = 14'd2468; #(150_000);

    $stop; // Vivado-friendly end
  end

  // === DUT instance ===
  display_top dut (
    .clk      (clk),
    .mode     (mode),
    .tick_1hz (tick_1hz),
    .tick_2hz (tick_2hz),
    .bin      (bin),
    .An       (AN),
    .Seg      (SEG)
  );

endmodule
