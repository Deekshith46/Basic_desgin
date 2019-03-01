// ============================================================
// Parameterized 4:2 compressor (vector form)
// Adds: a + b + c + d + cin_chain  ==>  Sum + (Carry<<1)
// - cin_chain is a single-bit seed into bit[0] (usually 1'b0).
// - Internal cout[i] is fed to cin of bit i+1 (true 4:2 behavior).
// ============================================================
`timescale 1ns/1ps

module compressor42_vec (
    input  wire [63:0] a,
    input  wire [63:0] b,
    input  wire [63:0] c,
    input  wire [63:0] d,
    input  wire             cin_chain,   // seed for bit 0, normally 1'b0
    output wire [63:0] sum,         // same weight
    output wire [63:0] carry        // carry row (to be interpreted as <<1)
);
    // Internal per-bit carries between the two adders that form the 4:2
    wire [63:0] c1;
    wire [63:0] c2;
    wire [63:0] s1;

    // Per-bit "cout" from the 4:2 (goes to cin of next higher bit)
    wire [63:0] cout;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            // bit-local cin comes from previous bit's cout (chain)
            wire cin_i ;//= (i == 0) ? cin_chain : cout[i-1];
	if (i == 0) begin
      		assign cin_i = cin_chain;
	 end
    	else begin
      		assign cin_i = cout[i-1];
	 end

            // First FA: a + b + c -> s1, c1
            assign s1[i]  = a[i] ^ b[i] ^ c[i];
            assign cout[i]  = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);

            // Second FA: s1 + d + cin -> sum, c2
            assign sum[i] = s1[i] ^ d[i] ^ cin_i;
            assign carry[i]  = (s1[i] & d[i]) | (s1[i] & cin_i) | (d[i] & cin_i);

            // Combine carries:
            // (c1 + c2) contributes to bit i+1 and i+2.
            // carry (row) represents the bit-(i+1) contribution;
            // cout is the bit-(i+2) contribution that chains to cin of next bit.
            //assign carry[i] = c2[i];     // to weight i+1 (carry row)
            //assign cout[i]  = c1[i];     // forwarded to next bit's cin
        end
    endgenerate
endmodule

// ============================================================
// 16-to-2 Partial Product Reduction Tree using 4:2 compressors
// Layout matches the drawing:
//  Stage 1: 4 compressors on {P0..P3}, {P4..P7}, {P8..P11}, {P12..P15}
//  Stage 2: 2 compressors combining adjacent pairs of Stage 1 results
//  Stage 3: 1 compressor combining the two Stage 2 results
// Outputs: final SUM and CARRY rows (feed to a CPA next).
// ============================================================
module pp_tree16x64 (
    input  wire [63:0] P0,  input wire [63:0] P1,
    input  wire [63:0] P2,  input wire [63:0] P3,
    input  wire [63:0] P4,  input wire [63:0] P5,
    input  wire [63:0] P6,  input wire [63:0] P7,
    input  wire [63:0] P8,  input wire [63:0] P9,
    input  wire [63:0] P10, input wire [63:0] P11,
    input  wire [63:0] P12, input wire [63:0] P13,
    input  wire [63:0] P14, input wire [63:0] P15,
    output wire [63:0] SUM,     // final sum row
    output wire [63:0] CARRY//, c0, c1, c2, c3, c4, c5, s0, s1, s2, s3, s4, s5    // final carry row (interpret as <<1)
);
    wire [63:0] c0, c1, c2, c3, c4, c5, s0, s1, s2, s3, s4, s5;
    // ---------------- Stage 1 ----------------
    wire [63:0] cl0;
    wire [63:0] cl1;
    wire [63:0] cl2;
    wire [63:0] cl3;

    compressor42_vec S1_0 (
        .a(P0), .b(P1), .c(P2), .d(P3),
        .cin_chain(1'b0),
        .sum(s0), .carry(c0)
    );
    compressor42_vec S1_1 (
        .a(P4), .b(P5), .c(P6), .d(P7),
        .cin_chain(1'b0),
        .sum(s1), .carry(c1)
    );
    compressor42_vec S1_2 (
        .a(P8),  .b(P9),  .c(P10), .d(P11),
        .cin_chain(1'b0),
        .sum(s2), .carry(c2)
    );
    compressor42_vec S1_3 (
        .a(P12), .b(P13), .c(P14), .d(P15),
        .cin_chain(1'b0),
        .sum(s3), .carry(c3)
    );

    // ---------------- Stage 2 ----------------
    wire [63:0] cl4;
    wire [63:0] cl5;
    assign cl0 = (c0 << 1);
    assign cl1 = (c1 << 1);

    // Left half: combine {s0,c0,s1,c1}
    compressor42_vec S2_L (
        .a(s0), .b(cl0), .c(s1), .d(cl1),
        .cin_chain(1'b0),
        .sum(s4), .carry(c4)
    );

    // Right half: combine {s2,c2,s3,c3}
    assign cl2 = (c2 << 1);
    assign cl3 = (c3 << 1);
    compressor42_vec S2_R (
        .a(s2), .b(cl2), .c(s3), .d(cl3),
        .cin_chain(1'b0),
        .sum(s5), .carry(c5)
    );

    // ---------------- Stage 3 ----------------
    // Final reduction: {s4,c4,s5,c5} -> SUM, CARRY
    assign cl4 = (c4 << 1);
    assign cl5 = (c5 << 1);
    compressor42_vec S3_FINAL (
        .a(s4), .b(cl4), .c(s5), .d(cl5),
        .cin_chain(1'b0),
        .sum(SUM), .carry(CARRY)
    );

endmodule

