// ------------------------------------------------------------
// Radix-4 Booth Encoder + Partial Product Generator
// Fixed for 4-bit signed inputs
// ------------------------------------------------------------
module booth_pp_radix4_4bit (
    input  signed [3:0] A,   // multiplicand
    input  signed [3:0] B,   // multiplier
    output signed [7:0] P,   // final product
    output signed [7:0] pp0, // partial products
    output signed [7:0] pp1
);

    // There are (4+1)/2 = 2 groups for radix-4
    reg signed [7:0] pp [0:1];
    integer i;
    reg signed [7:0] sum;

    // helper function: safe multiplier bit with sign-extension
    function bit_at;
        input signed [3:0] X;
        input integer idx;
        begin
            if (idx < 0)        bit_at = 1'b0;
            else if (idx > 3)   bit_at = X[3]; // sign extend
            else                bit_at = X[idx];
        end
    endfunction

    always @* begin
        sum = 0;
        for (i = 0; i < 2; i = i+1) begin
            reg y2,y1,y0;
            reg signed [4:0] core; // +A, -A, +2A, -2A can exceed 4 bits

            y2 = bit_at(B, 2*i+1);
            y1 = bit_at(B, 2*i);
            y0 = bit_at(B, 2*i-1);

            case ({y2,y1,y0})
                3'b000, 3'b111: core = 0;          // 0
                3'b001, 3'b010: core =  A;         // +A
                3'b011:          core =  A <<< 1;  // +2A
                3'b100:          core = -(A <<< 1);// -2A
                3'b101, 3'b110:  core = -A;        // -A
                default:         core = 0;
            endcase

            // sign-extend and align (shift left by 2*i)
            pp[i] = {{(8-(5)){core[4]}}, core} <<< (2*i);
            sum = sum + pp[i];
        end
    end

    assign P   = sum;
    assign pp0 = pp[0];
    assign pp1 = pp[1];

endmodule
