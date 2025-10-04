`timescale 1ns / 1ps

module step_counter_tb;

    // Testbench signals
    reg load;
    reg enable;
    reg up;
    reg reset;
    reg clk;

    reg [3:0] D_ONES, D_TENS, D_HUNDREDS, D_THOUSANDS; // load values

    wire CO;
    wire [3:0] ONES, TENS, HUNDREDS, THOUSANDS; // outputs from DUT
    wire CO_ONES, CO_TENS, CO_HUNDREDS, CO_THOUSANDS; // individual carry outputs

    // DUT instantiation
    step_counter uut (
        .load(load),
        .enable(enable),
        .up(up),
        .reset(reset),
        .clk(clk),
        .CO(CO),
        .ones(ONES),
        .tens(TENS),
        .hundreds(HUNDREDS),
        .thousands(THOUSANDS),
        .D1(D_ONES),
        .D2(D_TENS),
        .D3(D_HUNDREDS),
        .D4(D_THOUSANDS),
        .co_ones(CO_ONES),
        .co_tens(CO_TENS),
        .co_hundreds(CO_HUNDREDS)
         );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk    = 0;
        reset  = 1;
        load   = 0;
        enable = 1;
        up     = 1;

        D_ONES      = 4'd0;
        D_TENS      = 4'd0;
        D_HUNDREDS  = 4'd0;
        D_THOUSANDS = 4'd0;

        // Reset pulse
        #10 reset = 0;
        #10 reset = 1;

        // Case 1: Load 9999
        D_ONES      = 4'd7;
        D_TENS      = 4'd9;
        D_HUNDREDS  = 4'd9;
        D_THOUSANDS = 4'd9;
        #5;
        load = 1;
        #10 load = 0;  // latch load
        enable = 1;
        up     = 1;
        #100;   // let it roll over

        // Case 2: Load 1234
        D_ONES      = 4'd4;
        D_TENS      = 4'd3;
        D_HUNDREDS  = 4'd2;
        D_THOUSANDS = 4'd1;
        #5;
        load = 1;
        #10 load = 0;
        #100;

        // Case 3: Count down from 5000
        D_ONES      = 4'd0;
        D_TENS      = 4'd0;
        D_HUNDREDS  = 4'd0;
        D_THOUSANDS = 4'd5;
        load = 1;
        #10 load = 0;
        up = 0;   // count down
        #120;

        // Finish simulation
        $stop;
    end

//    // Monitor outputs
//    initial begin
//        $monitor("T=%0t | rst=%b en=%b up=%b load=%b | D=%d%d%d%d | CNT=%d%d%d%d | CO=%b | COs={%b,%b,%b,%b}",
//                  $time, reset, enable, up, load,
//                  D_THOUSANDS, D_HUNDREDS, D_TENS, D_ONES,
//                  THOUSANDS, HUNDREDS, TENS, ONES,
//                  CO, CO_THOUSANDS, CO_HUNDREDS, CO_TENS, CO_ONES);
//    end

//    // Waveform dump for GTKWave
//    initial begin
//        $dumpfile("step_counter_tb.vcd");
//        $dumpvars(0, step_counter_tb);
//    end

endmodule
