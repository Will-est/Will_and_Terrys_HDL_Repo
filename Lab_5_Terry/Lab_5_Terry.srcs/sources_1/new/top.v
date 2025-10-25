`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2025 12:59:04 AM
// Design Name: 
// Module Name: top
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
// thanks chat
//////////////////////////////////////////////////////////////////////////////////




module top(
    input clk,
    input  [3:0]  btn,          // BTN3..BTN0 (raw)
    input  [7:0]  sw,        // SW7..SW0
    output [7:0]  led,
    output [6:0]  seg,
    output [3:0]  an
);
 // btn[3:0] -> btnU, btnL, btnR, btnD
    wire btn_u, btn_l, btn_r, btn_d;
    DebounceSP DBU(.clk(clk), .btn_in(btn[3]), .btn_out(btn_u));
    DebounceSP DBL(.clk(clk), .btn_in(btn[2]), .btn_out(btn_l));
    DebounceSP DBR(.clk(clk), .btn_in(btn[1]), .btn_out(btn_r));
    DebounceSP DBD(.clk(clk), .btn_in(btn[0]), .btn_out(btn_d));
    
    wire [3:0] btn_pulse = {btn_u, btn_l, btn_r, btn_d};
    
    // data + mem signals that goes onto buses
    wire cs, we;
    wire [6:0] addr;
    wire [7:0] data_out_mem;
    wire [7:0] data_out_ctrl;
    wire [7:0] data_bus;
    
    // tri-state buffer stuff
    assign data_bus = (cs && we) ? data_out_ctrl : 8'bz;
    assign data_bus = (cs && ~we) ? data_out_mem : 8'bz;
    
    // controller
    wire [7:0] dvr;
    controller c1(
        .clk(clk),
        .cs(cs),
        .we(we),
        .addr(addr),
        .data_in(data_bus),
        .data_out_ctrl(data_out_ctrl),
        .btn_pulse(btn_pulse),
        .sw(sw),
        .leds(led),
        .dvr(dvr)
    );
    
    // memory
    memory m1(
        .clock(clk),
        .cs(cs),
        .we(we),
        .address(addr),
        .data_in(data_bus),
        .data_out(data_out_mem)
    );
    
    // BCD
    hex_bcd_2bit h1(
        .clk(clk),
        .bin(dvr),
        .seg(seg),
        .an(an)
    );

endmodule
