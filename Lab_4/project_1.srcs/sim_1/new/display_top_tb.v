`timescale 1ns/1ps
// ============================================================
// display_top_tb.v  -- Focused testbench for blink gate logic
// ============================================================
// This testbench only verifies the blink gating behavior in
// display_top. It monitors internal 'show' and output changes
// for each mode.
//
// Modes (expected meanings):
//   00 -> blink at 2 Hz
//   01 -> blink at 1 Hz when bin[0]==0
//   10 -> always on/off (depends on design)
//   11 -> always on
//
// Watch:  show, tick_1hz, tick_2hz, mode, An, Seg
// ============================================================

module display_top_tb;

  reg clk = 0;
  reg reset = 1;
  reg [13:0] bin = 14'd37;   // fixed number for visible blinking
  reg [1:0] mode = 2'b00;
  reg tick_1hz = 0;
  reg tick_2hz = 0;

  wire [3:0] An;
  wire [6:0] Seg;

  // Instantiate DUT
  display_top dut (
    .clk(clk),
    .reset(reset),
    .bin(bin),
    .mode(mode),
    .tick_1hz(tick_1hz),
    .tick_2hz(tick_2hz),
    .An(An),
    .Seg(Seg)
  );

  // 100 MHz main clock
  always #5 clk = ~clk;

  // Fast-simulated "1 Hz" and "2 Hz" pulses
  localparam integer T1 = 2000;
  localparam integer T2 = 1000;
  localparam integer PW = 20;

  initial begin
    tick_1hz = 0;
    #(T1/2);
    forever begin
      tick_1hz = 1; #(PW);
      tick_1hz = 0; #(T1 - PW);
    end
  end

  initial begin
    tick_2hz = 0;
    #(T2/3);
    forever begin
      tick_2hz = 1; #(PW);
      tick_2hz = 0; #(T2 - PW);
    end
  end

  // Reset
  initial begin
    reset = 1;
    repeat (5) @(posedge clk);
    reset = 0;
  end

  // Cycle modes to test blink logic response
  initial begin
    @(negedge reset);
    mode <= 2'b00; #(30000);
    mode <= 2'b01; #(30000);
    mode <= 2'b10; #(30000);
    mode <= 2'b11; #(30000);
    #(20000);
    $finish;
  end

  // Extract internal blink gate signal from DUT
  wire show;
  assign show = dut.show;

  // Waveform dump and logging
  initial begin
    $dumpfile("display_top_tb.vcd");
    $dumpvars(0, display_top_tb);

    $display("   time | rst mode | tick1 tick2 | show | An Seg");
    $monitor("%8t |  %b   %02b   |   %b     %b   |  %b   | %b %07b",
             $time, reset, mode, tick_1hz, tick_2hz, show, An, Seg);
  end

endmodule
