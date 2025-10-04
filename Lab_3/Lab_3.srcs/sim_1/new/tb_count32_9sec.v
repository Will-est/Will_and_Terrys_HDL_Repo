`timescale 1ns/1ps

module tb_count32_9sec;

  // DUT ports
  reg         clk;
  reg         reset;
  reg         count_ready;
  reg  [15:0] step_count;
  wire [3:0]  hi_steps;
  wire        done9;

  // Instantiate DUT
  count32_9sec dut (
    .clk(clk),
    .reset(reset),
    .count_ready(count_ready),
    .step_count(step_count),
    .hi_steps(hi_steps),
    .done9(done9)
  );

  // 100 MHz clock (10 ns)
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // ------------------------------------------------------------------
  // Helper: ensure count_ready is exactly 1 cycle when asserted
  // ------------------------------------------------------------------
  reg cr_seen_high;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      cr_seen_high <= 1'b0;
    end else begin
      if (count_ready) begin
        if (cr_seen_high) begin
          $display("[%0t] WARN: count_ready high > 1 cycle!", $time);
        end
        cr_seen_high <= 1'b1;
      end else begin
        cr_seen_high <= 1'b0;
      end
    end
  end

  // ------------------------------------------------------------------
  // Task: push one completed "second" worth of steps
  //   - Places data first
  //   - Raises count_ready for exactly 1 clk
  //   - Drops count_ready and stays low 'idle_low_clks' cycles before next push
  // ------------------------------------------------------------------
  task push_second;
    input [15:0] count;
    input integer idle_low_clks; // >= 1 (how long count_ready stays low before next push)
    integer i;
    begin
      // 1) Present data FIRST
      step_count = count;

      // 2) Raise count_ready AFTER data is stable,
      //    timed so it's guaranteed high on the next posedge of clk
      @(negedge clk);
      count_ready = 1'b1;

      // 3) One-cycle strobe (sampled by DUT on this posedge)
      @(posedge clk);
      count_ready = 1'b0;

      // 4) Keep it low for the requested idle gap before next call
      if (idle_low_clks < 1) idle_low_clks = 1;
      for (i = 0; i < idle_low_clks; i = i + 1) begin
        @(posedge clk);
      end

      // Debug print each pushed second
      $display("[%0t] PUSH: steps=%0d  -> hi_steps=%0d done9=%0d",
               $time, count, hi_steps, done9);
    end
  endtask

  // Simple equality check (uses wide reg as pseudo-string)
  task check_eq;
    input [31:0] got;
    input [31:0] exp;
    input [127:0] label;
    begin
      if (got !== exp) begin
        $display("[%0t] FAIL: %s got=%0d exp=%0d", $time, label, got, exp);
        $stop;
      end else begin
        $display("[%0t] PASS: %s = %0d", $time, label, got);
      end
    end
  endtask

  initial begin
    // waveform dump (optional)
    $dumpfile("tb_count32_9sec.vcd");
    $dumpvars(0, tb_count32_9sec);

    // init
    count_ready = 1'b0;
    step_count  = 16'd0;
    reset       = 1'b1;
    repeat (3) @(posedge clk);
    reset = 1'b0;

    // -------------------------------
    // TEST 1: Mixed pattern → expect 6 highs out of 9
    // Seconds: 20,33,40,32,65,10,100,33,34  (">32" at 1,2,4,6,7,8)
    // Keep count_ready low for 2 cycles between pushes to mimic "real life"
    // -------------------------------
    push_second(16'd20, 2);   // 0: no
    push_second(16'd33, 2);   // 1: yes
    push_second(16'd40, 2);   // 2: yes
    push_second(16'd32, 2);   // 3: no
    push_second(16'd65, 2);   // 4: yes
    push_second(16'd10, 2);   // 5: no
    push_second(16'd100,2);   // 6: yes
    push_second(16'd33, 2);   // 7: yes
    push_second(16'd34, 2);   // 8: yes

    // Allow the done9 flop to update
    @(posedge clk);
    check_eq(done9,    1, "done9 after 9th second");
    check_eq(hi_steps, 6, "hi_steps after 9 seconds");

    // Extra seconds should be ignored (frozen)
    push_second(16'd80, 3);
    @(posedge clk);
    check_eq(done9,    1, "done9 remains high");
    check_eq(hi_steps, 6, "hi_steps frozen after window");

    // -------------------------------
    // TEST 2: Reset clears & restarts
    // -------------------------------
    reset = 1'b1; @(posedge clk); reset = 1'b0;
    @(posedge clk);
    check_eq(done9,    0, "done9 cleared by reset");
    check_eq(hi_steps, 0, "hi_steps cleared by reset");

    // All <=32 → expect 0
    push_second(16'd10, 1);
    push_second(16'd33, 1);
    push_second(16'd0 , 1);
    push_second(16'd31, 1);
    push_second(16'd5 , 1);
    push_second(16'd12, 1);
    push_second(16'd22, 1);
    push_second(16'd7 , 1);
    push_second(16'd32, 1);
    @(posedge clk);

    check_eq(done9,    1, "done9 after 9 low seconds");
    check_eq(hi_steps, 0, "hi_steps = 0 when none > 32");

    $display("All tests passed ✅");
    $finish;
  end

endmodule
