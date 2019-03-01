module booth_pp_radix4_4bit (
    input  signed [3:0] A, B,   // multiplicand (4-bit signed)
    input        [2:0] y,   // Booth encoding group (yi+1, yi, yi-1)
    output reg signed [5:0] pp  // partial product (signed, up to ±2A)
);

    reg signed [5:0] core;  // internal value (extended multiplicand)

    always @(*) begin
        case (y)
            3'b000, 3'b111: core = 6'd0;            // 0
            3'b001, 3'b010: core = A;               // +A
            3'b011:          core = A <<< 1;        // +2A
            3'b100:          core = -(A <<< 1);     // -2A
            3'b101, 3'b110: core = -A;              // -A
            default:         core = 6'd0;
        endcase
        pp = core;
    end

endmodule
