// Converts 14-bit binary (0..9999) into 4 BCD digits.
// Combinational; fine for this width on an FPGA.
module bin_to_bcd_14 (
    input  [6:0] bin,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    integer i;
    reg [18:0] shift;  // [18:15]=hundreds, [14:11]=tens, [10:7]=ones, [6:0]=bin (7 bits)

    always @* begin
        shift = 19'd0;
        shift[6:0] = bin;      // load binary into LSBs
        // double-dabble: 7 iterations (one per input bit)
        for (i = 0; i < 7; i = i + 1) begin
            if (shift[18:15] >= 5) shift[18:15] = shift[18:15] + 4'd3; // hundreds
            if (shift[14:11] >= 5) shift[14:11] = shift[14:11] + 4'd3; // tens
            if (shift[10:7]  >= 5) shift[10:7]  = shift[10:7]  + 4'd3; // ones
            shift = shift << 1;
        end
        hundreds = shift[18:15];
        tens     = shift[14:11];
        ones     = shift[10:7];
    end
endmodule