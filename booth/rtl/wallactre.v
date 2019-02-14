`timescale 1ns / 1ps

module wallactreeee(
    input [127:0] pp,
    output [31:0] sumlast1,
    output [31:0] sumlast2
);
    assign sumlast1 = pp[31:0];
    assign sumlast2 = pp[63:32];
endmodule
