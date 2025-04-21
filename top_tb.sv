`timescale 1ns / 1ps

module booth_wallace_cla_tb;

    reg signed [15:0] multiplicand, multiplier;
    wire signed [31:0] product;

    booth_wallace_cla uut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );

    initial begin
        $monitor("Time = %0t | A = %0d, B = %0d => Product = %0d", $time, multiplicand, multiplier, product);

        multiplicand = 16'h0003; multiplier = 16'h0002; #10;
        multiplicand = -16'h0003; multiplier = -16'h0002; #10;
        multiplicand = -16'h0003; multiplier = 16'h0002; #10;
        multiplicand = 16'h7FFF; multiplier = 16'h7FFF; #10;
        multiplicand = -16'h8000; multiplier = -16'h8000; #10;

        $finish;
    end
endmodule
