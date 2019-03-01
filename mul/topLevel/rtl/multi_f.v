`timescale 1ns/1ps

    module booth_radix4_multiplier (
    input  [31:0] A,     // Multiplicand
    input  [31:0] B,     // Multiplier
    input         alu_signed, // 1 = signed, 0 = unsigned
    output [63:0] PP0, PP1, PP2, PP3,
    output [63:0] PP4, PP5, PP6, PP7,
    output [63:0] PP8, PP9, PP10, PP11,
    output [63:0] PP12, PP13, PP14, PP15, PP16
);

    // Extended multiplier (conditionally signed or unsigned)
    reg [34:0] B_ext;
    reg [1:0] s, us;
    reg ne_1;
    always @(*) begin
	s = 2'b11;
    	us = 2'b00;
    	ne_1 = 1'b0;
        if (alu_signed && B[31] == 1'b1) begin
            // Signed extension for negative numbers
            B_ext = {s, B, ne_1};   // {sign, B, 0}
        end else begin
            // Unsigned extension with 0
            B_ext = {us, B, ne_1};   // {0, B, 0}
        end
    end

    reg  [63:0] partial [16:0];
    integer i;

    always @(*) begin
        for (i = 0; i < 17; i = i + 1) begin
            case (B_ext[2*i +: 3]) // Take 3-bit group
                3'b000, 3'b111: partial[i] = 64'b0;                     // 0 × A
                3'b001, 3'b010: partial[i] = {{32{A[31]}}, A} << (2*i); // +1 × A
                3'b011:         partial[i] = {{32{A[31]}}, A} << (2*i+1); // +2 × A
                3'b100:         partial[i] = -({{32{A[31]}}, A} << (2*i+1)); // -2 × A
                3'b101, 3'b110: partial[i] = -({{32{A[31]}}, A} << (2*i));   // -1 × A
                default:        partial[i] = 64'b0;
            endcase
        end
    end

    // Assign outputs to Wallace Tree inputs
    assign PP0  = partial[0];
    assign PP1  = partial[1];
    assign PP2  = partial[2];
    assign PP3  = partial[3];
    assign PP4  = partial[4];
    assign PP5  = partial[5];
    assign PP6  = partial[6];
    assign PP7  = partial[7];
    assign PP8  = partial[8];
    assign PP9  = partial[9];
    assign PP10 = partial[10];
    assign PP11 = partial[11];
    assign PP12 = partial[12];
    assign PP13 = partial[13];
    assign PP14 = partial[14];
    assign PP15 = partial[15];
    assign PP16 = partial[16];
endmodule

