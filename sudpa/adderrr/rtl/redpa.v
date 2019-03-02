`timescale 1ns / 1ps

module DPA1(
    cout,
    final_sum,
    a,
    b,
    cin,
    signed_en,
    negative_flag,
    overflow_flag,
    zero_flag
);
    parameter N = 64;
    input  [N-1:0] a, b;
    input          cin, signed_en;
    output [N-1:0] final_sum;
    output         cout;
    output         negative_flag;
    output         overflow_flag;
    output         zero_flag;

    // internal
    wire [N-1:0] p, g;
    wire [N:0]   c;
    wire [N-1:0] sum0, sum1;
    wire [N-1:0] raw_sum;
    wire [N-1:0] mag_sum; // magnitude of raw_sum when negative

    assign p = a ^ b;
    assign g = a & b;
    assign sum0 = p;
    assign sum1 = ~p;
    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : carry_logic
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate
    assign cout = c[N];

    genvar j;
    generate
        for (j = 0; j < N; j = j + 1) begin : sum_logic
            assign raw_sum[j] = c[j] ? sum1[j] : sum0[j];
        end
    endgenerate

    // magnitude conversion (if negative): magnitude = two's complement of raw_sum
    assign mag_sum = (~raw_sum) + 1'b1;

    // signed overflow computed from carries (correct even if we display magnitude)
    wire signed_overflow = c[N] ^ c[N-1];

    // final_sum: if signed_en and raw_sum MSB=1 -> show magnitude else show raw_sum
    assign final_sum = (signed_en && raw_sum[N-1]) ? mag_sum : raw_sum;

    // flags:
    assign zero_flag    = (final_sum == {N{1'b0}});    // reflects displayed value
    assign negative_flag= signed_en ? raw_sum[N-1] : 1'b0; // sign from raw sum
    assign overflow_flag= signed_en ? signed_overflow : cout; // signed or unsigned

endmodule

