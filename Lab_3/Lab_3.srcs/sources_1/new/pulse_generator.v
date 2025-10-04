`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Pulse Generator with 4 Modes (Hybrid uses 1Hz counter)
//////////////////////////////////////////////////////////////////////////////////
module pulse_generator (
    input        clk,       // 100 kHz input clock
    input        START,     // Start signal
    input  [1:0] MODE,      // Mode select: 00=Walk, 01=Jog, 10=Run, 11=Hybrid
    input        reset,     // System reset
    output wire  pulse_out, // One-cycle pulse output
    
    // Debugging
    output wire [31:0] div_value_out,
    output wire        one_hz_clk_out,
    output wire [16:0] count_out,
    output wire [3:0] state
);

    // Internal signals -------------------------------------------------
    reg [31:0] div_value;
    initial div_value = 32'd0;

    // For hybrid mode: 1Hz clock divider
    wire one_hz_clk; 
    
    
    // Instantiate main clk_divider (pulses) ----------------------------
    reg internal_reset;
    initial internal_reset =0;
    wire counter_clk;
    clk_divider counter_divider(
        .clk(clk),
        .slow_clk(counter_clk),
        .clk_bit_select((div_value)),
        .reset(reset || internal_reset )
    );

    // Hybrid Mode Module Setup -----------------------------------------
    wire [16:0] hybrid_sec_count;
    reg counter_enable;

    clk_divider one_hz_divider(
        .clk(clk),
        .slow_clk(one_hz_clk),
        .clk_bit_select(32'd100000000),   // 100 MHz / 100000000 = 1 Hz
//      .clk_bit_select(32'd2), // for debugging/simulating
        .reset(reset || ~counter_enable)
    );

    big_counter step_counter_combined(
        .enable(counter_enable),
        .reset(reset || ~counter_enable),
        .clk(one_hz_clk),
        .Data(4'd0),
        .OUT(hybrid_sec_count)
    );

    // Pulse generator FSM ----------------------------------------------
    reg [3:0] internal_state;
    initial internal_state = 4'd0;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            div_value      <= div_value;
            counter_enable <= 0;
            internal_reset <=1'b1;
        end else if (!START) begin
            div_value      <= div_value;
            counter_enable <= 0;
            internal_reset <=1'b1;
        end else begin
            case (MODE)
                2'b00: begin
                    // Walk mode: 32 pulses/sec
                    div_value      <= 32'd3125000;
//                    div_value      <= 32'd6250000;
//                  div_value      <= 32'd2;
                    counter_enable <= 0;
                    internal_reset <=1'b0;
                end
                2'b01: begin
                    // Jog mode: 64 pulses/sec
                    div_value      <= 32'd1562000;
//                    div_value      <= 32'd3124000;
//                    div_value      <= 32'd3;
                    counter_enable <= 0;
                    internal_reset <=1'b0;
                end
                2'b10: begin
                    // Run mode: 128 pulses/sec
                    div_value      <= 32'd781000;
//                    div_value      <= 32'd1562000;
//                    div_value      <= 32'd4;
                    counter_enable <= 0;
                    internal_reset <=1'b0;
                end
                2'b11: begin
                    // Hybrid mode
                    counter_enable <= 1;
                    if (hybrid_sec_count == 17'd0) begin
                        div_value <= 32'd0;
                        internal_reset <=1'b0;
                        internal_state <= 4'd0;
                    end else if (hybrid_sec_count == 17'd1) begin
                        div_value <= 32'd5000000;  // 20 pulses/sec
//                        div_value <= 32'd10000000;  // 20 pulses/sec
                        internal_reset <=1'b0;
                        internal_state <= 4'd1;
                    end else if (hybrid_sec_count == 17'd2) begin
                        div_value <= 32'd3030303;  // 33 pulses/sec
//                        div_value <= 32'd6060606;  // 33 pulses/sec
                        internal_reset <=1'b0;
                        internal_state <= 4'd2;
                    end else if (hybrid_sec_count == 17'd3) begin
                        div_value <= 32'd1515151;  // 66 pulses/sec
//                        div_value <= 32'd3030303;  // 66 pulses/sec
                        internal_reset <=1'b0;
                        internal_state <= 4'd3;
                    end else if (hybrid_sec_count == 17'd4) begin
                        div_value <= 32'd3703703;  // 27 pulses/sec
//                        div_value <= 32'd7407406;  // 27 pulses/sec
                        internal_reset <=1'b0;
                        internal_state <= 4'd4;
                    end else if (hybrid_sec_count == 17'd5) begin
                        div_value <= 32'd1428571;  // 70 pulses/sec
//                        div_value <= 32'd2857142;
                        internal_reset <=1'b0;
                        internal_state <= 4'd5;
                    end else if (hybrid_sec_count == 17'd6) begin
                        div_value <= 32'd3333333;  // 30 pulses/sec
//                        div_value <= 32'd6666666;
                        internal_reset <=1'b0;
                        internal_state <= 4'd6;
                    end else if (hybrid_sec_count == 17'd7) begin
                        div_value <= 32'd5263157;  // 19 pulses/sec
//                        div_value <= 32'd10526314;
                        internal_reset <=1'b0;
                        internal_state <= 4'd7;
                    end else if (hybrid_sec_count == 17'd8) begin
                        div_value <= 32'd3333333;  // 30 pulses/sec
//                        div_value <= 32'd6666666;
                        internal_reset <=1'b0;
                        internal_state <= 4'd0;
                    end else if (hybrid_sec_count == 17'd9) begin
                        div_value <= 32'd3030303;  // 33 pulses/sec
//                        div_value <= 32'd6060606;
                        internal_reset <=1'b0;
                        internal_state <= 4'd8;
                    end else if (hybrid_sec_count >= 17'd10 && hybrid_sec_count <= 17'd73) begin
                        div_value <= 32'd1449275;  // 69 pulses/sec
                        internal_reset <=1'b0;
                        internal_state <= 4'd9;
                    end else if (hybrid_sec_count >= 17'd74 && hybrid_sec_count <= 17'd79) begin
                        div_value <= 32'd2941176;  // 34 pulses/sec
                        internal_reset <=1'b0;
                        internal_state <= 4'd10;
                    end else if (hybrid_sec_count >= 17'd80 && hybrid_sec_count <= 17'd144) begin
                        div_value <= 32'd806451;   // 124 pulses/sec
                        internal_reset <=1'b0;
                        internal_state <= 4'd11;
                    end else begin
                        div_value <= 32'd0;        // No pulses after 145th sec
                        internal_reset <=1'b1;
                        internal_state <= 4'd12;
                    end
                end
            endcase
        end
    end

    // Final output logic ------------------------------------------------
    assign pulse_out     = counter_clk;

    // Debugging ---------------------------------------------------------
    assign one_hz_clk_out = one_hz_clk;
    assign div_value_out  = div_value;
    assign count_out      = hybrid_sec_count;
    assign state          = internal_state;

endmodule
