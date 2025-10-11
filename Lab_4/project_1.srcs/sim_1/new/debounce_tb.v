`timescale 1ns/1ps

module debounce_tb;
  // DUT I/O
  reg  clk = 0;
  reg  btn_in = 0;
  wire btn_out;

  // Pulse counter
  integer pulse_count = 0;

  // Clock: 100 MHz (10 ns period)
  always #5 clk = ~clk;

  // Instantiate your DUT (DebounceSP is from your code)
  DebounceSP dut(
    .clk(clk),
    .btn_in(btn_in),
    .btn_out(btn_out)
  );

  // Count 1-cycle pulses
  always @(posedge clk) if (btn_out) pulse_count = pulse_count + 1;

  initial begin
    // Waves
    $dumpfile("debounce_tb.vcd");
    $dumpvars(0, debounce_tb);

    // Settle a few clocks
    repeat (5) @(posedge clk);

    // Clean press (expect 1 pulse)
    btn_in = 1;  repeat (10) @(posedge clk);
    btn_in = 0;  repeat (10) @(posedge clk);

    // Quick bounce within one clock (still 1 net pulse total for this action)
    // 1 -> 0 -> 1 all within 10ns
    #2 btn_in = 1; #3 btn_in = 0; #3 btn_in = 1;  // total 8ns < 1 clk
    repeat (6) @(posedge clk);
    btn_in = 0;  repeat (10) @(posedge clk);

    $display("Total pulses seen on btn_out = %0d", pulse_count);
    $finish;
  end
endmodule
