`timescale 1ns / 1ps

module fastadderrr(
    input  [31:0] A, B,
    input  Cin,
    output [31:0] Sum,
    output Cout
);
    wire [31:0] P, G;
    wire [32:0] Carry;

    assign P = A ^ B;
    assign G = A & B;

    assign Carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign Carry[i+1] = G[i] | (P[i] & Carry[i]);
        end
    endgenerate

    assign Sum = P ^ Carry[31:0];
    assign Cout = Carry[32];
endmodule
