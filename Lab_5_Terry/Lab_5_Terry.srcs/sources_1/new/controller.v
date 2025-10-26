`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2025 10:29:29 PM
// Design Name: 
// Module Name: controller
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


module controller(
    input clk,
    // mem + bus
    output reg cs,
    output reg we,
    output reg [6:0] addr,
    input [7:0] data_in,
    output reg [7:0] data_out_ctrl,
    // user input ouput
    input [3:0] btn_pulse,
    input [7:0] sw,
    output [7:0] leds,
    // display 
    output reg[7:0] dvr
);
    // Registers
    reg [6:0] spr;
    reg [6:0] dar;
    // no stuff in stack
    wire empty = (spr == 7'h7F);
    // buttons
    wire M1 = btn_pulse[3];
    wire M0 = btn_pulse[2];
    wire A1 = btn_pulse[1];
    wire A0 = btn_pulse[0];
    // temp for arithmetic
    reg [7:0] var_a, var_b, sum, diff;
    initial begin
        spr = 7'h7F;
        dar = 7'h00;
        dvr = 8'h00;
        var_a = 8'h00;
        var_b = 8'h00;
        sum = 8'h00;
        diff = 8'h00;
    end
    
//    FSM states
//    IDLE: goes to next state when buttons are pushed
//    PUSH: 1) sw -> MEM[spr] 
//          2) spr --, dar <- spr+1
//    POP:  1) spr++, dar <- spr+1
//    ADD:  1) var_a = mem[spr + 1] 2 cyc
//          2) var_b = mem[spr + 2] 2 cyc, compute sum on 2nd cycle when mem is read
//          3) write to top of stack @ mem[spr+2] <- sum
//          4) spr = spr + 1, dar = spr + 1, and also initiate mem rd (dvr rd)
//    SUB:  1) var_a = mem[spr + 1] 2 cyc
//          2) var_b = mem[spr + 2] 2 cyc, compute diff on 2nd cycle when mem is read
//          3) write to top of stack @ mem[spr+2] <- diff
//          4) spr = spr + 1, dar = spr + 1, and also initiate mem rd (dvr rd)
//    TOP:  1) dar <- spr + 1, initiate mem rd (dvr rd)
//    CLR:  1) spr <- empty, dar <- 0x00, initiate mem rd
//    DARINC: 1) dar <- dar + 1, init mem rd
//    DARDEC: 1) dar <- dar - 1, init mem rd
    
//    MEMRD: 1)addr = dar
//           2)dvr = bin
//           IMPORTANT! next state is IDLE after memRD\
    localparam
        idle = 5'd0,
        push_1 = 5'd1,
        push_2 = 5'd2,
        pop = 5'd3,
        add_1 = 5'd4, 
        add_2 = 5'd5,
        add_3 = 5'd6,
        add_4 = 5'd7,
        add_5 = 5'd8,
        add_6 = 5'd9,
        sub_1 = 5'd10,
        sub_2 = 5'd11,
        sub_3 = 5'd12,
        sub_4 = 5'd13,
        sub_5 = 5'd14,
        sub_6 = 5'd15,
        top = 5'd16,
        clear = 5'd17,
        inc = 5'd18,
        dec = 5'd19,
        memrd_1 = 5'd20,
        memrd_2 = 5'd21;
    reg [4:0] ps, ns;
    initial ps = idle;
    
    // combinational next state + control signal
    always @* begin
        ns = ps;
        case(ps)
            idle: begin
                if (~M1 & ~M0 & A0) ns = push_1;
                else if (~M1 & ~M0 & A1) ns = pop;
                else if (~M1 & M0 & A0) ns = add_1;
                else if (~M1 & M0 & A1) ns = sub_1;
                else if (M1 & ~M0 & A0) ns = top;
                else if (M1 & ~M0 & A1) ns = clear;
                else if (M1 & M0 & A0) ns = inc;
                else if (M1 & M0 & A1) ns = dec;
            end
            // push
            push_1: begin
                cs = 1; we = 1; addr = spr; data_out_ctrl = sw;
                ns = push_2;
            end 
            push_2:
                ns = memrd_1;
            pop:
                ns = memrd_1;
            add_1: begin
                cs = 1; we = 0; addr = spr + 1;
                ns = add_2;
            end
            add_2:
                ns = add_3;
            add_3: begin
                cs = 1; we = 0; addr = spr + 2;
                ns = add_4;
            end
            add_4:
                ns = add_5;
            add_5: begin
                cs = 1; we = 1; addr = spr + 2; data_out_ctrl = sum;
                ns = add_6;
            end
            add_6:
                ns = memrd_1;
            sub_1: begin
                cs = 1; we = 0; addr = spr + 1;
                ns = sub_2;
            end
            sub_2:
                ns = sub_3;
            sub_3: begin
                cs = 1; we = 0; addr = spr + 2;
                ns = sub_4;
            end
            sub_4:
                ns = sub_5;
            sub_5: begin
                cs = 1; we = 1; addr = spr + 2; data_out_ctrl = diff;
                ns = sub_6;
            end
            sub_6:
                ns = memrd_1;
            top, inc, dec, clear:
                ns = memrd_1;
            memrd_1: begin
                cs = 1; we = 0; addr = dar;
                ns = memrd_2;
            end
            memrd_2:
                ns = idle;
        endcase
    end
    // rest of the memory stuff
    always @(posedge clk) begin
        ps <= ns;
        case(ps)
            add_2: var_a <= data_in;
            add_4: sum <= data_in + var_a;
            add_6: begin
               spr <= spr + 7'd1;
               dar <= spr + 7'd1;
            end
            sub_2: var_a <= data_in;
            sub_4: diff <= data_in - var_a;
            sub_6: begin
                spr <= spr + 7'd1;
                dar <= spr + 7'd1;
            end
            push_2: begin
               spr <= spr - 7'd1;
               dar <= spr;
            end
            pop: begin
                spr <= spr + 7'd1;
                dar <= spr + 7'd1;
            end
            top: dar <= spr + 7'd1;
            inc: dar <= dar + 7'd1;
            dec: dar <= dar - 7'd1;
            clear: begin
                spr <= 7'h7F;
                dar <= 7'h00;
                dvr <= 8'h00;
            end
            memrd_2: begin
                dvr <= data_in;
            end
        endcase
    end             
endmodule
